import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
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
  final homeController = Get.find<HomeController>();

  int imageCount = 0;
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
            icon: Icon(Icons.arrow_back)),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: TextFormField(
                          controller: orgNameCon,
                          maxLength: 50,
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
                            floatingLabelStyle: TextStyle(color: mainColor),
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
                            padding: const EdgeInsets.symmetric(horizontal: 40),
                            child: Column(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 5),
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
                                      borderRadius: BorderRadius.circular(10),
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
                                        homeController.changeHours(value!);
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
                            floatingLabelStyle: TextStyle(color: mainColor),
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
                                          if (pickedFiles!.files.length < 12) {
                                            pickedFiles!.files.add(eachFile);
                                          }
                                        });
                                        if (pickedFiles != null &&
                                            pickedFiles!.files.isNotEmpty) {
                                          setState(() {
                                            imageCount =
                                                pickedFiles!.files.length;
                                          });
                                        }
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
                      pickedFiles != null && pickedFiles!.files.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: isMobile
                                    ? Get.width * 0.95
                                    : Get.width * 0.6,
                                height: Get.height * 0.35,
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: GridView.builder(
                                    itemCount: pickedFiles!.files.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: isMobile ? 2 : 4,
                                            crossAxisSpacing: 10.0,
                                            mainAxisSpacing: 10.0),
                                    itemBuilder: (context, index) {
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
                                              child: Image.memory(
                                                pickedFiles!
                                                    .files[index].bytes!,
                                              ),
                                            ),
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: CircleAvatar(
                                                backgroundColor: Colors.red,
                                                child: IconButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        pickedFiles!.files
                                                            .removeAt(index);
                                                        imageCount =
                                                            pickedFiles!
                                                                .files.length;
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
                              style:
                                  ElevatedButton.styleFrom(primary: mainColor),
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  homeController.addActivity(context,
                                      orgName: orgNameCon.text,
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
