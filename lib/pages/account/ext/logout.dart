import 'package:doktorsaya/functions/sharedPreferences.dart' as sp;
import 'package:doktorsaya/pages/account/ext/googleLogin.dart';
import 'package:doktorsaya/pages/profile/ext/doctorOnlineStatusDatabase.dart';
import 'package:flutter/material.dart';

logout(BuildContext context) {
  googleSignOut();
  _updateOfflineStatus();
  sp.clear().then((s) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/WelcomePage', (Route<dynamic> route) => false);
  });
}

Future _updateOfflineStatus() async {
  String _role = await sp.getRole();

  if (_role == 'doctor') {
    String _roleId = await sp.getRoleId();

    await updateDoctorStatus(_roleId, "offline");
  }
}