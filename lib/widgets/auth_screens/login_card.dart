import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volunteer/controller/auth_controller.dart';
import 'package:volunteer/controller/ui_controller.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/helper.dart';
import 'package:volunteer/widgets/orline.dart';
import 'package:volunteer/widgets/social_button.dart';

class LoginCard extends StatelessWidget {
  LoginCard({
    Key? key,
  }) : super(key: key);

  final uiController = Get.find<UiController>();
  final authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final nameCon = TextEditingController();
  final emailCon = TextEditingController();
  final passCon = TextEditingController();

  ValueNotifier<bool> isPassShowing = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width < 700 ? Get.width * 0.8 : Get.width / 2.5,
      child: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.w500),
                    children: [
                      const TextSpan(text: "Welcome to "),
                      TextSpan(
                          text: "Volunteer",
                          style: TextStyle(
                              color: mainColor, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.symmetric(vertical: 20),
              //   child: Text(
              //     "Login",
              //     style: getAuthCardHeader,
              //   ),
              // ),

              GestureDetector(
                onTap: () {
                  authController.loginWithGoogle(context);
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  child: LayoutBuilder(builder: (context, constraints) {
                    return SizedBox(
                      width: isMobile
                          ? constraints.maxWidth * 0.8
                          : constraints.maxWidth * 0.6,
                      height: 70,
                      child: Card(
                        elevation: 0,
                        color: mainColor.withOpacity(0.35),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Image(
                                image: AssetImage(
                                  "assets/google.png",
                                ),
                                width: 30,
                                height: 50,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Login with Google",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Text(
                "or continue with",
                style: TextStyle(color: Colors.grey[600], fontSize: 16),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: TextFormField(
                  controller: emailCon,
                  validator: (value) {
                    if (!emailValid.hasMatch(value!)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                  cursorColor: mainColor,
                  decoration: InputDecoration(
                    // suffixIcon: Icon(
                    //   Icons.email,
                    //   color: mainColor,
                    // ),
                    label: const Text("Email"),
                    hintText: "Enter your Email Address",
                    contentPadding: const EdgeInsets.all(26),
                    floatingLabelStyle: TextStyle(color: mainColor),
                    border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                      borderSide: BorderSide(color: mainColor),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: ValueListenableBuilder(
                    valueListenable: isPassShowing,
                    builder: (context, val, _) {
                      return TextFormField(
                        controller: passCon,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password should be atleast 6 characters";
                          }
                          return null;
                        },
                        cursorColor: mainColor,
                        obscureText: !isPassShowing.value ? true : false,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            onPressed: () {
                              isPassShowing.value = !isPassShowing.value;
                            },
                            icon: Icon(
                              !isPassShowing.value
                                  ? Icons.remove_red_eye
                                  : Icons.remove_red_eye_outlined,
                            ),
                            color: mainColor,
                          ),
                          label: const Text("Password"),
                          hintText: "Enter your Password",
                          contentPadding: const EdgeInsets.all(26),
                          floatingLabelStyle: TextStyle(color: mainColor),
                          border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50))),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50)),
                            borderSide: BorderSide(color: mainColor),
                          ),
                        ),
                      );
                    }),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: LayoutBuilder(builder: (context, constraints) {
                  return SizedBox(
                    width: isMobile
                        ? constraints.maxWidth * 0.8
                        : constraints.maxWidth * 0.6,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: mainColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50))),
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          authController.login(context,
                              email: emailCon.text, password: passCon.text);
                        }
                      },
                      child: const Text("Login"),
                    ),
                  );
                }),
              ),
              InkWell(
                onTap: () {
                  uiController.animateAuthCard();
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                    "Dont have an account? Register Now!",
                    style: GoogleFonts.lato(fontSize: 15, color: mainColor),
                  ),
                ),
              ),
              // const Padding(
              //   padding: EdgeInsets.symmetric(vertical: 20),
              //   child: HorizontalOrLine(label: "OR", height: 0.5),
              // ),
              // SocialButton(
              //     onPressed: () {
              //       authController.loginWithGoogle(context);
              //     },
              //     background: Colors.redAccent,
              //     icon: const FaIcon(
              //       FontAwesomeIcons.google,
              //       color: Colors.red,
              //     ),
              //     text: "Login with Google"),
              // const SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
