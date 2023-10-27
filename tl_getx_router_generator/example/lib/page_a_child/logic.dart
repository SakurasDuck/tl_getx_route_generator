import 'package:get/get.dart';

import 'view.router_arguments.dart';

class PageAChildController extends GetxController {
  final _count = 0.obs;

  int get count => _count.value;

  void increment() => _count.value++;

  @override
  void onReady() {
    super.onReady();
    print(
        'PageAChildController arguments.tag: ${PageAChildViewMixinArgsExt(this).tag}');
  }
}
