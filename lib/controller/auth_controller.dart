import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/models/user_model.dart';
import 'package:volunteer/network/auth_repo.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/util/dialogues/action_dialogue.dart';
import 'package:volunteer/util/dialogues/error_dialogue.dart';
import 'package:volunteer/util/dialogues/loading_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class AuthController extends GetxController {
  final firebaseAuth = FirebaseAuth.instance;
  final authRepo = AuthRepo();

  GoogleSignIn googleSignIn = GoogleSignIn();
  UserModel? currentUser;

  Future<void> checkCurrentUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 2), () async {
      if (firebaseAuth.currentUser != null) {
        currentUser = await authRepo.getCurrentUser();
        // print("Not null");

        Get.offNamed(Routes.homeScreen);
      } else {
        // print("Null");
        Get.offNamed(Routes.authScreen);
      }
    });
  }

  Future<void> initCurrentUser() async {
    if (firebaseAuth.currentUser != null) {
      log(firebaseAuth.currentUser!.uid);
      currentUser = await authRepo.getCurrentUser();
      // print("Not null");

    } else {
      print("Null");
    }
  }

  Future<String?> intializeCurrentUserHomeScreen() async {
    Future.delayed(const Duration(seconds: 2), () async {
      if (firebaseAuth.currentUser != null) {
        currentUser = await authRepo.getCurrentUser();
        return firebaseAuth.currentUser!.uid;
      } else {
        return null;
      }
    });
  }

  Future<void> registerUser(BuildContext context,
      {required String name,
      required String password,
      required String email}) async {
    try {
      showLoadingDialogue(context);
      UserModel user = UserModel(
          uid: "", name: name, email: email, dateJoined: Timestamp.now());
      currentUser = await authRepo.register(user: user, password: password);
      Get.offAllNamed(Routes.homeScreen);
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'weak-password') {
        alertMessage(context, 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        alertMessage(context, 'The account already exists for that email.');
      }
    } catch (e) {
      Get.back();
      alertMessage(context, "There was an internal issue. try again.");
    }
  }

  Future<void> login(BuildContext context,
      {required String email, required String password}) async {
    try {
      showLoadingDialogue(context);
      currentUser = await authRepo.login(email: email, password: password);
      Get.offAllNamed(Routes.homeScreen);
    } on FirebaseAuthException catch (e) {
      Get.back();
      if (e.code == 'user-not-found') {
        alertMessage(context, 'No user found for that email. Please register');
      } else if (e.code == 'wrong-password') {
        alertMessage(context, 'Wrong password provided for that user.');
      }
    } catch (e) {
      Get.back();
      alertMessage(context, "There was an internal issue. try again.");
    }
  }

  Future<void> loginWithGoogle(BuildContext context) async {
    try {
      // Trigger the authentication flow

      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser != null) {
        showLoadingDialogue(context);
        // Obtain the auth details from the request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create a new credential
        final credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        String uid = await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) => value.user!.uid);

        log(uid);

        try {
          currentUser = await authRepo.getCurrentUser();
        } catch (e) {
          UserModel user = UserModel(
              uid: uid,
              name: googleUser.displayName!,
              email: googleUser.email,
              dateJoined: Timestamp.now());
          await authRepo.createUserSocial(user);
          currentUser = user;
        }

        Get.offNamed(Routes.homeScreen);
      } else {
        alertMessage(context, "No account selected");
      }
    } on FirebaseAuthException catch (e) {
      // Navigator.pop(context);
      log(e.toString());
      alertMessage(context, "There was an issue authenticating google");
    }
  }

  Future<void> logout(BuildContext context) async {
    showActionDialogue(
      context,
      title: "Logout",
      message: "Are your sure you want to logout ?",
      buttonText: "Logout",
      buttonColor: Colors.red,
      onpressed: () async {
        showCustomLoadingDialogue(context, "Logging out");
        try {
          await FirebaseAuth.instance.signOut();
          await googleSignIn.signOut();
          currentUser = null;
          Get.offAllNamed(Routes.authScreen);
        } catch (e) {
          Get.back();
          showErrorDialogue(context, msg: "Couldnt log out");
          log(e.toString());
        }
      },
    );
  }

  Query<ActivityModel>? query;

  Future<void> initQuery(BuildContext context) async {
    firebaseAuth.idTokenChanges().listen((event) async {
      if (event != null) {
        query = FirebaseFirestore.instance
            .collection("activities")
            .orderBy("dateCreated", descending: true)
            .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
            .withConverter<ActivityModel>(
                fromFirestore: (snapshot, _) =>
                    ActivityModel.fromJson(snapshot.data()!),
                toFirestore: (activity, _) => activity.toJson());
      }

      update();
    });
  }
}
