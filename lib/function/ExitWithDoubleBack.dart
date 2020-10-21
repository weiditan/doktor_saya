DateTime currentBackPressTime;

Future<bool> onWillPop() {
  DateTime now = DateTime.now();
  if (currentBackPressTime == null ||
      now.difference(currentBackPressTime) > Duration(seconds: 2)) {
    currentBackPressTime = now;
    //Fluttertoast.showToast(msg: exit_warning);
    return Future.value(false);
  }
  return Future.value(true);
}