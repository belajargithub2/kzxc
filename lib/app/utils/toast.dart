import 'package:flutter/material.dart';
import 'package:get/get.dart';

alertToast(String? message, {SnackPosition? position}) {
  toast(message, [Colors.red, Colors.redAccent], position: position);
}

successToast(String? message, {SnackPosition? position}) {
  toast(message, [Colors.green, Colors.greenAccent], position: position);
}

infoToast(String? message, {SnackPosition? position}) {
  toast(message, [Colors.blue, Colors.blueAccent], position: position);
}

warningToast(String? message, {SnackPosition? position}) {
  toast(message, [Colors.orange, Colors.orangeAccent], position: position);
}

toast(String? message, List<Color> colors, {SnackPosition? position}) {
  Get.rawSnackbar(
    message: message,
    margin: const EdgeInsets.all(10),
    backgroundGradient: LinearGradient(
      colors: colors,
      tileMode: TileMode.mirror,
    ),
    borderRadius: 10,
    snackPosition: position ?? SnackPosition.TOP,
    animationDuration: const Duration(seconds: 1),
  );
}
