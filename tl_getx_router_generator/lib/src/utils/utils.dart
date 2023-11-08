// general utils
import 'package:analyzer/dart/element/element.dart';
import 'package:code_builder/code_builder.dart';
import 'package:source_gen/source_gen.dart';

import '../models/get_router_config.dart';
import '../models/importable_type.dart';
import '../resolvers/importable_type_resolver.dart';
import 'case_utils.dart';

String capitalize(String s) {
  if (s.length < 2) {
    return s.toUpperCase();
  }
  return s[0].toUpperCase() + s.substring(1);
}

String toCamelCase(String s) {
  if (s.length < 2) {
    return s.toLowerCase();
  }
  return s[0].toLowerCase() + s.substring(1);
}

void throwBoxed(String message) {
  const pre = 'Injectable Generator ';
  throw ("\n${pre.padRight(72, '-')}\n$message\n${''.padRight(72, '-')} \n");
}

void throwSourceError(String message) {
  const pre = 'Injectable Generator ';
  throw ("\n${pre.padRight(72, '-')}\n$message\n${''.padRight(72, '-')} \n");
}

void throwError(String message, {Element? element}) {
  throw InvalidGenerationSourceError(
    message,
    element: element,
  );
}

void throwIf(bool condition, String message, {Element? element}) {
  if (condition) {
    throw InvalidGenerationSourceError(
      message,
      element: element,
    );
  }
}

void printBoxed(String message,
    {String header = '--------------------------'}) {
  final pre = header;
  // ignore: avoid_print
  print("$pre\n$message\n${''.padRight(72, '-')} \n");
}

Reference typeRefer(
  ImportableType? type, {
  Uri? targetFile,
  bool withNullabilitySuffix = true,
  bool forceNullable = false,
  bool forceFuture = false,
}) {
  final TypeReference typeReference;
  if (type == null) {
    typeReference = TypeReference((r) => r..symbol = 'void');
  } else if (type.returnType != null) {
    //判断returnType是否为空代表是否是FunctionType
    return TypeReference((r) {
      r
        ..symbol = type.className
        ..url = type.returnType!.import;
      if (type.typeArguments.isNotEmpty) {
        r.types.addAll(
          type.typeArguments.map((e) => typeRefer(
                e,
                targetFile: targetFile,
                withNullabilitySuffix: withNullabilitySuffix,
              )),
        );
      }
    });
  } else {
    final relativeImport = targetFile == null
        ? ImportableTypeResolver.resolveAssetImport(type.import)
        : ImportableTypeResolver.relative(type.import, targetFile);
    typeReference = TypeReference((reference) {
      reference
        ..symbol = type.className
        ..url = relativeImport
        ..isNullable =
            withNullabilitySuffix && (forceNullable || type.isNullable);
      if (type.typeArguments.isNotEmpty) {
        reference.types.addAll(
          type.typeArguments.map((e) => typeRefer(
                e,
                targetFile: targetFile,
                withNullabilitySuffix: withNullabilitySuffix,
              )),
        );
      }
    });
  }
  if (!forceFuture) return typeReference;
  return TypeReference(
    (r) => r
      ..symbol = 'Future'
      ..types.add(typeReference),
  );
}

//获取需要取别名的arguments functions
//typedef
extension GetXRouterConfigExtension on GetXRouterConfig {
  List<TypeDef> get argumentsFunctions {
    return parameters
        .where((e) => e.returnType != null)
        .map((arg) => TypeDef((b) => b
          ..name = CaseUtil(arg.name ?? 'arg_${parameters.indexOf(arg)}')
              .upperCamelCase
          ..definition = FunctionType((e) => e
            ..returnType = typeRefer(
              arg.returnType,
            )
            ..namedParameters.addAll({
              for (final p in arg.typeArguments)
                if (!p.isRequired) p.name ?? p.className: typeRefer(p)
            })
            ..namedRequiredParameters.addAll({
              for (final p in arg.typeArguments)
                if (p.isRequired) p.name ?? p.className: typeRefer(p)
            }))))
        .toList();
  }
}
