import 'package:get/get.dart';

import '../controllers/detailcontent_controller.dart';

class DetailcontentBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailcontentController>(
      () => DetailcontentController(),
    );
  }
}
