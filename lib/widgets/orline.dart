// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

class HorizontalOrLine extends StatelessWidget {
  const HorizontalOrLine({
    Key? key,
    required this.label,
    required this.height,
  });

  final String label;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      const Expanded(
        child: Divider(),
      ),
      Text("   $label   "),
      const Expanded(
        child: Divider(),
      ),
    ]);
  }
}
