import 'dart:html';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/models/activity_model.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/show_image_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class EditActivityScreen extends StatefulWidget {
  const EditActivityScreen({Key? key}) : super(key: key);

  @override
  State<EditActivityScreen> createState() => _EditActivityScreenState();
}

class _EditActivityScreenState extends State<EditActivityScreen> {
  FilePickerResult pickedFiles = FilePickerResult([]);
  final formKey = GlobalKey<FormState>();
  final orgNameCon = TextEditingController();
  final notesCon = TextEditingController();
  final homeController = Get.find<HomeController>();
  List<String> urlsList = List.empty(growable: true);
  int imageCount = 0;
  EditScreenArgs? args;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      if (ModalRoute.of(context)!.settings.arguments != null) {
        print("Not null");
        args = ModalRoute.of(context)!.settings.arguments as EditScreenArgs;
        setState(() {
          orgNameCon.text = args!.activity.organizationName;
          if (args!.activity.notes != null) {
            notesCon.text = args!.activity.notes!;
          }
          imageCount = args!.activity.picsUrl != null &&
                  args!.activity.picsUrl!.isNotEmpty
              ? args!.activity.picsUrl!.length
              : 0;
          if (args!.activity.picsUrl != null) {
            args!.activity.picsUrl!.map((e) => urlsList.add(e));
          }
        });

        homeController.changeDateFrom(args!.activity.dateFrom);

        if (args!.activity.dateTo != null) {
          homeController.changeDateTo(args!.activity.dateTo!);
        }
      } else {
        print("Null");
        Get.offAllNamed(Routes.homeScreen);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.homeScreen);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Edit Activity"),
      ),
      body: ModalRoute.of(context)!.settings.arguments == null
          ? const SizedBox()
          : SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: SizedBox(
                      width: isMobile ? Get.width : Get.width / 2,
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: isMobile ? Get.width : Get.width / 2,
                            ),
                            SizedBox(
                              height: Get.height * 0.1,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: TextFormField(
                                maxLength: 50,
                                controller: orgNameCon,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "Orgaination Name is required";
                                  }
                                  return null;
                                },
                                cursorColor: mainColor,
                                decoration: InputDecoration(
                                  label: const Text("Orgaination Name *"),
                                  contentPadding: const EdgeInsets.all(20),
                                  floatingLabelStyle:
                                      TextStyle(color: mainColor),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                  ),
                                ),
                              ),
                            ),
                            GetBuilder<HomeController>(
                              builder: (context) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 40),
                                  child: Column(
                                    // crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 5),
                                        child: Text(
                                          "Hours",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ),
                                      Card(
                                        elevation: 3,
                                        child: DropdownButton<double>(
                                            isExpanded: true,
                                            underline: const SizedBox(),
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            value: homeController.hours,
                                            items: hoursList
                                                .map((e) => DropdownMenuItem(
                                                    value: e,
                                                    child: Text(
                                                      "${e.toString()} hrs",
                                                      style: const TextStyle(
                                                          fontSize: 18),
                                                    )))
                                                .toList(),
                                            onChanged: (value) {
                                              homeController
                                                  .changeHours(value!);
                                            }),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: GetBuilder<HomeController>(builder: (con) {
                                return TextFormField(
                                  controller: homeController.dateFromCon,
                                  cursorColor: mainColor,
                                  readOnly: true,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 50),
                                      firstDate:
                                          DateTime(DateTime.now().year - 50),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Colors.white,
                                              onPrimary: mainColor,
                                              surface: mainColor,
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor:
                                                Colors.grey.withOpacity(0.7),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ).then((value) {
                                      homeController.changeDateFrom(value!);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    label: const Text("Date (From) *"),
                                    contentPadding: const EdgeInsets.all(20),
                                    floatingLabelStyle:
                                        TextStyle(color: mainColor),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: mainColor),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: GetBuilder<HomeController>(builder: (con) {
                                return TextFormField(
                                  controller: homeController.dateToCon,
                                  cursorColor: mainColor,
                                  readOnly: true,
                                  onTap: () {
                                    showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      lastDate:
                                          DateTime(DateTime.now().year + 50),
                                      firstDate:
                                          DateTime(DateTime.now().year - 50),
                                      builder: (context, child) {
                                        return Theme(
                                          data: ThemeData.dark().copyWith(
                                            colorScheme: ColorScheme.dark(
                                              primary: Colors.white,
                                              onPrimary: mainColor,
                                              surface: mainColor,
                                              onSurface: Colors.white,
                                            ),
                                            dialogBackgroundColor:
                                                Colors.grey.withOpacity(0.7),
                                          ),
                                          child: child!,
                                        );
                                      },
                                    ).then((value) {
                                      homeController.changeDateTo(value!);
                                    });
                                  },
                                  decoration: InputDecoration(
                                    label: const Text("Date (To)"),
                                    contentPadding: const EdgeInsets.all(20),
                                    floatingLabelStyle:
                                        TextStyle(color: mainColor),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(color: mainColor),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 20),
                              child: TextFormField(
                                controller: notesCon,
                                maxLength: 500,
                                maxLines: 8,
                                cursorColor: mainColor,
                                decoration: InputDecoration(
                                  label: const Text("Notes"),
                                  contentPadding: const EdgeInsets.all(20),
                                  floatingLabelStyle:
                                      TextStyle(color: mainColor),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: mainColor),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                        primary: mainColor,
                                        padding: const EdgeInsets.all(20)),
                                    onPressed: imageCount == 12
                                        ? null
                                        : () async {
                                            await FilePicker.platform
                                                .pickFiles(
                                              allowMultiple: true,
                                              type: FileType.image,
                                            )
                                                .then((value) {
                                              value!.files.forEach((eachFile) {
                                                if (imageCount < 12) {
                                                  pickedFiles.files
                                                      .add(eachFile);
                                                  setState(() {
                                                    imageCount++;
                                                  });
                                                }
                                              });
                                            });

                                            // if (pickedFiles != null &&
                                            //     pickedFiles!.files.isNotEmpty) {
                                            //   if (pickedFiles!.files.length > 12) {
                                            //     showErrorDialogue(context,
                                            //         msg: "12 images are allowed only");
                                            //   } else {
                                            //     setState(() {
                                            //       imageCount = pickedFiles!.files.length;
                                            //     });
                                            //   }
                                            // }

                                            // FileUploadInputElement uploadInput =
                                            //     FileUploadInputElement()..accept = "image/*";
                                            // uploadInput.click();
                                            // uploadInput.onChange.listen((event) {
                                            //   final file = uploadInput.files!.first;
                                            //   final reader = FileReader();
                                            //   reader.readAsDataUrl(file);
                                            //   reader.onLoadEnd.listen((event) {
                                            //     print("Done");
                                            //   });
                                            // });
                                          },
                                    icon: const Icon(Icons.image),
                                    label: const Text("Upload")),
                                Text(" ($imageCount / 12 )"),
                              ],
                            ),
                            pickedFiles.files.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                            "New Images ( ${pickedFiles.files.length.toString()} )"),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            pickedFiles.files.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: isMobile
                                          ? Get.width * 0.95
                                          : Get.width * 0.6,
                                      height: Get.height * 0.35,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridView.builder(
                                          itemCount: pickedFiles.files.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      isMobile ? 2 : 4,
                                                  crossAxisSpacing: 10.0,
                                                  mainAxisSpacing: 10.0),
                                          itemBuilder: (context, index) {
                                            return Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Stack(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      showImageDailogue(context,
                                                          bytes: pickedFiles
                                                              .files[index]
                                                              .bytes!);
                                                    },
                                                    child: Image.memory(
                                                      pickedFiles
                                                          .files[index].bytes!,
                                                    ),
                                                  ),
                                                  Align(
                                                    alignment:
                                                        Alignment.topRight,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.red,
                                                      child: IconButton(
                                                          onPressed: () {
                                                            setState(() {
                                                              pickedFiles.files
                                                                  .removeAt(
                                                                      index);
                                                              imageCount =
                                                                  imageCount -
                                                                      1;
                                                            });
                                                          },
                                                          icon: const Icon(
                                                            Icons.delete,
                                                            color: Colors.white,
                                                          )),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            args != null &&
                                    args!.activity.picsUrl != null &&
                                    args!.activity.picsUrl!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.only(top: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                            "Previous Images ( ${args!.activity.picsUrl!.length} )"),
                                      ],
                                    ),
                                  )
                                : const SizedBox(),
                            args != null &&
                                    args!.activity.picsUrl != null &&
                                    args!.activity.picsUrl!.isNotEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      width: isMobile
                                          ? Get.width * 0.95
                                          : Get.width * 0.6,
                                      height: Get.height * 0.35,
                                      decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: GridView.builder(
                                          itemCount:
                                              args!.activity.picsUrl!.length,
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount:
                                                      isMobile ? 2 : 4,
                                                  crossAxisSpacing: 10.0,
                                                  mainAxisSpacing: 10.0),
                                          itemBuilder: (context, index) {
                                            return Stack(
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    showImageDailogue(context,
                                                        url: args!.activity
                                                            .picsUrl![index]);
                                                  },
                                                  child: CachedNetworkImage(
                                                    fadeInCurve: Curves
                                                        .fastLinearToSlowEaseIn,
                                                    placeholder:
                                                        (context, url) =>
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
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Center(
                                                            child: Icon(
                                                                Icons.error)),
                                                    imageUrl:
                                                        "${args!.activity.picsUrl![index]}",
                                                  ),
                                                ),
                                                Align(
                                                  alignment: Alignment.topRight,
                                                  child: CircleAvatar(
                                                    backgroundColor: Colors.red,
                                                    child: IconButton(
                                                        onPressed: () async {
                                                          await homeController
                                                              .deleteIndividualImage(
                                                                  context,
                                                                  imageUrl: args!
                                                                          .activity
                                                                          .picsUrl![
                                                                      index]);
                                                          setState(() {
                                                            args!.activity
                                                                .picsUrl!
                                                                .removeAt(
                                                                    index);
                                                            imageCount =
                                                                imageCount - 1;
                                                          });
                                                          await homeController
                                                              .updateActivity(
                                                                  context,
                                                                  activity: args!
                                                                      .activity);
                                                        },
                                                        icon: const Icon(
                                                          Icons.delete,
                                                          color: Colors.white,
                                                        )),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        ),
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            const Divider(),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 20, horizontal: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text("Close"),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        primary: mainColor),
                                    onPressed: () {
                                      if (formKey.currentState!.validate()) {
                                        ActivityModel newActivity =
                                            ActivityModel(
                                          uid: args!.activity.uid,
                                          activityId: args!.activity.activityId,
                                          organizationName: orgNameCon.text,
                                          hours: homeController.hours,
                                          dateFrom: homeController.dateFrom!,
                                          dateTo: homeController.dateTo,
                                          dateCreated:
                                              args!.activity.dateCreated,
                                          notes: notesCon.text,
                                          picsUrl: args!.activity.picsUrl,
                                        );

                                        homeController.editActivity(context,
                                            activity: newActivity,
                                            pickedFiles: pickedFiles);
                                      }
                                    },
                                    child: const Padding(
                                      padding: EdgeInsets.all(15.0),
                                      child: Text("Update Activity"),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class EditScreenArgs {
  ActivityModel activity;
  EditScreenArgs({required this.activity});
}
