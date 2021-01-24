import 'package:package_info/package_info.dart';

checkUpdate() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();

  String appName = packageInfo.appName;
  String packageName = packageInfo.packageName;
  String version = packageInfo.version;
  String buildNumber = packageInfo.buildNumber;

  //https://github.com/weiditan/doktor_saya/releases/download/1.0.0/doktor_saya.apk
  print("appName"+appName+", packageName"+packageName+", version"+version+", buildNumber"+buildNumber);
}
