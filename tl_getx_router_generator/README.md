# GetX 自动路由注解生成器

## 1. 介绍

项目参考[get_x_navigation_generator](https://github.com/ikbendewilliam/get_x_navigation_generator)
,并根据自己的需求进行了修改,主要是为了解决以下问题:

1. 实现路由层级嵌套
2. 实现路由强传参,同时依旧兼容通过Get.toNamed跳转路由
3. 实现注入bindings
4. 删除returnType 

## 2.使用

本项目需要搭配注解包`tl_getx_router_gen_annotations`使用,请先安装注解包

### 2.1 添加依赖

```yaml
   ##再dependencies 添加
   dependencies:
     tl_getx_router_gen_annotations: ^1.0.0
     ##在dev_dependencies 添加
   dev_dependencies:
     tl_getx_router_generator: ^1.0.0
```

### 2.2 使用路由注解

```dart
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

### 2.3 路由配置注解

```dart
@TLGetXRouterConfig(
    moduleName: 'test' //区分各个模块基础路由名称(可不传)
)
class TestRoutesConfig //路由配置类名
    {
  final List<GetPage> pages = []; //路由配置列表
}
```

### 2.4 生成

```shell
:: 两种方式选其一

:: 运行一次
dart run build_runner build -d


:: 执行监听
dart run build_runner watch 

```

命令行在执行完成之后,xxx.router_arguments.dart文件,主要作用是拓展方法用于再getXController中获取路由强类型参数,文件内容如下:

```dart
// 生成的 view.router_arguments.dart 文件内容

extension TestPageViewMixinArgsExt on Object {
  String? get tag => (Get.arguments?['tag'] as String?);

  _i1.Key? get key => (Get.arguments?['key'] as _i1.Key?);
}

// 在controller中使用方法
class TestPageViewController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    print(TestPageViewMixinArgsExt(this).tag);
  }
}
```

在路由配置注解处生成一个xxx.get_x_router_config文件

```dart
    // 生成的 get_x_router.dart 文件内容
mixin TestRoutesConfigMixin {
  //路由配置列表
  static final pages = [
    GetPage<dynamic>(
        name: '/test/test_page_view',
        bindings: [_i1.TestPageBinding()],
        page: () =>
            _i2.TestPageView(
              tag: (Get.arguments?['tag'] as String?),
              key: (Get.arguments?['key'] as _i3.Key?),
            ),
        fullscreenDialog: false,
        preventDuplicates: true,
        showCupertinoParallax: true, 
    )
  ];
}

/// 路由名称,可用于Get.toNamed
class RouteNames {
  static const testPageView = '/test/test_page_view';
}

/// 用于 Get.toTyped() 传参
class TestPageViewTypedRoute extends _i7.TypedTlGetRouter {
  TestPageViewTypedRoute({
    String? name,
    String? age,
    String? tag,
    _i3.Key? key,
  }) {
    super.arguments.addAll({'name': name});
    super.arguments.addAll({'age': age});
    super.arguments.addAll({'tag': tag});
    super.arguments.addAll({'key': key});
  }

  @override
  final routeName = RouteNames.testPageView;
}


```

### 2.5 使用  

  将TestRoutesConfigMixin.pages添加到GetMaterialApp的getPages中,并且在需要使用路由的地方导入路由配置文件,使用方法如下:

  使用路由操作需要导入`package:tl_getx_router_gen_annotations/navigator.dart`文件,该文件中包含了路由操作的方法,使用方法如下:  

```dart
import 'package:tl_getx_router_gen_annotations/navigator.dart';

    Get.toTyped(
        TestPageViewTypedRoute(
            tag: 'test',
            key: ValueKey('test')
        )
    );
```