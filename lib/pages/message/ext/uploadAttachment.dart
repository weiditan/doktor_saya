import 'package:dio/dio.dart';
import 'package:doktorsaya/functions/progressDialog.dart' as pr;
import 'package:flutter/material.dart';

uploadAttachment(context, filePath) async {

  await pr.showWithPercentage(context, "Hantar");

  var dio = Dio();
  var url = "http://www.breakvoid.com/DoktorSaya/test.php";

  FormData formData = FormData.fromMap({
    "file": await MultipartFile.fromFile(filePath,filename: filePath.split("/").last)
  });

  Response response = await dio.post(
    url,
    data: formData,
    onSendProgress: (int sent, int total) async {
      await pr.updatePercentage((sent/total*100).round().toDouble());
    },
  );

  await pr.hide();
  Navigator.popUntil(context, ModalRoute.withName('/Message'));
  print("done");
}
