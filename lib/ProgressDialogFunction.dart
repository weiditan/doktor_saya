import 'dart:async';

import 'package:progress_dialog/progress_dialog.dart';
import 'package:flutter/material.dart';

ProgressDialog pr;

Future show(context, message) async {
  pr = ProgressDialog(
    context,
    type: ProgressDialogType.Normal,
    isDismissible: false,
  );

  pr.style(
    progressWidget: Image.asset(
      'assets/double_ring_loading_io.gif',
      package: 'progress_dialog',
    ),
    message: message,
  );

  await pr.show();
}

Future success(message) async {
  pr.update(
      progressWidget: Icon(
        Icons.done,
        size: 50,
        color: Colors.green,
      ),
      message: message
  );

  await Future.delayed(Duration(seconds: 3)).then((value) async {
    await pr.hide();
  });

}

Future error(message) async {
  pr.update(
      progressWidget: Icon(
        Icons.clear,
        size: 50,
        color: Colors.red,
      ),
      message: message
  );

  await Future.delayed(Duration(seconds: 3)).then((value) async {
    await pr.hide();
  });
}

Future hide() async {
  await pr.hide();
}
