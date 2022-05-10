import 'package:get/get.dart';
import 'package:volunteer/controller/auth_controller.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/controller/ui_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(HomeController());
    Get.put(UiController());
  }
}
