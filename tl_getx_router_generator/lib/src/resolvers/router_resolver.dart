import 'package:analyzer/dart/element/element.dart';
import 'package:source_gen/source_gen.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';

import '../models/get_router_config.dart';
import '../utils/case_utils.dart';
import 'importable_type_resolver.dart';

const TypeChecker _getXRouteChecker = TypeChecker.fromRuntime(GetXRoute);

class RouteResolver {
  final ImportableTypeResolverImpl _typeResolver;

  RouteResolver(List<LibraryElement> libs)
      : _typeResolver = ImportableTypeResolverImpl(libs);

  List<GetXRouterConfig> resolve(ClassElement clazz) {
    final annotatedElement = clazz;
    final getXRouteAnnotations = _getXRouteChecker
        .annotationsOf(annotatedElement, throwOnUnresolved: false);
    return getXRouteAnnotations.map((getXRouteAnnotation) {
      final getXRoute = ConstantReader(getXRouteAnnotation);
      final routeNameValue = getXRoute.peek('routeName')?.stringValue;
      final routeName = routeNameValue ?? CaseUtil(clazz.name).kebabCase;
      // final returnType = getXRoute.peek('returnType')?.typeValue;
      final parentRoute = getXRoute.peek('parentRoute')?.typeValue;
      final opaque = getXRoute.peek('opaque')?.boolValue;
      final transition = getXRoute.peek('transition')?.typeValue;
      final curve = getXRoute.peek('curve')?.typeValue;
      final id = getXRoute.peek('id')?.stringValue;
      final fullscreenDialog = getXRoute.peek('fullscreenDialog')?.boolValue;
      final bindings = getXRoute.peek('bindings')?.listValue;
      final preventDuplicates = getXRoute.peek('preventDuplicates')?.boolValue;
      final popGesture = getXRoute.peek('popGesture')?.boolValue;
      final showCupertinoParallax =
          getXRoute.peek('showCupertinoParallax')?.boolValue;

      // 直接获取第一个构造函数
      final constructor = clazz.constructors.first;

      return GetXRouterConfig(
        type: _typeResolver.resolveType(annotatedElement.thisType),
        // returnType: returnType == null
        //     ? null
        //     : _typeResolver.resolveType(
        //         returnType,
        //         forceNullable: true,
        //       ),
        constructorName: constructor.name,
        parameters: constructor.parameters
            .map((p) => _typeResolver.resolveType(
                  p.type,
                  isRequired: p.isRequired,
                  name: p.name,
                ))
            .toList(),
        defaultValues: ((constructor.parameters.asMap().map<String, dynamic>(
                (_, p) =>
                    MapEntry<String, dynamic>(p.name, p.defaultValueCode)))
              ..removeWhere((key, dynamic value) => value == null))
            .cast<String, String>(),
        routeName: routeName,
        parentRoute: parentRoute == null
            ? null
            : _typeResolver.resolveType(
                parentRoute,
              ),
        opaque: opaque,
        transition: transition == null
            ? null
            : _typeResolver.resolveType(
                transition,
              ),
        curve: curve == null
            ? null
            : TlCurves.values.firstWhere(
                (e) => e.name == curve.getDisplayString(withNullability: false),
                orElse: () => TlCurves.easeInOut,
              ),
        id: id,
        fullscreenDialog: fullscreenDialog == true,
        bindings:
            bindings?.map((e) => _typeResolver.resolveType(e.toTypeValue()!)).toList(),
        preventDuplicates: preventDuplicates == true,
        popGesture: popGesture,
        showCupertinoParallax: showCupertinoParallax == true,
      );
    }).toList();
  }
}
