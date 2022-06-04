import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/screens/edit_activity_screen.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/action_dialogue.dart';
import 'package:volunteer/util/dialogues/show_image_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class AcctivityCard2 extends StatelessWidget {
  AcctivityCard2({required this.activity, Key? key}) : super(key: key);

  final ActivityModel activity;
  final homeController = Get.find<HomeController>();
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return Container(
        decoration: BoxDecoration(
          color: mainColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: constraints.maxWidth / 1.7,
                    child: RichText(
                      overflow: TextOverflow.ellipsis,
                      strutStyle: const StrutStyle(fontSize: 30.0),
                      text: TextSpan(
                          style: TextStyle(
                              color: mainColor,
                              fontSize: 30,
                              fontWeight: FontWeight.bold),
                          text: activity.organizationName),
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.editActivityScreen,
                            arguments: EditScreenArgs(activity: activity),
                          );
                        },
                        child: Image.asset(
                          "assets/edit.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      InkWell(
                        onTap: () {
                          showActionDialogue(
                            context,
                            title: "Delete Activity",
                            message:
                                "Are you sure you want to delete this activity?",
                            buttonText: "Delete",
                            buttonColor: Colors.red,
                            onpressed: () {
                              Get.back();
                              homeController.deleteActivity(context,
                                  activity: activity);
                            },
                          );
                        },
                        child: Image.asset(
                          "assets/trash.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Row(
                  children: [
                    Text(
                      "${getFormattedDate(activity.dateFrom)},",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${activity.hours.toString()} hour",
                      style: TextStyle(color: Colors.grey[500]),
                    ),
                  ],
                ),
              ),
              // Row(
              //   children: [
              //     SizedBox(
              //       width: isMobile
              //           ? constraints.maxWidth
              //           : constraints.maxWidth * 0.6,
              //       child: Text(
              //         activity.notes ?? "",
              //         style: TextStyle(color: Colors.grey[500]),
              //       ),
              //     ),
              //   ],
              // ),
              activity.notes != null
                  ? ReadMoreText(
                      activity.notes!,
                      trimLines: 3,
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(
                height: 20,
              ),
              activity.picsUrl != null
                  ? GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 3 : 4,
                          crossAxisSpacing: 10.0,
                          mainAxisSpacing: 10.0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showImageDailogue(context,
                                url: activity.picsUrl![index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    width: 5,
                                    color: mainColor.withOpacity(0.5))),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Center(
                                child: CachedNetworkImage(
                                  fadeInCurve: Curves.fastLinearToSlowEaseIn,
                                  placeholder: (context, url) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        color: mainColor.withOpacity(0.5),
                                      ),
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Center(child: Icon(Icons.error)),
                                  imageUrl: activity.picsUrl![index],
                                  width: 200,
                                  height: 200,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: activity.picsUrl!.length,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }
}
