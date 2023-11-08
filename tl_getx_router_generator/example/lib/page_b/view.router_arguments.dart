// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// TLGetXRouterArgumentsGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i2;

import 'package:flutter/material.dart' as _i1;
import 'package:get/get.dart';

class PageBViewMixinArgs {
  static int get id => (Get.arguments?['id'] as int);

  static Callback get callback => (Get.arguments?['callback'] as Callback);

  static String? get tag => (Get.arguments?['tag'] as String?);

  static _i1.Key? get key => (Get.arguments?['key'] as _i1.Key?);
}

typedef Callback = _i2.Future<void> Function({
  required int id,
  String? name,
});
