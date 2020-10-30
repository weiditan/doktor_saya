import 'package:flutter/material.dart';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:doktorsaya/databases/CallDatabase.dart';
import 'package:doktorsaya/databases/OnlineStatusDatabase.dart';
import 'package:doktorsaya/functions/ProgressDialog.dart' as pr;

import 'CallPage.dart';

Future<void> callDoctor(BuildContext context, String roleId, String doctorId,
    String doctorName, String doctorImage) async {
  await getDoctorStatus(doctorId).then((onValue) async {
    if (onValue['data'] == "1") {
      // await for camera and mic permissions before pushing video page
      await _handleCameraAndMic();
      String _callId;
      await addCall(roleId, doctorId).then((onValue) {
        _callId = onValue['data'].toString();
      });

      // push video page with given channel name
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallPage(
            channelName: roleId,
            doctorName: doctorName,
            doctorImage: doctorImage,
            callId: _callId,
            role: ClientRole.Broadcaster,
          ),
        ),
      );
    } else {
      pr.show(context, "");
      pr.warning("Doktor luar talian !");
    }
  });
}

Future<void> acceptCall(
    BuildContext context, String callId, String callerId) async {
  // await for camera and mic permissions before pushing video page
  await _handleCameraAndMic();

  // push video page with given channel name
  await Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => CallPage(
        channelName: callerId,
        doctorName: "",
        doctorImage: "",
        callId: callId,
        role: ClientRole.Broadcaster,
      ),
    ),
  );
}

Future<void> _handleCameraAndMic() async {
  await [Permission.camera, Permission.microphone].request();
}
