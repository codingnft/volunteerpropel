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
import 'package:volunteer/util/helper.dart';
import 'package:volunteer/widgets/home_screen/activity_card.dart';

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
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        // query = FirebaseFirestore.instance
        //     .collection("activities")
        //     .orderBy("dateCreated", descending: true)
        //     .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        //     .withConverter<ActivityModel>(
        //         fromFirestore: (snapshot, _) =>
        //             ActivityModel.fromJson(snapshot.data()!),
        //         toFirestore: (activity, _) => activity.toJson());
      });
    });

    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: mainColor,
        leading: const Image(
          image: AssetImage("assets/vol.png"),
          width: 200,
          height: 500,
        ),
        title: const Text("Volunteer"),
        centerTitle: true,
        leadingWidth: 85,
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: IconButton(
                tooltip: "Logout",
                onPressed: () {
                  authController.logout(context);
                },
                icon: const FaIcon(
                  FontAwesomeIcons.arrowRightFromBracket,
                  color: Colors.redAccent,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Center(
        child: SizedBox(
          width: isMobile ? double.infinity : Get.width / 2,
          child: Card(
            elevation: 4,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "My Activities",
                          style: getAuthCardHeader,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: mainColor),
                        onPressed: () {
                          Get.toNamed(Routes.addActivityScreen);
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
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                GetBuilder<AuthController>(builder: (context2) {
                  return authController.query == null ||
                          FirebaseAuth.instance.currentUser == null
                      ? SizedBox()
                      : Expanded(
                          child: FirestoreListView<ActivityModel>(
                            shrinkWrap: true,
                            pageSize: 5,
                            loadingBuilder: (context) => Center(
                              child: CircularProgressIndicator(
                                color: mainColor,
                              ),
                            ),
                            errorBuilder: (context, error, stk) => const Center(
                              child: Text(
                                "OOPS! Something went wrong.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20),
                              ),
                            ),
                            query: authController.query!,
                            itemBuilder: (context, snapshot) {
                              final activity = snapshot.data();
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: ActivityCard(activity: activity),
                              );
                            },
                          ),
                        );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }
}
