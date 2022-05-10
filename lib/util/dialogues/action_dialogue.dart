import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showActionDialogue(BuildContext context,
    {required String title,
    required String message,
    required String buttonText,
    required Color buttonColor,
    required Function()? onpressed}) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Cancel"),
        ),
        const SizedBox(
          width: 10,
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(primary: buttonColor),
          onPressed: onpressed,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(buttonText),
          ),
        ),
      ],
      title: Text(title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [SizedBox(width: 250, child: Text(message))],
          ),
          const Divider()
        ],
      ),
    ),
  );
}
