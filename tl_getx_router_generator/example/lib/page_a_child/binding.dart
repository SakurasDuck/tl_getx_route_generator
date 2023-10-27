import 'package:get/get.dart';

import 'logic.dart';

class PageAChildBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PageAChildController>(() => PageAChildController());
  }
}
