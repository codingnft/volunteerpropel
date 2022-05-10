import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:volunteer/models/user_model.dart';

class AuthRepo {
  final firestore = FirebaseFirestore.instance;
  final firebaseAuth = FirebaseAuth.instance;

  Future<UserModel> register(
      {required UserModel user, required String password}) async {
    try {
      UserCredential creds = await firebaseAuth.createUserWithEmailAndPassword(
          email: user.email, password: password);

      user.uid = creds.user!.uid;
      await firestore.collection("users").doc(user.uid).set(user.toJson());
      return user;
    } catch (e) {
      rethrow;
    }
  }

  Future<UserModel> getCurrentUser() async {
    try {
      return UserModel.fromJson((await firestore
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get())
          .data()!);
    } catch (e) {
      throw e;
    }
  }

  Future<UserModel> login(
      {required String email, required String password}) async {
    try {
      UserCredential creds = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return UserModel.fromJson(
          (await firestore.collection("users").doc(creds.user!.uid).get())
              .data()!);
    } catch (e) {
      rethrow;
    }
  }

  Future<void> createUserSocial(UserModel user) async {
    try {
      await firestore.collection('users').doc(user.uid).set(user.toJson());
    } catch (e) {
      throw e;
    }
  }
}
