import 'package:get/get.dart';

import 'logic.dart';

class PageABinding extends Binding {
  @override
  List<Bind> dependencies() {
    return [
      Bind.lazyPut<PageAController>(() => PageAController()),
    ];
  }
}
