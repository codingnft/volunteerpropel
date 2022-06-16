import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:volunteer/models/activity_model.dart';

class NetworkRepo {
  final firestore = FirebaseFirestore.instance;
  Future<void> addActivity(ActivityModel activity) async {
    try {
      await firestore
          .collection("activities")
          .doc(activity.activityId)
          .set(activity.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> editActivity(ActivityModel activity) async {
    try {
      await firestore
          .collection("activities")
          .doc(activity.activityId)
          .update(activity.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateActivity(ActivityModel activity) async {
    try {
      await firestore
          .collection("activities")
          .doc(activity.activityId)
          .update(activity.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteActivity(String activityId) async {
    try {
      await firestore.collection("activities").doc(activityId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteImages(String activityId) async {
    try {
      await FirebaseStorage.instance
          .ref(
              'uploads/${FirebaseAuth.instance.currentUser!.uid}/activities/${activityId}')
          .listAll()
          .then((value) => value.items.forEach((element) {
                FirebaseStorage.instance.ref(element.fullPath).delete();
              }));
    } catch (e) {
      rethrow;
    }
  }

  Future<List<ActivityModel>> getAllActivities() async {
    try {
      return (await firestore
              .collection("activities")
              .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .get())
          .docs
          .map((e) => ActivityModel.fromJson(e.data()))
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}
