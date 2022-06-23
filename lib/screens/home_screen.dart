import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:volunteer/controller/auth_controller.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/screens/add_activity_screen.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/add_activity_dialogue.dart';
import 'package:volunteer/util/dialogues/summary_dialogue.dart';
import 'package:volunteer/util/helper.dart';
import 'package:volunteer/widgets/home_screen/activity_card.dart';
import 'package:volunteer/widgets/home_screen/activity_card2.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final authController = Get.find<AuthController>();
  final homeController = Get.find<HomeController>();
  String? uid;
  // Query<ActivityModel>? query;

  @override
  void initState() {
    authController.initQuery(context);
    FirebaseAuth.instance.authStateChanges().listen((event) {
      if (event == null) {
        Get.offAllNamed(Routes.authScreen);
      }
    });
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      // uid = await authController.intializeCurrentUserHomeScreen();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Future.delayed(Duration(seconds: 1), () {
    //   setState(() {
    //     // query = FirebaseFirestore.instance
    //     //     .collection("activities")
    //     //     .orderBy("dateCreated", descending: true)
    //     //     .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
    //     //     .withConverter<ActivityModel>(
    //     //         fromFirestore: (snapshot, _) =>
    //     //             ActivityModel.fromJson(snapshot.data()!),
    //     //         toFirestore: (activity, _) => activity.toJson());
    //   });
    // });

    return Scaffold(
      backgroundColor: Colors.white, //Colors.grey.withOpacity(0.2),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80.0),
        child: AppBar(
          backgroundColor: mainColor,
          leading: const Image(
            image: AssetImage("assets/vol.png"),
          ),
          title: const Text("My Activites"),
          centerTitle: true,
          leadingWidth: Get.width * 0.3,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 40),
              child: IconButton(
                tooltip: "Logout",
                onPressed: () {
                  authController.logout(context);
                },
                icon: const FaIcon(
                  Icons.logout,
                  size: 35,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      body: GetBuilder<HomeController>(builder: (ss) {
        return homeController.isLoading
            ? Center(
                child: CircularProgressIndicator(
                  color: mainColor,
                ),
              )
            : Center(
                child: SizedBox(
                  width: isMobile ? double.infinity : Get.width / 1.8,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GetBuilder<AuthController>(builder: (context2) {
                        return authController.query == null ||
                                FirebaseAuth.instance.currentUser == null
                            ? const SizedBox()
                            : Expanded(
                                child: FirestoreListView<ActivityModel>(
                                  shrinkWrap: true,
                                  pageSize: 5,
                                  loadingBuilder: (context) => Center(
                                    child: CircularProgressIndicator(
                                      color: mainColor,
                                    ),
                                  ),
                                  errorBuilder: (context, error, stk) =>
                                      const Center(
                                    child: Text(
                                      "OOPS! Something went wrong.",
                                      style: TextStyle(
                                          color: Colors.red, fontSize: 20),
                                    ),
                                  ),
                                  query: authController.query!,
                                  itemBuilder: (context, snapshot) {
                                    final activity = snapshot.data();
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 15),
                                      child: AcctivityCard2(activity: activity),
                                    );
                                  },
                                ),
                              );
                      }),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: mainColor)),
                                ),
                                onPressed: () {
                                  Get.toNamed(Routes.addActivityScreen,
                                      arguments:
                                          AddActivityArgs(isFromHome: true));
                                  // addActivityDialogue(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Add Activity",
                                    style: GoogleFonts.lato(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: mainColor)),
                                ),
                                onPressed: () {
                                  summaryDialogue(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Text(
                                    "Summary",
                                    style: GoogleFonts.lato(fontSize: 16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                ),
              );
      }),
    );
  }
}
