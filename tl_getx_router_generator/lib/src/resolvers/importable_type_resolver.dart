import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/nullability_suffix.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:path/path.dart' as p;

import '../models/importable_type.dart';

abstract class ImportableTypeResolver {
  String? resolveImport(Element element);

  ImportableType resolveType(
    DartType type, {
    bool isRequired = false,
    String? name,
    bool forceNullable = false,
  });

  ImportableType resolveFunctionType(
    FunctionType function,
  );

  static String? relative(String? path, Uri? to) {
    if (path == null || to == null) {
      return null;
    }
    final fileUri = Uri.parse(path);
    final libName = to.pathSegments.first;
    if ((to.scheme == 'package' &&
            fileUri.scheme == 'package' &&
            fileUri.pathSegments.first == libName) ||
        (to.scheme == 'asset' && fileUri.scheme != 'package')) {
      if (fileUri.path == to.path) {
        return fileUri.pathSegments.last;
      } else {
        return p.posix
            .relative(fileUri.path, from: to.path)
            .replaceFirst('../', '');
      }
    } else {
      return path;
    }
  }

  static String? resolveAssetImport(String? path) {
    if (path == null) {
      return null;
    }
    final fileUri = Uri.parse(path);
    if (fileUri.scheme == 'asset') {
      return '/${fileUri.path}';
    }
    return path;
  }
}

class ImportableTypeResolverImpl extends ImportableTypeResolver {
  final List<LibraryElement> libs;

  ImportableTypeResolverImpl(this.libs);

  @override
  String? resolveImport(Element? element) {
    // return early if source is null or element is a core type
    if (element?.source == null || _isCoreDartType(element)) {
      return null;
    }

    for (var lib in libs) {
      if (!_isCoreDartType(lib) &&
          lib.exportNamespace.definedNames.values.contains(element)) {
        return lib.identifier;
      }
    }
    return null;
  }

  bool _isCoreDartType(Element? element) {
    return element?.source?.fullName == 'dart:core';
  }

  @override
  ImportableType resolveFunctionType(FunctionType function) {
    final aliasFunction = function.alias?.element;
    if (aliasFunction == null) {
      return ImportableType(
        className: '',
        typeArguments: _resolveTypeArguments(function),
        returnType: ImportableType(
          className: function.returnType.element?.name ??
              function.returnType.getDisplayString(withNullability: false),
          import: resolveImport(function.returnType.element),
          isNullable: function.returnType.nullabilitySuffix ==
              NullabilitySuffix.question,
          typeArguments: _resolveTypeArguments(function.returnType),
        ),
      );
    } else {
      final displayName = aliasFunction.displayName;
      var functionName = displayName;

      Element elementToImport = aliasFunction;
      final enclosingElement = aliasFunction.enclosingElement;

      if (enclosingElement is ClassElement) {
        functionName = '${enclosingElement.displayName}.$displayName';
        elementToImport = enclosingElement;
      }

      return ImportableType(
        className: functionName,
        import: resolveImport(elementToImport),
        isNullable: function.nullabilitySuffix == NullabilitySuffix.question,
      );
    }
  }

  List<ImportableType> _resolveTypeArguments(DartType typeToCheck) {
    final importableTypes = <ImportableType>[];
    if (typeToCheck is ParameterizedType) {
      for (DartType type in typeToCheck.typeArguments) {
        if (type.element is TypeParameterElement) {
          importableTypes.add(const ImportableType(
            className: 'dynamic',
          ));
        } else {
          importableTypes.add(ImportableType(
            className: type.element?.name?.replaceAll('?', '') ??
                type.getDisplayString(withNullability: false),
            import: resolveImport(type.element),
            isNullable: type.nullabilitySuffix == NullabilitySuffix.question,
            typeArguments: _resolveTypeArguments(type),
          ));
        }
      }
    }
    if (typeToCheck is FunctionType) {
      for (final arg in typeToCheck.parameters) {
        importableTypes.add(ImportableType(
          className: arg.type.element?.name?.replaceAll('?', '') ??
              arg.type.getDisplayString(withNullability: false),
          name: arg.name,
          import: resolveImport(arg.type.element),
          isRequired: arg.isRequiredNamed || arg.isRequiredPositional,
          isNullable: arg.type.nullabilitySuffix == NullabilitySuffix.question,
          typeArguments: _resolveTypeArguments(arg.type),
        ));
      }
    }

    return importableTypes;
  }

  @override
  ImportableType resolveType(
    DartType type, {
    bool isRequired = false,
    String? name,
    bool forceNullable = false,
    Element? element,
    bool isOptional = false,
    bool isPositional = false,
  }) {
    ImportableType? functionTypeImpl;
    if (type is FunctionType) {
      functionTypeImpl = resolveFunctionType(
        type,
      );
    }

    return ImportableType(
      className: functionTypeImpl?.className ??
          type.element?.name ??
          type.getDisplayString(withNullability: false),
      name: name,
      isNullable:
          forceNullable || type.nullabilitySuffix == NullabilitySuffix.question,
      import: functionTypeImpl?.import ?? resolveImport(type.element),
      isRequired: isRequired,
      isOptional: isOptional,
      isPositional: isPositional,
      typeArguments:
          functionTypeImpl?.typeArguments ?? _resolveTypeArguments(type),
      returnType: functionTypeImpl?.returnType,
    );
  }
}
