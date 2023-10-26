import 'package:code_builder/code_builder.dart';
import 'package:tl_getx_router_generator/src/utils/utils.dart';

import '../models/get_router_config.dart';
import '../utils/case_utils.dart';

class ArgumensBuilder {
  final GetXRouterConfig annotations;
  final String className;
  final Uri? targetFile;
  ArgumensBuilder({
    required this.annotations,
    required this.className,
    this.targetFile,
  });

  Library generate() {
    return Library((b) => b
      ..directives.addAll([
        Directive.import('package:get/get.dart'),
      ])
      ..body.add(Extension((b) => b
        ..name = '${className}ArgsExt'
        ..on = refer('Object')
        ..methods.addAll(annotations.parameters.map((arg) => Method((b) => b
          ..lambda = true
          ..type = MethodType.getter
          ..returns = typeRefer(arg, targetFile: targetFile)
          ..name =
              CaseUtil(arg.name ?? 'arg_${annotations.parameters.indexOf(arg)}')
                  .camelCase
          ..body = Reference("Get.arguments?['${arg.argumentName}']")
              .asA(typeRefer(arg, targetFile: targetFile))
              .code))))));
  }
}
