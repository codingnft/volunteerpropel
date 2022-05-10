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

class RegisterCard extends StatelessWidget {
  RegisterCard({Key? key}) : super(key: key);

  final uiController = Get.find<UiController>();
  final authController = Get.find<AuthController>();

  final formKey = GlobalKey<FormState>();
  final nameCon = TextEditingController();
  final emailCon = TextEditingController();
  final passCon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: Get.width < 700 ? Get.width : Get.width / 2.3,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Card(
            elevation: 10,
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text(
                        "Register",
                        style: getAuthCardHeader,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: TextFormField(
                        controller: nameCon,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Name is required";
                          }
                          return null;
                        },
                        cursorColor: mainColor,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.person,
                            color: mainColor,
                          ),
                          label: const Text("Name"),
                          contentPadding: const EdgeInsets.all(20),
                          floatingLabelStyle: TextStyle(color: mainColor),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
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
                          suffixIcon: Icon(
                            Icons.email,
                            color: mainColor,
                          ),
                          label: const Text("Email"),
                          contentPadding: const EdgeInsets.all(20),
                          floatingLabelStyle: TextStyle(color: mainColor),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 30, vertical: 20),
                      child: TextFormField(
                        controller: passCon,
                        validator: (value) {
                          if (value!.length < 6) {
                            return "Password should be atleast 6 characters";
                          }
                          return null;
                        },
                        cursorColor: mainColor,
                        obscureText: true,
                        decoration: InputDecoration(
                          suffixIcon: Icon(
                            Icons.password,
                            color: mainColor,
                          ),
                          label: const Text("Password"),
                          contentPadding: const EdgeInsets.all(20),
                          floatingLabelStyle: TextStyle(color: mainColor),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: mainColor),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 20, horizontal: 20),
                      child: LayoutBuilder(builder: (context, constraints) {
                        return SizedBox(
                          width: constraints.maxWidth * 0.8,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(primary: mainColor),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                authController.registerUser(context,
                                    name: nameCon.text,
                                    email: emailCon.text,
                                    password: passCon.text);
                              }
                            },
                            child: const Text("Register"),
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
                          "Already have an account? Login!",
                          style: GoogleFonts.lato(
                              fontSize: 15, color: Colors.blue),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      child: HorizontalOrLine(label: "OR", height: 0.5),
                    ),
                    SocialButton(
                        onPressed: () {
                          authController.loginWithGoogle(context);
                        },
                        background: Colors.redAccent,
                        icon: const FaIcon(
                          FontAwesomeIcons.google,
                          color: Colors.red,
                        ),
                        text: "Signup with Google"),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
