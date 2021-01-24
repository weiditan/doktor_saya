import 'dart:io';

import 'package:dio/dio.dart';
import 'package:doktorsaya/functions/filePath.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info/package_info.dart';
import 'package:open_file/open_file.dart';
import 'package:doktorsaya/functions/progressDialog.dart' as pr;

checkUpdate(context) async {
  String _latestVersion = await _getLatestVersion();
  String _appVersion = await _getAppVersion();

  if (_appVersion != _latestVersion) {
    if (_appVersion[0] != _latestVersion[0]) {
      await _updateDialog(context, _latestVersion, false);
    } else {
      await _updateDialog(context, _latestVersion, true);
    }
  }
}

Future<String> _getAppVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.version;
}

Future<String> _getLatestVersion() async {
  String _url = "https://api.github.com/repos/weiditan/doktor_saya/tags";
  Response response = await Dio().get(_url);
  List data = response.data;

  return data[0]['name'].substring(1);
}

Future<void> _updateApk(context, latestVersion) async {
  await pr.showWithPercentage(context, "Muat Turun Versi Baru");

  String _url = "https://github.com/weiditan/doktor_saya/releases/download/v" +
      latestVersion +
      "/doktor_saya.apk";

  String _filePath = await getAppDirectory() + "update/doktor_saya.apk";

  await _download(_url, _filePath);

  await pr.hide();

  OpenFile.open(_filePath);
}

Future<void> _download(url, filePath) async {
  final Dio _dio = Dio();

  await _dio.download(
    url,
    filePath,
    onReceiveProgress: (int received, int total) async {
      await pr.updatePercentage(
          double.parse((received / total * 100).toStringAsFixed(1)));
    },
  );
}

Future<void> _updateDialog(context, latestVersion, bool canCancel) async {
  return showDialog(
    context: context,
    barrierDismissible: true, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Kemas kini'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text('Adakah anda mahu Mengemas kini Versi Baru?'),
            ],
          ),
        ),
        actions: <Widget>[
          (canCancel)
              ? TextButton(
                  child: Text('Membatalkan'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              : TextButton(
                  child: Text('Keluar'),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
          TextButton(
            child: Text('Kemas kini'),
            onPressed: () async {
              if (Platform.isAndroid) {
                await _updateApk(context, latestVersion);
              } else {
                //await _download(_latestVersion, "ios");
              }
            },
          ),
        ],
      );
    },
  );
}
