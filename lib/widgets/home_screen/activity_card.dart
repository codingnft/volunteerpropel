import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:readmore/readmore.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/screens/edit_activity_screen.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/action_dialogue.dart';
import 'package:volunteer/util/dialogues/show_image_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class ActivityCard extends StatelessWidget {
  ActivityCard({
    Key? key,
    required this.activity,
  }) : super(key: key);

  final ActivityModel activity;
  final homeController = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: Border(
        bottom: BorderSide(width: 1, color: mainColor),
        right: BorderSide(width: 1, color: mainColor),
        top: BorderSide(
          width: 5,
          color: mainColor,
        ),
      ),
      elevation: 5,
      child: InkWell(
        onTap: null,
        child: SizedBox(
          // color: Colors.red,
          width: MediaQuery.of(context).size.width * 0.4,
          child: Stack(
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: isMobile
                              ? MediaQuery.of(context).size.width * 0.682
                              : MediaQuery.of(context).size.width * 0.4,
                          child: Text(
                            activity.organizationName,
                            style: GoogleFonts.lato(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Text("Hours: "),
                              Text(activity.hours.toString()),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5),
                          child: Row(
                            children: [
                              const Text("Date (From): "),
                              Text(getFormattedDate(activity.dateFrom)),
                            ],
                          ),
                        ),
                        activity.dateTo != null
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: Row(
                                  children: [
                                    const Text("Date (To): "),
                                    Text(getFormattedDate(activity.dateTo!)),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                        activity.notes == null
                            ? const SizedBox()
                            : Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5),
                                child: SizedBox(
                                  width: isMobile
                                      ? MediaQuery.of(context).size.width *
                                          0.682
                                      : MediaQuery.of(context).size.width * 0.4,
                                  child: ExpandablePanel(
                                    theme: const ExpandableThemeData(
                                      useInkWell: true,
                                      iconPadding: EdgeInsets.all(10),
                                    ),
                                    header: Card(
                                      color: mainColor,
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text(
                                          "Notes",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                              color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    expanded: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(activity.notes!),
                                    ),
                                    collapsed: const SizedBox(),
                                  ),
                                ),
                              ),
                        activity.picsUrl != null && activity.picsUrl!.isNotEmpty
                            ? Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Media ( ${activity.picsUrl!.length} )",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: isMobile
                                          ? MediaQuery.of(context).size.width *
                                              0.682
                                          : MediaQuery.of(context).size.width *
                                              0.4,
                                      height: Get.height * 0.25,
                                      color: Colors.black.withOpacity(0.1),
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: GridView.builder(
                                            itemCount: activity.picsUrl!.length,
                                            gridDelegate:
                                                SliverGridDelegateWithFixedCrossAxisCount(
                                                    crossAxisCount:
                                                        isMobile ? 3 : 4,
                                                    crossAxisSpacing: 10.0,
                                                    mainAxisSpacing: 10.0),
                                            itemBuilder: (context, index) {
                                              // return Image.network(
                                              //   activity.picsUrl![index],
                                              // );
                                              return GestureDetector(
                                                onTap: () {
                                                  showImageDailogue(context,
                                                      url: activity
                                                          .picsUrl![index]);
                                                },
                                                child: CachedNetworkImage(
                                                  fadeInCurve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  placeholder: (context, url) =>
                                                      Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        color: mainColor
                                                            .withOpacity(0.5),
                                                      ),
                                                    ),
                                                  ),
                                                  errorWidget:
                                                      (context, url, error) =>
                                                          const Center(
                                                              child: Icon(
                                                                  Icons.error)),
                                                  imageUrl:
                                                      "${activity.picsUrl![index]}",
                                                ),
                                              );
                                            }),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : const SizedBox(),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                right: 10,
                top: 10,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Get.toNamed(
                          Routes.editActivityScreen,
                          arguments: EditScreenArgs(activity: activity),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
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
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
