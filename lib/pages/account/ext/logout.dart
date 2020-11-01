import 'package:doktorsaya/functions/sharedPreferences.dart' as sp;
import 'package:flutter/material.dart';

logout(BuildContext context) {
  sp.clear().then((s) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/WelcomePage', (Route<dynamic> route) => false);
  });
}
