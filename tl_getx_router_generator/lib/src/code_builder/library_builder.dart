import 'package:built_collection/built_collection.dart';
import 'package:code_builder/code_builder.dart';

import '../models/get_router_config.dart';
import '../utils/case_utils.dart';
import '../utils/convert_bindings.dart';
import '../utils/utils.dart';

class LibraryGenerator {
  final Set<GetXRouterConfig> routes;
  final String className;
  final Uri? targetFile;
  final String? moduleName;

  // final ImportableType? pageType;
  // final List<String> removeSuffixes;

  LibraryGenerator({
    required this.routes,
    required this.className,
    required this.moduleName,
    this.targetFile,
  });

  Library generate() {
    return Library(
      (b) => b
        ..ignoreForFile.addAll([
          'unnecessary_parenthesis',
          'depend_on_referenced_packages',
          'prefer_const_constructors',
          'prefer_const_literals_to_create_immutables'
        ])
        ..directives.addAll([
          Directive.import('package:get/get.dart'),
        ])
        ..body.addAll(
          [
            //路由Pages
            Mixin((b) => b
              ..name = className
              ..fields.add(Field(
                (b) => b
                  ..name = 'pages'
                  ..static = true
                  ..modifier = FieldModifier.final$
                  ..assignment = literalList(routes
                          .map((route) => _resolveGetPage(route))
                          .toList())
                      .code,
              ))),
            // 路由Names
            Class(
              (b) {
                b
                  ..name = 'RouteNames'
                  ..fields
                      .addAll(_revolveRouterTree([], routes.toList(), null));
              },
            ),
            // 路由typed
            ..._resolverTypedRouter(routes.toList()),
          ],
        ),
    );
  }

  Expression _resolveGetPage(GetXRouterConfig route) {
    return TypeReference(
      (b) {
        b
          ..symbol = 'GetPage'
          ..types.add(
              // route.returnType != null
              // ? typeRefer(route.returnType!, targetFile: targetFile)
              // :
              const Reference('dynamic'));
      },
    ).call([], {
      'name': Reference(_convertGetPageName(route)),
      'bindings': route.bindings == null
          ? literalList([typeRefer(convertBindings(route.type)).call([])])
          : literalList(route.bindings!.map((e) => typeRefer(
                e,
                targetFile: targetFile,
              ).call([]))),
      'page': Method(
        (b) => b
          ..name = ''
          ..body = Reference(
            route.constructorName == route.type.className ||
                    route.constructorName.isEmpty
                ? route.type.className
                : '${route.type.className}.${route.constructorName}',
            typeRefer(route.type, targetFile: targetFile).url,
          ).call(
              [],
              route.parameters.asMap().map((_, p) => MapEntry(
                  p.argumentName,
                  Reference("Get.arguments?['${p.argumentName}']")
                      .asA(typeRefer(p, targetFile: targetFile))))).code,
      ).closure,
      if (route.transition != null)
        'transition':
            CodeExpression(Code('Transition.${route.transition!.name}')),
      if (route.curve != null)
        'curve': CodeExpression(Code('Curves.${route.curve!.name}')),
      'fullscreenDialog': literalBool(route.fullscreenDialog),
      'preventDuplicates': literalBool(route.preventDuplicates),
      'showCupertinoParallax': literalBool(route.showCupertinoParallax),
      if (route.childrenConfig.isNotEmpty)
        'children': literalList(
            route.childrenConfig.map((e) => _resolveGetPage(e)).toList()),
    });
  }

  List<Field> _revolveRouterTree(
      List<Field> router, List<GetXRouterConfig> routes, String? parentRoute) {
    for (final item in routes) {
      final routeName =
          '${parentRoute ?? (moduleName?.isNotEmpty == true ? '/$moduleName' : '')}/${CaseUtil(item.routeName).snakeCase}';
      router.add(Field(
        (b) => b
          ..name = CaseUtil(item.routeName).camelCase
          ..static = true
          ..modifier = FieldModifier.constant
          ..assignment = Code("'$routeName'"),
      ));
      if (item.childrenConfig.isNotEmpty == true) {
        _revolveRouterTree(router, item.childrenConfig, routeName);
      }
    }

    return router;
  }

  List<Class> _resolverTypedRouter(List<GetXRouterConfig> routes) {
    final typedRouters = <Class>[];
    void resolver(List<GetXRouterConfig> routes) {
      for (final route in routes) {
        typedRouters.add(Class((b) => b
          ..name = '${CaseUtil(route.routeName).upperCamelCase}TypedRoute'
          ..constructors = ListBuilder([
            Constructor((b) => b
              ..optionalParameters.addAll([
                for (final args in route.parameters)
                  Parameter((b) => b
                    ..named = true
                    ..required = args.isRequired
                    ..name = args.argumentName
                    ..type = typeRefer(args, targetFile: targetFile))
              ])
              ..body = Block((b) => b
                ..statements.addAll([
                  for (final item in route.parameters)
                    Code(
                        "super.arguments.addAll({'${item.argumentName}': ${item.argumentName}});")
                ])))
          ])
          ..extend = const Reference(
            'TypedTlGetRouter',
            'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart',
          )
          ..fields.add(Field(
            (b) => b
              ..name = 'routeName'
              ..modifier = FieldModifier.final$
              ..annotations.add(const CodeExpression(Code('override')))
              ..assignment =
                  Reference('RouteNames.${CaseUtil(route.routeName).camelCase}')
                      .code,
          ))));
        if (route.childrenConfig.isNotEmpty) {
          resolver(route.childrenConfig);
        }
      }
    }

    resolver(routes);
    return typedRouters;
  }

  String _convertGetPageName(GetXRouterConfig route) {
    if (route.parentRoute != null) {
      return "'/${CaseUtil(route.routeName).snakeCase}'";
    } else {
      return "'${moduleName?.isNotEmpty == true ? '/$moduleName' : ''}/${CaseUtil(route.routeName).snakeCase}'";
    }
  }
}
