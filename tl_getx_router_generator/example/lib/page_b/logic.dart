import 'package:get/get.dart';

class PageBController extends GetxController {
  final _count = 0.obs;

  int get count => _count.value;

  void increment() => _count.value++;
}
