import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:code_builder/code_builder.dart';
import 'package:dart_style/dart_style.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';

import '../code_builder/arguments_builder.dart';
import '../resolvers/router_resolver.dart';

const TypeChecker _typeChecker = TypeChecker.fromRuntime(GetXRoute);

class TLGetXRouterGenerator implements Generator {
  const TLGetXRouterGenerator();

  @override
  FutureOr<String> generate(LibraryReader library, BuildStep buildStep) async {
    final routesInStep = (await Future.wait(
      library.classes.where(_typeChecker.hasAnnotationOf).map(
            (e) async => RouteResolver(
              await buildStep.resolver.libraries.toList(),
            ).resolve(e),
          ),
    ))
        .expand((element) => element);
    return routesInStep.isNotEmpty
        ? jsonEncode(routesInStep.map((e) => e.toMap()).toList())
        : '';
  }
}


class TLGetXRouterArgumentsGenerator extends  GeneratorForAnnotation<GetXRoute>{
  @override
  dynamic generateForAnnotatedElement(Element element, ConstantReader annotation, BuildStep buildStep) async{
     final routeAnnotation=  RouteResolver(
              await buildStep.resolver.libraries.toList(),
            ).resolve(element as ClassElement);

        final generator = ArgumensBuilder(
      annotations: routeAnnotation.first,
      className: '${element.displayName}Mixin',
      targetFile: element.source.uri,
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