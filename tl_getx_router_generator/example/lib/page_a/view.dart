import 'package:flutter/material.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';
import 'package:tl_getx_router_gen_annotations/navigator.dart';
import 'package:get/get.dart';
import '../route/route_config.get_x_router_config.dart';
import 'logic.dart';

@getXRoute
class PageAView extends GetView<PageAController> {
  const PageAView({this.tag, super.key});

  @override
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PageA'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(() => Text(
                  '${controller.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            ElevatedButton(
                onPressed: () {
                  Get.toTyped(AChildTypedRoute());
                },
                child: Text('goto child page'))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.increment(),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
