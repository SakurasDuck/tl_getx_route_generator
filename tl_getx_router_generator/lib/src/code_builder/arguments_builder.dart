import 'package:code_builder/code_builder.dart';
import 'package:tl_getx_router_generator/src/utils/utils.dart';

import '../models/get_router_config.dart';
import '../utils/case_utils.dart';

class ArgumentsBuilder {
  final GetXRouterConfig annotations;
  final String className;
  final Uri? targetFile;

  ArgumentsBuilder({
    required this.annotations,
    required this.className,
    this.targetFile,
  });

  Library generate() {
    return Library((b) => b
      ..directives.addAll([
        Directive.import('package:get/get.dart'),
      ])
      ..body.addAll([
        Class((b) => b
          ..name = '${className}Args'
          ..methods.addAll(annotations.parameters.map((arg) => Method((b) => b
            ..static = true
            ..lambda = true
            ..type = MethodType.getter
            ..returns = arg.returnType != null
                ? Reference(CaseUtil(arg.name ??
                        'arg_${annotations.parameters.indexOf(arg)}')
                    .upperCamelCase)
                : typeRefer(arg)
            ..name = arg.name ?? arg.className
            ..body = Reference("Get.arguments?['${arg.argumentName}']")
                .asA(arg.returnType != null
                    ? Reference(CaseUtil(arg.name ??
                            'arg_${annotations.parameters.indexOf(arg)}')
                        .upperCamelCase)
                    : typeRefer(arg))
                .code)))),
        if (annotations.parameters
            .where((element) => element.returnType != null)
            .isNotEmpty)
          ...annotations.argumentsFunctions,
      ]));
  }
}
