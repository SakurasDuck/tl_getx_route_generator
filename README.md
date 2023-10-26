# tl_getx_route_generator

tl_getx路由注解生成器

项目参考[get_x_navigation_generator](https://github.com/ikbendewilliam/get_x_navigation_generator)
,并根据自己的需求进行了修改,主要是为了解决以下问题:

1. 实现路由层级嵌套
2. 实现路由强传参,同时依旧兼容通过Get.toNamed跳转路由
3. 实现注入bindings
4. 删除returnType 

## 目录
`tl_getx_router_gen_annotations` 注解包
说明参考[tl_getx_router_gen_annotations](tl_getx_router_gen_annotations/README.md)

`tl_getx_router_generator` 生成器
说明参考[tl_getx_router_generator](tl_getx_router_generator/README.md)


