import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:volunteer/screens/add_activity_screen.dart';
import 'package:volunteer/screens/edit_activity_screen.dart';
import 'package:volunteer/screens/home_screen.dart';
import 'package:volunteer/screens/auth_screen.dart';
import 'package:volunteer/screens/splash_screen.dart';

class Routes {
  static const String splashScreen = "/splashScreen";
  static const String authScreen = "/authScreen";
  static const String homeScreen = "/homeScreen";
  static const String addActivityScreen = "/addActivityScreen";
  static const String editActivityScreen = "/editActivityScreen";

  static List<GetPage> getPages = [
    GetPage(name: splashScreen, page: () => const SplashScreen()),
    GetPage(name: authScreen, page: () => AuthScreen()),
    GetPage(name: homeScreen, page: () => HomeScreen()),
    GetPage(name: addActivityScreen, page: () => const AddActivityScreen()),
    GetPage(name: editActivityScreen, page: () => EditActivityScreen()),
  ];
}
