import 'package:get/get.dart';

import '../controllers/addcontent_controller.dart';

class AddcontentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddcontentController>(
      () => AddcontentController(),
    );
  }
}