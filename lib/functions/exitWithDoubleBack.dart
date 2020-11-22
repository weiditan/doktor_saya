import 'package:doktorsaya/pages/profile/ext/doctorOnlineStatusDatabase.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'sharedPreferences.dart' as sp;

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
  _updateOfflineStatus();
  return Future.value(true);
}

Future _updateOfflineStatus() async {
  String _roleId = await sp.getRoleId();
  if (_roleId[0] == "d") {
    await updateDoctorStatus(_roleId, "offline");
  }
}
