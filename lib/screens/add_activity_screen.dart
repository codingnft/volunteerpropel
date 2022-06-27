import 'dart:developer';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:volunteer/controller/home_controller.dart';
import 'package:volunteer/routes/routes.dart';
import 'package:volunteer/util/const.dart';
import 'package:volunteer/util/dialogues/error_dialogue.dart';
import 'package:volunteer/util/dialogues/show_image_dialogue.dart';
import 'package:volunteer/util/helper.dart';

class AddActivityScreen extends StatefulWidget {
  const AddActivityScreen({Key? key}) : super(key: key);

  @override
  State<AddActivityScreen> createState() => _AddActivityScreenState();
}

class _AddActivityScreenState extends State<AddActivityScreen> {
  FilePickerResult? pickedFiles = FilePickerResult([]);
  final formKey = GlobalKey<FormState>();
  final orgNameCon = TextEditingController();
  final notesCon = TextEditingController();
  final hoursCon = TextEditingController();
  final organizationSelected = TextEditingController();
  final homeController = Get.find<HomeController>();
  // bool isShowingDropDown = true;

  int imageCount = 0;

  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      try {
        final args = Get.arguments as AddActivityArgs;
        if (args.isFromHome == null) {
          Get.offAllNamed(Routes.homeScreen);
        }
      } catch (e) {
        Get.offAllNamed(Routes.homeScreen);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: mainColor,
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              Get.offAllNamed(Routes.homeScreen);
            },
            icon: const Icon(Icons.arrow_back)),
        title: const Text("Add Activity"),
      ),
      body: SingleChildScrollView(
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
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Card(
                          shape: RoundedRectangleBorder(
                              side: BorderSide(color: mainColor),
                              borderRadius: BorderRadius.circular(20)),
                          elevation: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: DropdownButton<String>(
                                borderRadius: BorderRadius.circular(20),
                                value: organizationSelected.text.isNotEmpty
                                    ? organizationSelected.text
                                    : null,
                                isExpanded: true,
                                underline: const SizedBox(),
                                hint: const Text("Choose Organization"),
                                items: [
                                  const DropdownMenuItem(
                                    child: Text(
                                      notInList,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    value: notInList,
                                  ),
                                  ...homeController.organizationsList.map(
                                    (e) {
                                      return DropdownMenuItem(
                                        child: Text(e.name),
                                        value: e.organizationId,
                                      );
                                    },
                                  ),
                                ],
                                onChanged: (val) {
                                  setState(() {
                                    organizationSelected.text = val!;
                                    if (val == notInList) {
                                      // organizationSelected.text = "";
                                      // isShowingDropDown = false;
                                    }
                                  });
                                }),
                          ),
                        ),
                      ),
                      //  Padding(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 30, vertical: 20),
                      //     child: TextFormField(
                      //       controller: organizationSelected,
                      //       maxLength: 100,
                      //       cursorColor: mainColor,
                      //       decoration: InputDecoration(
                      //           suffixIcon: IconButton(
                      //             icon: const Icon(
                      //               Icons.arrow_drop_down,
                      //             ),
                      //             onPressed: () {
                      //               setState(() {
                      //                 organizationSelected.text = "";
                      //                 isShowingDropDown = true;
                      //               });
                      //             },
                      //           ),
                      //           label: const Text("Organization Name"),
                      //           contentPadding: const EdgeInsets.all(20),
                      //           floatingLabelStyle:
                      //               TextStyle(color: mainColor),
                      //           border: getInputBorder(),
                      //           focusedBorder: getInputBorder(),
                      //           disabledBorder: getInputBorder()),
                      //     ),
                      //   ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: TextFormField(
                          controller: orgNameCon,
                          maxLength: 100,
                          validator: (value) {
                            if (organizationSelected.text == notInList &&
                                (value == null || value.isEmpty)) {
                              return "Activity Name is required";
                            }
                            return null;
                          },
                          cursorColor: mainColor,
                          decoration: InputDecoration(
                              label: const Text("Activity Name"),
                              contentPadding: const EdgeInsets.all(20),
                              floatingLabelStyle: TextStyle(color: mainColor),
                              border: getInputBorder(),
                              focusedBorder: getInputBorder(),
                              disabledBorder: getInputBorder()),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: Column(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Padding(
                            //   padding:
                            //       const EdgeInsets.symmetric(vertical: 10),
                            //   child: Row(
                            //     children: const [
                            //       Text(
                            //         "Hours",
                            //         style: TextStyle(fontSize: 18),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.symmetric(vertical: 10),
                            //   child: Row(
                            //     children: const [
                            //       Text(
                            //         "Duration",
                            //         style: TextStyle(fontSize: 18),
                            //       )
                            //     ],
                            //   ),
                            // ),
                            TextFormField(
                              controller: hoursCon,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Duration is required";
                                }
                                if (int.tryParse(value)! >= 100) {
                                  return "Hours limit are 100";
                                }
                                return null;
                              },
                              maxLength: 3,
                              cursorColor: mainColor,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'^\d+\.?\d{0,2}'))
                              ],
                              decoration: InputDecoration(
                                  hintText: "1, 2, 4.5",
                                  label: const Text("Duration"),
                                  contentPadding: const EdgeInsets.all(20),
                                  floatingLabelStyle:
                                      TextStyle(color: mainColor),
                                  border: getInputBorder(),
                                  focusedBorder: getInputBorder(),
                                  disabledBorder: getInputBorder()),
                            ),
                            // Container(
                            //   decoration: BoxDecoration(
                            //       border: Border.all(
                            //           width: 1, color: mainColor),
                            //       borderRadius: BorderRadius.circular(20)),
                            //   child: DropdownButton<double>(
                            //       isExpanded: true,
                            //       underline: const SizedBox(),
                            //       borderRadius: BorderRadius.circular(10),
                            //       value: homeController.hours,
                            //       items: hoursList
                            //           .map((e) => DropdownMenuItem(
                            //               value: e,
                            //               child: Text(
                            //                 "${e.toString()} hrs",
                            //                 style: const TextStyle(
                            //                     fontSize: 18),
                            //               )))
                            //           .toList(),
                            //       onChanged: (value) {
                            //         homeController.changeHours(value!);
                            //       }),
                            // ),
                          ],
                        ),
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
                                lastDate: DateTime(DateTime.now().year + 50),
                                firstDate: DateTime(DateTime.now().year - 50),
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
                              floatingLabelStyle: TextStyle(color: mainColor),
                              border: getInputBorder(),
                              focusedBorder: getInputBorder(),
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
                                lastDate: DateTime(DateTime.now().year + 50),
                                firstDate: DateTime(DateTime.now().year - 50),
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
                              floatingLabelStyle: TextStyle(color: mainColor),
                              border: getInputBorder(),
                              focusedBorder: getInputBorder(),
                            ),
                          );
                        }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: TextFormField(
                          controller: notesCon,
                          maxLength: 2000,
                          maxLines: 8,
                          cursorColor: mainColor,
                          decoration: InputDecoration(
                            label: const Text("Notes"),
                            contentPadding: const EdgeInsets.all(20),
                            floatingLabelStyle: TextStyle(color: mainColor),
                            border: getInputBorder().copyWith(
                                borderRadius: BorderRadius.circular(20)),
                            focusedBorder: getInputBorder().copyWith(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          // ElevatedButton.icon(
                          //     style: ElevatedButton.styleFrom(
                          //         primary: mainColor,
                          //         padding: const EdgeInsets.all(20)),
                          //     onPressed: imageCount == 12
                          //         ? null
                          //         : () async {
                          //             await FilePicker.platform
                          //                 .pickFiles(
                          //               allowMultiple: true,
                          //               type: FileType.image,
                          //             )
                          //                 .then((value) {
                          //               value!.files.forEach((eachFile) {
                          //                 if (pickedFiles!.files.length < 12) {
                          //                   pickedFiles!.files.add(eachFile);
                          //                 }
                          //               });
                          //               if (pickedFiles != null &&
                          //                   pickedFiles!.files.isNotEmpty) {
                          //                 setState(() {
                          //                   imageCount =
                          //                       pickedFiles!.files.length;
                          //                 });
                          //               }
                          //             });
                          //           },
                          //     icon: const Icon(Icons.image),
                          //     label: const Text("Upload")),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Text("Images ($imageCount / 12 )"),
                          ),
                        ],
                      ),
                      pickedFiles != null && pickedFiles!.files.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: isMobile
                                    ? Get.width * 0.95
                                    : Get.width * 0.6,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: mainColor)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    itemCount: pickedFiles!.files.length + 1,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: isMobile ? 3 : 4,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0),
                                    itemBuilder: (context, index) {
                                      if (index == pickedFiles!.files.length) {
                                        return imageCount < 12
                                            ? getImageAddButton()
                                            : const SizedBox.shrink();
                                      }
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                showImageDailogue(context,
                                                    bytes: pickedFiles!
                                                        .files[index].bytes!);
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    // borderRadius:
                                                    //     BorderRadius.circular(
                                                    //         10),
                                                    image: DecorationImage(
                                                        image: MemoryImage(
                                                          pickedFiles!
                                                              .files[index]
                                                              .bytes!,
                                                        ),
                                                        fit: BoxFit.cover)),
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    pickedFiles!.files
                                                        .removeAt(index);
                                                    imageCount = pickedFiles!
                                                        .files.length;
                                                  });
                                                },
                                                child: CircleAvatar(
                                                  radius: 20,
                                                  backgroundColor: Colors.white,
                                                  child: Image.asset(
                                                    "assets/trash.png",
                                                    width: 20,
                                                    height: 20,
                                                  ),
                                                  // IconButton(
                                                  //     onPressed: () {
                                                  //       setState(() {
                                                  //         pickedFiles!.files
                                                  //             .removeAt(index);
                                                  //         imageCount =
                                                  //             pickedFiles!
                                                  //                 .files.length;
                                                  //       });
                                                  //     },
                                                  //     icon: const Icon(
                                                  //       Icons.delete,
                                                  //       color: Colors.white,
                                                  //     )),
                                                ),
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
                          : Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                  width: isMobile
                                      ? Get.width * 0.95
                                      : Get.width * 0.6,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: mainColor)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GridView.builder(
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount:
                                                    isMobile ? 3 : 4,
                                                crossAxisSpacing: 10.0,
                                                mainAxisSpacing: 10.0),
                                        itemBuilder: (context, index) {
                                          return getImageAddButton();
                                        }),
                                  )),
                            ),
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: mainColor)),
                                ),
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    if (organizationSelected.text.isEmpty &&
                                        orgNameCon.text.isEmpty) {
                                      showErrorDialogue(context,
                                          msg: "Organization is required");
                                      return;
                                    }
                                    homeController.addActivity(context,
                                        orgName: orgNameCon.text,
                                        organizationId:
                                            organizationSelected.text ==
                                                    notInList
                                                ? null
                                                : organizationSelected.text,
                                        hours:
                                            double.tryParse(hoursCon.text) ?? 1,
                                        notes: notesCon.text.isEmpty
                                            ? null
                                            : notesCon.text,
                                        pickedFiles: pickedFiles);
                                  }
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text("Add Activity"),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 30,
                            ),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: mainColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      side: BorderSide(color: mainColor)),
                                ),
                                onPressed: () {
                                  Get.offAllNamed(Routes.homeScreen);
                                },
                                child: const Padding(
                                  padding: EdgeInsets.all(15.0),
                                  child: Text(
                                    "Close",
                                    // style: TextStyle(color: Colors.black),
                                  ),
                                ),
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

  Widget getImageAddButton() {
    return GestureDetector(
        onTap: imageCount == 12
            ? null
            : () async {
                await FilePicker.platform
                    .pickFiles(
                  allowMultiple: true,
                  type: FileType.image,
                )
                    .then((value) {
                  value!.files.forEach((eachFile) {
                    if (pickedFiles!.files.length < 12) {
                      pickedFiles!.files.add(eachFile);
                    }
                  });
                  if (pickedFiles != null && pickedFiles!.files.isNotEmpty) {
                    setState(() {
                      imageCount = pickedFiles!.files.length;
                    });
                  }
                });
              },
        child: Container(
          decoration: BoxDecoration(
            color: mainColor.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Center(
              child: Icon(
            Icons.add_circle_outline,
            color: Colors.white,
            size: 80,
          )),
        ));
  }
}

class AddActivityArgs {
  bool? isFromHome;
  AddActivityArgs({this.isFromHome});
}
