
import 'package:flutter/material.dart';
import 'package:tl_getx_router_gen_annotations/tl_getx_router_gen_annotations.dart';
import 'package:tl_getx_router_gen_annotations/navigator.dart';
import 'package:get/get.dart';
import 'logic.dart';
import 'other_binding.dart';
import 'other_logic.dart';
import 'binding.dart';

@GetXRoute(
  routeName: '/page_b',
  bindings: [PageBBinding, OtherBinding],
)
class PageBView extends GetView<PageBController> {
  const PageBView(this.id,{required this.callback, this.tag, super.key});

  @override
  final String? tag;

  final Future<void> Function({String? name, required int id}) callback;

  final int id;

  @override
  Widget build(BuildContext context) {
    final otherLogic = Get.find<OtherController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('PageB'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Obx(() => Text(
                  'page_b_logic ${controller.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            Obx(() => Text(
                  'other_logic ${otherLogic.count}',
                  style: Theme.of(context).textTheme.headlineMedium,
                )),
            ElevatedButton(
                onPressed: () => otherLogic.increment(),
                child: Text('other logic Increment'))
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
