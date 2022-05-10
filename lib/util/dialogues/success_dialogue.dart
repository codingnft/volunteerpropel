import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showSuccessDialogue(BuildContext context, {required String msg}) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      actions: [
        TextButton(
          onPressed: () {
            Get.back();
          },
          child: const Text("Ok"),
        ),
      ],
      content: Row(
        children: [
          const Icon(
            Icons.check_circle,
            color: Colors.green,
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 200,
            child: Text(msg),
          ),
        ],
      ),
    ),
  );
}
