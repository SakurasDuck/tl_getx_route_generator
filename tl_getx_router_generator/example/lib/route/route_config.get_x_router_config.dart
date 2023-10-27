// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TLGetXRouterConfigGenerator
// **************************************************************************

// ignore_for_file: depend_on_referenced_packages, prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables
// ignore_for_file: unnecessary_parenthesis

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:example/page_a/binding.dart' as _i1;
import 'package:flutter/material.dart' as _i3;
import 'package:get/get.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart'
    as _i9;

import '../page_a/view.dart' as _i2;
import '../page_a_child/binding.dart' as _i4;
import '../page_a_child/view.dart' as _i5;
import '../page_b/binding.dart' as _i6;
import '../page_b/other_binding.dart' as _i7;
import '../page_b/view.dart' as _i8;

mixin TestRouteConfigMixin {
  static final pages = [
    GetPage<dynamic>(
      name: '/example/page_a_view',
      bindings: [_i1.PageABinding()],
      page: () => _i2.PageAView(
        tag: (Get.arguments?['tag'] as String?),
        key: (Get.arguments?['key'] as _i3.Key?),
      ),
      fullscreenDialog: false,
      preventDuplicates: true,
      showCupertinoParallax: true,
      children: [
        GetPage<dynamic>(
          name: '/a_child',
          bindings: [_i4.PageAChildBinding()],
          page: () => _i5.PageAChildView(
            tag: (Get.arguments?['tag'] as String?),
            key: (Get.arguments?['key'] as _i3.Key?),
          ),
          fullscreenDialog: false,
          preventDuplicates: true,
          showCupertinoParallax: true,
        )
      ],
    ),
    GetPage<dynamic>(
      name: '/example/page_b',
      bindings: [
        _i6.PageBBinding(),
        _i7.OtherBinding(),
      ],
      page: () => _i8.PageBView(
        tag: (Get.arguments?['tag'] as String?),
        key: (Get.arguments?['key'] as _i3.Key?),
      ),
      fullscreenDialog: false,
      preventDuplicates: true,
      showCupertinoParallax: true,
    ),
  ];
}

class RouteNames {
  static const pageAView = '/example/page_a_view';

  static const aChild = '/example/page_a_view/a_child';

  static const pageB = '/example/page_b';
}

class PageAViewTypedRoute extends _i9.TypedTlGetRouter {
  PageAViewTypedRoute({
    String? tag,
    _i3.Key? key,
  }) {
    super.arguments.addAll({'tag': tag});
    super.arguments.addAll({'key': key});
  }

  @override
  final routeName = RouteNames.pageAView;
}

class AChildTypedRoute extends _i9.TypedTlGetRouter {
  AChildTypedRoute({
    String? tag,
    _i3.Key? key,
  }) {
    super.arguments.addAll({'tag': tag});
    super.arguments.addAll({'key': key});
  }

  @override
  final routeName = RouteNames.aChild;
}

class PageBTypedRoute extends _i9.TypedTlGetRouter {
  PageBTypedRoute({
    String? tag,
    _i3.Key? key,
  }) {
    super.arguments.addAll({'tag': tag});
    super.arguments.addAll({'key': key});
  }

  @override
  final routeName = RouteNames.pageB;
}
