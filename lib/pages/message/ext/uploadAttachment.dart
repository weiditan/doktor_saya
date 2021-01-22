import 'package:dio/dio.dart';
import 'package:doktorsaya/functions/progressDialog.dart' as pr;
import 'package:flutter/material.dart';

uploadAttachment(BuildContext context, filePath, type, sender, receiver,StateSetter messageSetState) async {
  await pr.showWithPercentage(context, "Hantar");

  var dio = Dio();
  var url = 'http://www.breakvoid.com/DoktorSaya/Message.php';

  String _filename = filePath.split("/").last;
  String _filepath = sender + "_" + DateTime.now().millisecondsSinceEpoch.toString() + "-"+filePath.split("/").last;

  FormData formData = FormData.fromMap({
    'action': 'addAttachments',
    'sender': sender,
    'receiver': receiver,
    'context': _filename,
    'type': type,
    'filepath' : _filepath,
    "file": await MultipartFile.fromFile(filePath, filename: _filepath)
  });

  Response response = await dio.post(
    url,
    data: formData,
    onSendProgress: (int sent, int total) async {
      await pr.updatePercentage((sent / total * 100).round().toDouble());
    },
  );

  await pr.hide();

  messageSetState(() {});
  Navigator.popUntil(context, ModalRoute.withName('/Message'));
  print(response);
}
