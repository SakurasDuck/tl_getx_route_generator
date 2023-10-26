import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:glob/glob.dart';
import 'package:source_gen/source_gen.dart';

import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';

import '../code_builder/library_builder.dart';
import '../models/get_router_config.dart';
import '../resolvers/importable_type_resolver.dart';

class TLGetXRouterConfigGenerator
    extends GeneratorForAnnotation<TLGetXRouterConfig> {
  static const _navigatorClassNameDefault = 'BaseNavigator';

  @override
  dynamic generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) async {
    final typeResolver =
        ImportableTypeResolverImpl(await buildStep.resolver.libraries.toList());
    final configFiles = Glob('**.get_x_router.json');
    final moduleName =
        annotation.peek('moduleName')?.stringValue;
    final jsonData = <Map>[];

    await for (final id in buildStep.findAssets(configFiles)) {
      final dynamic json = jsonDecode(await buildStep.readAsString(id));
      jsonData.addAll((json as List).map((dynamic e) => e as Map).toList());
    }

    final routes = <GetXRouterConfig>{};
    for (final json in jsonData) {
      routes.add(GetXRouterConfig.fromMap(json as Map<String, dynamic>));
    }

    //这里处理一下路由的继承关系
    final tobeDelete = <GetXRouterConfig>[];
    for (final route in routes) {
      if (route.parentRoute != null) {
        final parentRoute = routes.firstWhere(
            (element) => element.type == route.parentRoute,
            orElse: () => throw Exception(
                'parentRoute ${route.parentRoute} not found in routes'));
        parentRoute.childrenConfig.add(route);
        tobeDelete.add(route);
      }
    }
    routes.removeAll(tobeDelete);

    final generator = LibraryGenerator(
      routes: routes,
      className: '${element.displayName}Mixin',
      targetFile: element.source?.uri,
      moduleName: moduleName,
      // pageType: pageType,
      // removeSuffixes: removeSuffixes,
    );

    final generatedLib = generator.generate();

    final emitter = DartEmitter(
      allocator: Allocator.simplePrefixing(),
      orderDirectives: true,
      useNullSafetySyntax: true,
    );

    return DartFormatter().format(generatedLib.accept(emitter).toString());
  }
}
