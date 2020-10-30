import 'package:shared_preferences/shared_preferences.dart';

Future saveUserId(_userId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('user_id', _userId );
}

Future saveEmail(_email) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('email', _email );
}


Future saveRole(_role) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('role', _role );
}

Future saveRoleId(_roleId) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('role_id', _roleId );
}

Future<int> getUserId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('user_id');
}

Future<String> getEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('email');
}

Future<String> getRole() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('role');
}

Future<String> getRoleId() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('role_id');
}

Future clear() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();
}


