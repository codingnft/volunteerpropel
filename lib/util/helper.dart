import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

RegExp emailValid = RegExp(
    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");

bool get isMobile {
  final data = MediaQueryData.fromWindow(WidgetsBinding.instance!.window);
  return data.size.shortestSide < 600 ? true : false;
}

TextStyle get getAuthCardHeader => GoogleFonts.lato(
      fontSize: 30,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    );

void alertMessage(BuildContext context, String msg) {
  Get.snackbar("Alert", msg,
      duration: const Duration(seconds: 3),
      backgroundColor: Colors.red,
      colorText: Colors.white);
  // ScaffoldMessenger.of(context).showSnackBar(
  //   SnackBar(
  //     behavior: SnackBarBehavior.floating,
  //     dismissDirection: DismissDirection.horizontal,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(24),
  //     ),
  //     padding: EdgeInsets.all(20),
  //     margin: EdgeInsets.only(
  //         bottom: MediaQuery.of(context).size.height - 100,
  //         right: 10,
  //         left: 10),
  //     // elevation: 10,
  //     content: Text(
  //       msg,
  //       textAlign: TextAlign.center,
  //       style: GoogleFonts.lato(fontSize: 16),
  //     ),
  //   ),
  // );
}

String getFormattedDate(DateTime datetime) {
  return "${datetime.month}/${datetime.day}/${datetime.year}";
}
