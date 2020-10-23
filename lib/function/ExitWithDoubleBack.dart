import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

DateTime currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;

    Fluttertoast.showToast(
      msg: "Tekan satu kali lagi untuk keluar.",
      backgroundColor: Colors.black,
    );
    return Future.value(false);
  }
  return Future.value(true);
}

