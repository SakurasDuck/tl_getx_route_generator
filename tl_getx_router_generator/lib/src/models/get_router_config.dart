// import 'package:get/get.dart';
import 'package:collection/collection.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';

import 'importable_type.dart';

class GetXRouterConfig {
  final String routeName;
  final String constructorName;
  final ImportableType type;
  // final ImportableType? returnType;
  final List<ImportableType> parameters;
  final Map<String, dynamic> defaultValues;
  final ImportableType? parentRoute;
  final List<GetXRouterConfig> childrenConfig = [];

  //GetPage 路由配置参数
  final bool? opaque;
  final ImportableType? transition;
  final TlCurves? curve;
  final String? id;
  final bool fullscreenDialog;
  final List<ImportableType>? bindings;
  final bool preventDuplicates;
  final bool? popGesture;
  final bool showCupertinoParallax;

  GetXRouterConfig({
    required this.type,
    // required this.returnType,
    required this.routeName,
    required this.constructorName,
    required this.parameters,
    required this.defaultValues,
    required this.parentRoute,
    this.opaque,
    this.transition,
    this.curve,
    this.id,
    this.fullscreenDialog = false,
    this.bindings,
    this.preventDuplicates = false,
    this.popGesture,
    this.showCupertinoParallax = false,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.toMap(),
      // 'returnType': returnType?.toMap(),
      'routeName': routeName,
      'constructorName': constructorName,
      'parameters': parameters.map((x) => x.toMap()).toList(),
      'parentRoute': parentRoute?.toMap(),
      'defaultValues': defaultValues,
      'opaque': opaque,
      'transition': transition?.toMap(),
      'curve': curve?.index,
      'id': id,
      'fullscreenDialog': fullscreenDialog,
      'bindings': bindings?.map((x) => x.toMap()).toList(),
      'preventDuplicates': preventDuplicates,
      'popGesture': popGesture,
      'showCupertinoParallax': showCupertinoParallax,
    };
  }

  factory GetXRouterConfig.fromMap(Map<String, dynamic> map) {
    return GetXRouterConfig(
      type: ImportableType.fromMap(map['type'] as Map<String, dynamic>),
      // returnType: map['returnType'] != null
      //     ? ImportableType.fromMap(map['returnType'] as Map<String, dynamic>)
      //     : null,
      routeName: map['routeName'] as String? ?? '',
      constructorName: map['constructorName'] as String? ?? '',
      parameters: List<ImportableType>.from(map['parameters']?.map(
              (dynamic x) => ImportableType.fromMap(x as Map<String, dynamic>))
          as Iterable),
      parentRoute: map['parentRoute'] != null
          ? ImportableType.fromMap(map['parentRoute'] as Map<String, dynamic>)
          : null,
      defaultValues:
          map['defaultValues'] as Map<String, dynamic>? ?? <String, dynamic>{},
      opaque: map['opaque'] as bool?,
      transition: map['transition'] != null
          ? ImportableType.fromMap(map['transition'] as Map<String, dynamic>)
          : null,
      curve: map['curve'] != null
          ? TlCurves.values.firstWhereOrNull(
              (e) => e.index == map['curve'],
            )
          : null,
      id: map['id'] as String?,
      fullscreenDialog: map['fullscreenDialog'] as bool,
      bindings: map['bindings'] != null
          ? List<ImportableType>.from(map['bindings']?.map((dynamic x) =>
              ImportableType.fromMap(x as Map<String, dynamic>)) as Iterable)
          : null,
      preventDuplicates: map['preventDuplicates'] as bool,
      popGesture: map['popGesture'] as bool?,
      showCupertinoParallax: map['showCupertinoParallax'] as bool,
    );
  }
}
