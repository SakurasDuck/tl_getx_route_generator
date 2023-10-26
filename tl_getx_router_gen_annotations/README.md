# TlGetx路由生成注解包

## 1. 介绍

本项目实现通过注解的方式生成路由配置,并且自动注入bindings,通过强类型获取路由参数


```dart
///使用注解功能需要导入
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';

//例
@GetXRoute(
    routeName: '/list', //路由名称(不传默认使用类名)
    parentRoute: TestPageView, //父级路由
    opaque: false, // GetPage 的 opaque 属性
    ... //GetPage 的其他属性
    bindings: // 注入bindings,,再没有指定binding的情况下,默认使用当前view的同文件夹下的binding.dart文件
    [
    TestListBinding(),]
)
class TestListView extends GetView<TestListController> {
  const TestListView({super.tag, super.key});
  
  return Scaffold(
  appBar: AppBar(
  title: Text('TestListView'),
  ),
  body: Center(
  child: Text('TestListView'),
  ),

  );
}
```

```dart

///使用强类型路由导入
import 'package:tl_getx_router_gen_annotations/navigator.dart';

//例
Get.toTyped(
    TestPageViewTypedRoute(
        tag: 'test',
        key: ValueKey('test')
    )
);
```

## 2. 使用

使用说明参考[tl_getx_router_generator](../tl_getx_router_generator/README.md)