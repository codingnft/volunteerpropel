import 'package:flutter/material.dart';
import 'package:volunteer/util/const.dart';

void showLoadingDialogue(BuildContext context) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: mainColor,
          ),
          const SizedBox(
            width: 15,
          ),
          const Text("Loading...")
        ],
      ),
    ),
  );
}

void showCustomLoadingDialogue(BuildContext context, String msg) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (context) => AlertDialog(
      content: Row(
        children: [
          CircularProgressIndicator(
            color: mainColor,
          ),
          const SizedBox(
            width: 15,
          ),
          Text(msg)
        ],
      ),
    ),
  );
}
