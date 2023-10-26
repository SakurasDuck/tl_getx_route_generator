import 'package:get/get.dart';

import 'typed_router_interface.dart';

extension TypedNavigator on GetInterface {
  /// 退路由
  Future<T?> toTyped<T>(
    TypedTlGetRouter typedRouter, {
    String? id,
    bool preventDuplicates = true,
  }) async {
    return searchDelegate(id).toNamed(
      typedRouter.routeName,
      id: id,
      arguments: typedRouter.arguments,
      preventDuplicates: preventDuplicates,
    );
  }

  /// 替换路由
  Future<T?>? replaceTyped<T>(
    TypedTlGetRouter typedRouter, {
    String? id,
  }) {
    return searchDelegate(id).offNamed(
      typedRouter.routeName,
      arguments: typedRouter.arguments,
      id: id,
    );
  }

  /// 退路由直到条件成立然后推新路由
  Future<T?>? offUntilToTyped<T>(
    TypedTlGetRouter typedRouter,
    bool Function(GetPage<dynamic>)? predicate, {
    String? id,
  }) {
    return searchDelegate(id).offNamedUntil<T>(
      typedRouter.routeName,
      predicate: predicate,
      id: id,
      arguments: typedRouter.arguments,
    );
  }

  ///退掉所有路由，推新路由
  Future<T?>? offAllNamed<T>(
    TypedTlGetRouter typedRouter, {
    String? id,
  }) {
    return searchDelegate(id).offAllNamed<T>(
      typedRouter.routeName,
      arguments: typedRouter.arguments,
      id: id,
    );
  }
}

