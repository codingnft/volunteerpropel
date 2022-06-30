import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer/controller/ui_controller.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/helper.dart';
import 'package:volunteer/widgets/auth_screens/login_card.dart';
import 'package:volunteer/widgets/auth_screens/register_card.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = Get.find<UiController>();
  @override
  void initState() {
    FirebaseAuth.instance.idTokenChanges().listen((event) {}).onData((data) {
      if (data != null) {
        Get.offAllNamed(Routes.homeScreen);
      }
    });
    // FirebaseAuth.instance.authStateChanges().listen((event) {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: ((context, constraints) {
      return !isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Container(
                      width: constraints.maxWidth / 2,
                      height: constraints.maxHeight,
                      decoration: BoxDecoration(
                        color: mainColor,
                        image: const DecorationImage(
                          image: AssetImage("assets/vol.png"),
                        ),
                      ),
                    ),
                    GetBuilder<UiController>(
                      builder: (context) {
                        return AnimatedSwitcher(
                          duration: const Duration(milliseconds: 500),
                          switchInCurve: Curves.easeInBack,
                          child: controller.isLoginCard
                              ? LoginCard()
                              : RegisterCard(),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    width: Get.width,
                    height: 150,
                    decoration: BoxDecoration(
                      color: mainColor,
                      image: const DecorationImage(
                        image: AssetImage("assets/vol.png"),
                      ),
                    ),
                  ),
                  GetBuilder<UiController>(
                    builder: (context) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        switchInCurve: Curves.easeInBack,
                        child: controller.isLoginCard
                            ? LoginCard()
                            : RegisterCard(),
                      );
                    },
                  ),
                ],
              ),
            );
    })));
  }
}
