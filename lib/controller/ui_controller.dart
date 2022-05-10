import 'package:get/get.dart';

class UiController extends GetxController {
  bool isLoginCard = true;

  void animateAuthCard() {
    isLoginCard = !isLoginCard;
    update();
  }
}
