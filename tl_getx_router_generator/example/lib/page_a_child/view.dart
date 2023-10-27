import 'package:flutter/material.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';
import 'package:get/get.dart';
import '../page_a/view.dart';
import 'binding.dart';
import 'logic.dart';

@GetXRoute(
    routeName: '/a_child',
    parentRoute: PageAView,
    bindings: [PageAChildBinding])
class PageAChildView extends GetView<PageAChildController> {
  const PageAChildView({this.tag, super.key});

  @override
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PageAChild'),
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
