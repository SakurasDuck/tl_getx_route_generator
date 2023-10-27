
import 'tl_curves.dart';
import 'tl_translate.dart';

/// 自动生成路由注解
class GetXRoute {
  // 路由名称,为空使用类名(转小写)
  final String? routeName;

  // 父路由
  final Type? parentRoute;

  //GetPage 路由配置参数
  final bool? opaque;
  final TlTransition? transition;
  final TlCurves? curve;
  final String? id;
  final bool fullscreenDialog;
  final List<Type>? bindings;
  final bool preventDuplicates;
  final bool? popGesture;
  final bool showCupertinoParallax;

  const GetXRoute({
    this.routeName,
    this.parentRoute,
    this.opaque = true,
    this.transition,
    this.curve,
    this.id,
    this.fullscreenDialog = false,
    this.bindings,
    this.preventDuplicates = true,
    this.popGesture,
    this.showCupertinoParallax = true,
  });
}

const getXRoute = GetXRoute();

/// 路由config注解
class TLGetXRouterConfig {
  const TLGetXRouterConfig({this.moduleName});

  final String? moduleName;
}

const tlGetXRouterConfig = TLGetXRouterConfig();
