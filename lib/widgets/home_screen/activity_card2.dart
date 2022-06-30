import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/models/organization_model.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/screens/edit_activity_screen.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/action_dialogue.dart';
import 'package:volunteer/util/dialogues/show_image_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class AcctivityCard2 extends StatefulWidget {
  AcctivityCard2({required this.activity, Key? key}) : super(key: key);

  final ActivityModel activity;

  @override
  State<AcctivityCard2> createState() => _AcctivityCard2State();
}

class _AcctivityCard2State extends State<AcctivityCard2> {
  final isFound = ValueNotifier<OrganizationModel?>(null);
  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      log(homeController.organizationsList.toString());
      if (widget.activity.organizationId != null) {
        isFound.value = homeController.organizationsList.firstWhereOrNull(
            (element) =>
                element.organizationId == widget.activity.organizationId);
      }
    });
    super.initState();
  }

  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    // log(activity.organizationName.isEmpty.toString());
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
              ValueListenableBuilder(
                  valueListenable: isFound,
                  builder: (context, __, _) {
                    return isFound.value != null
                        ? SizedBox(
                            width: constraints.maxWidth / 1.7,
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: const StrutStyle(fontSize: 20.0),
                              text: TextSpan(
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  text: isFound.value!.name),
                            ),
                          )
                        : SizedBox(
                            width: constraints.maxWidth / 1.7,
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: const StrutStyle(fontSize: 20.0),
                              text: TextSpan(
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  text: widget.activity.organizationId),
                            ),
                          );
                  }),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.activity.organizationName.isNotEmpty
                      ? Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: SizedBox(
                            width: constraints.maxWidth / 1.7,
                            child: RichText(
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              strutStyle: const StrutStyle(fontSize: 20.0),
                              text: TextSpan(
                                  style: TextStyle(
                                      color: mainColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  text: "${widget.activity.organizationName}"),
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                  Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Get.toNamed(
                            Routes.editActivityScreen,
                            arguments:
                                EditScreenArgs(activity: widget.activity),
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
                                  activity: widget.activity);
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
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    Text(
                      "${getFormattedDate(widget.activity.dateFrom)},",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Text(
                      "${widget.activity.hours.toString()} hour",
                      style: const TextStyle(color: Colors.black, fontSize: 16),
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
              widget.activity.notes != null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: ReadMoreText(
                        widget.activity.notes!,
                        trimLines: 2,
                        style:
                            const TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    )
                  : const SizedBox.shrink(),

              const SizedBox(
                height: 30,
              ),
              widget.activity.picsUrl != null
                  ? GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: isMobile ? 3 : 4,
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            showImageDailogue(context,
                                url: widget.activity.picsUrl![index]);
                          },
                          child: Container(
                            // decoration: BoxDecoration(
                            //     borderRadius: BorderRadius.circular(20),
                            //     border: Border.all(
                            //         width: 5,
                            //         color: mainColor.withOpacity(0.5))),
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(
                                        widget.activity.picsUrl![index]),
                                    fit: BoxFit.cover)),
                            width: 200,
                            height: 200,
                            // child: ClipRRect(
                            //   borderRadius: BorderRadius.circular(20),
                            //   child: Center(
                            //     child: CachedNetworkImage(
                            //       fadeInCurve: Curves.fastLinearToSlowEaseIn,
                            //       placeholder: (context, url) => Padding(
                            //         padding: const EdgeInsets.all(8.0),
                            //         child: Center(
                            //           child: CircularProgressIndicator(
                            //             color: mainColor.withOpacity(0.5),
                            //           ),
                            //         ),
                            //       ),
                            //       errorWidget: (context, url, error) =>
                            //           const Center(child: Icon(Icons.error)),
                            //       imageUrl: activity.picsUrl![index],
                            //       width: 200,
                            //       height: 200,
                            //     ),
                            //   ),
                            // ),
                          ),
                        );
                      },
                      shrinkWrap: true,
                      itemCount: widget.activity.picsUrl!.length,
                    )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      );
    });
  }
}
