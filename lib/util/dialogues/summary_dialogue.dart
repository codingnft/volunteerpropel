import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer/controller/auth_controller.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/helper.dart';

void summaryDialogue(BuildContext context) {
  final homeController = Get.find<HomeController>();
  homeController.getAllActivities();
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) => AlertDialog(
        actions: [
          TextButton(
              onPressed: () {
                Get.back();
              },
              child: const Text("Close"))
        ],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GetBuilder<HomeController>(
                id: summaryBuilder,
                builder: (context) {
                  return homeController.isGettingAllActivities
                      ? Center(
                          child: CircularProgressIndicator(
                            color: mainColor,
                          ),
                        )
                      : homeController.isGettingAllActivities == false &&
                              homeController.allActivities.isEmpty
                          ? Text(
                              "No Summary Availible. Please add some activies to be able to see your summary",
                              style: summaryTitle,
                            )
                          : Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          "Total Activites",
                                          style: summaryTitle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          homeController.allActivities.length
                                              .toString(),
                                          style: summaryTitle,
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      width: 30,
                                    ),
                                    Column(
                                      children: [
                                        Text(
                                          "Total Hours",
                                          style: summaryTitle,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          getHoursSum(
                                                  homeController.allActivities)
                                              .toString(),
                                          style: summaryTitle,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 5),
                                  child: Divider(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Text(
                                    "Congratulations! You volunteered ${homeController.allActivities.length} times and accumulated ${getHoursSum(homeController.allActivities).toString()} volunteering hours since joining our platform since ${getFormattedDate(Get.find<AuthController>().currentUser!.dateJoined.toDate())}",
                                    style: summaryTitle,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              ],
                            );
                }),
          ],
        )),
  );
}

double getHoursSum(List<ActivityModel> activites) {
  double sum = 0;
  activites.forEach((element) {
    sum = sum + element.hours;
  });
  return sum;
}
