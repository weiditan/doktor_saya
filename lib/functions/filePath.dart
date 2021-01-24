import 'dart:io';

import 'package:path_provider/path_provider.dart';

Future<String> getAppDirectory() async {
  Directory appDocDirectory;
  if (Platform.isIOS) {
    appDocDirectory = await getApplicationDocumentsDirectory();
  } else {
    appDocDirectory = await getExternalStorageDirectory();
  }

  return appDocDirectory.path + "/" ;
}