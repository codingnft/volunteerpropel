import 'dart:developer';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:volunteer/controller/auth_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/models/organization_model.dart';
import 'package:volunteer/network/network_repo.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/error_dialogue.dart';
import 'package:volunteer/util/dialogues/loading_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class HomeController extends GetxController {
  List<OrganizationModel> organizationsList = List.empty(growable: true);
  bool isLoading = false;
  @override
  Future<void> onInit() async {
    getOrgs();
    super.onInit();
  }

  Future<void> getOrgs() async {
    // final orgId = const Uuid().v1();
    // final org = OrganizationModel(
    //     organizationId: orgId,
    //     name: "C org",
    //     description: "iadwn i",
    //     logoUrl: "Awd",
    //     phone: "+214124124",
    //     contactName: "wdadawidn",
    //     contactEmail: "awndnawidn iaownd",
    //     contactPhone: "+234324",
    //     address: "wanoidw",
    //     websiteUrl: "wnaodnwa",
    //     isActive: true,
    //     dateCreated: Timestamp.now());

    // await FirebaseFirestore.instance
    //     .collection("organizations")
    //     .doc(orgId)
    //     .set(org.toJson());

    try {
      isLoading = true;
      final docs = (await FirebaseFirestore.instance
              .collection("organizations")
              .where("isActive", isEqualTo: true)
              .orderBy("name", descending: false)
              .get())
          .docs;

      docs.forEach((element) {
        organizationsList.add(OrganizationModel.fromJson(element.data()));
      });
      isLoading = false;
      update();
    } catch (e) {
      isLoading = false;
      update();
      // log(e.toString());
      print(e);
    }
  }

  final network = NetworkRepo();

  final storage = FirebaseStorage.instance;

  Future<String> uploadFile(PlatformFile _image, {required String path}) async {
    Uint8List fileBytes = _image.bytes!;
    String fileName = _image.name;
    TaskSnapshot taskSnap =
        await storage.ref("$path/$fileName").putData(fileBytes);
    return await taskSnap.ref.getDownloadURL();
  }

  Future<void> addActivity(BuildContext context,
      {required String organizationId,
      required String orgName,
      required String? notes,
      required double hours,
      required FilePickerResult? pickedFiles}) async {
    try {
      if (dateFrom == null) {
        showErrorDialogue(context, msg: "Date (From) is required");
        return;
      } else {
        showCustomLoadingDialogue(context, "Adding Activity");
        final activity = ActivityModel(
          dateCreated: Timestamp.now(),
          uid: FirebaseAuth.instance.currentUser!.uid,
          organizationId: organizationId,
          activityId: const Uuid().v1(),
          organizationName: orgName,
          hours: hours,
          dateFrom: dateFrom!,
          dateTo: dateTo ?? DateTime.now(),
          notes: notes,
        );
        await network.addActivity(activity);

        if (pickedFiles != null && pickedFiles.count.isGreaterThan(0)) {
          Get.back();
          showCustomLoadingDialogue(context, "Uploading Images...");
          List<String> urls = List.empty(growable: true);
          for (int i = 0; i < pickedFiles.files.length; i++) {
            final url = await uploadFile(pickedFiles.files[i],
                path:
                    'uploads/${FirebaseAuth.instance.currentUser!.uid}/activities/${activity.activityId}');
            urls.add(url);
          }
          activity.picsUrl = urls;
          await network.updateActivity(activity);
        }

        Get.offAllNamed(Routes.homeScreen);
      }
    } catch (e) {
      log(e.toString());
      Get.back();
      showErrorDialogue(context, msg: "There was an issue adding activity.");
    }
  }

  Future<void> deleteIndividualImage(BuildContext context,
      {required String imageUrl}) async {
    try {
      showCustomLoadingDialogue(context, "Deleting Image");
      final ref = storage.refFromURL(imageUrl);
      await storage.ref(ref.fullPath).delete();
      Get.back();
    } catch (e) {
      Get.back();
      showErrorDialogue(context, msg: "There was issue deleting image");
    }
  }

  Future<void> updateActivity(BuildContext context,
      {required ActivityModel activity}) async {
    try {
      showCustomLoadingDialogue(context, "Updating Activity");
      await network.updateActivity(activity);
      Get.back();
    } catch (e) {
      throw e;
    }
  }

  Future<void> editActivity(BuildContext context,
      {required ActivityModel activity,
      required FilePickerResult? pickedFiles}) async {
    try {
      if (dateFrom == null) {
        showErrorDialogue(context, msg: "Date (From) is required");
        return;
      } else {
        showCustomLoadingDialogue(context, "Updating Activity");

        await network.updateActivity(activity);

        if (pickedFiles != null && pickedFiles.count.isGreaterThan(0)) {
          Get.back();
          showCustomLoadingDialogue(context, "Uploading Images...");
          List<String> urls = List.empty(growable: true);
          for (int i = 0; i < pickedFiles.files.length; i++) {
            final url = await uploadFile(pickedFiles.files[i],
                path:
                    'uploads/${FirebaseAuth.instance.currentUser!.uid}/activities/${activity.activityId}');
            urls.add(url);
          }
          if (activity.picsUrl != null) {
            urls.forEach((element) {
              activity.picsUrl!.add(element);
            });
          } else {
            activity.picsUrl = urls;
          }
          await network.updateActivity(activity);
        }

        Get.offAllNamed(Routes.homeScreen);
      }
    } catch (e) {
      log(e.toString());
      Get.back();
      showErrorDialogue(context, msg: "There was an issue adding activity.");
    }
  }

  Future<void> deleteActivity(BuildContext context,
      {required ActivityModel activity}) async {
    try {
      if (activity.picsUrl != null && activity.picsUrl!.isNotEmpty) {
        network.deleteImages(activity.activityId);
      }
      await network.deleteActivity(activity.activityId);
    } catch (e) {
      showErrorDialogue(context, msg: "There was an issue deleting activity");
    }
  }

  // double hours = hoursList.first;
  DateTime? dateFrom;
  DateTime? dateTo;
  TextEditingController dateFromCon = TextEditingController();
  TextEditingController dateToCon = TextEditingController();

  void changeDateFrom(DateTime date) {
    dateFromCon.text = getFormattedDate(date);
    dateFrom = date;
    update();
  }

  void changeDateTo(DateTime date) {
    dateToCon.text = getFormattedDate(date);
    dateTo = date;
    update();
  }

  // void changeHours(double value) {
  //   hours = value;
  //   update();
  // }

  // For Summary
  List<ActivityModel> allActivities = List.empty(growable: true);
  bool isGettingAllActivities = false;

  Future<void> getAllActivities() async {
    try {
      isGettingAllActivities = true;
      allActivities = await network.getAllActivities();
      await Get.find<AuthController>().initCurrentUser();
      isGettingAllActivities = false;
      update([summaryBuilder]);
    } catch (e) {
      rethrow;
    }
  }
}
