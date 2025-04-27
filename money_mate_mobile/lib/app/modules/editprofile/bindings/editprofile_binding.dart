import 'package:get/get.dart';

import '../controllers/editprofile_controller.dart';

class EditprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditprofileController>(() => EditprofileController());
  }
}
