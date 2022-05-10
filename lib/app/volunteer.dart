import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:volunteer/routes/bindings/intial_binding.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/screens/splash_screen.dart';

class Volunteer extends StatelessWidget {
  const Volunteer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scrollBehavior: MyCustomScrollBehavior(),
      // builder: (context, widget) => ResponsiveWrapper.builder(
      //   BouncingScrollWrapper.builder(context, widget!),
      //   maxWidth: Get.width,
      //   minWidth: 450,
      //   defaultScale: true,
      //   breakpoints: [
      //     const ResponsiveBreakpoint.resize(450, name: MOBILE),
      //     const ResponsiveBreakpoint.autoScale(800, name: TABLET),
      //     const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
      //     const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
      //     const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      //   ],

      // ),

      debugShowCheckedModeBanner: false,
      initialBinding: InitialBinding(),
      initialRoute: Routes.splashScreen,
      getPages: Routes.getPages,
      textDirection: TextDirection.ltr,
    );
  }
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        // etc.
      };
}
