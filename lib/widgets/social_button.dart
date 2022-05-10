// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButton extends StatelessWidget {
  SocialButton(
      {required this.background,
      required this.icon,
      required this.text,
      required this.onPressed,
      Key? key})
      : super(key: key);

  Color background;
  FaIcon icon;
  String text;
  Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: LayoutBuilder(builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth * 0.8,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: background,
            ),
            onPressed: onPressed,
            child: Row(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: icon,
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      text,
                      style: const TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
