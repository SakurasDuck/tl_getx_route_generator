import 'package:get/get.dart';

import 'logic.dart';

class PageBBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageBController>(() => PageBController());
  }
}
