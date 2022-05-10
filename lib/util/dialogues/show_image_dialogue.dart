import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:volunteer/util/const.dart';

void showImageDailogue(BuildContext context, {Uint8List? bytes, String? url}) {
  Get.dialog(
    Stack(
      children: [
        bytes != null && url == null
            ? Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Image.memory(
                      bytes,
                      width: Get.width * 0.7,
                      height: Get.height * 0.8,
                    ),
                  ],
                ),
              )
            : url != null && bytes == null
                ? Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CachedNetworkImage(
                        fadeInCurve: Curves.fastLinearToSlowEaseIn,
                        placeholder: (context, url) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: mainColor.withOpacity(0.5),
                            ),
                          ),
                        ),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                        imageUrl: url,
                        width: Get.width * 0.7,
                        height: Get.height * 0.8,
                      ),
                    ],
                  )
                : const SizedBox(),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Align(
            alignment: Alignment.topRight,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 50,
              ),
            ),
          ),
        ),
      ],
    ),
    barrierDismissible: true,
  );
}
