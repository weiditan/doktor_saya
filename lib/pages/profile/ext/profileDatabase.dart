import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<List> getState() async {
  var url = 'http://www.breakvoid.com/DoktorSaya/GetState.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {'action': 'get'}).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<Map> getUserDetail(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/ViewUserDetail.php';
  http.Response response = await retry(
    // Make a GET request
    () =>
        http.post(url, body: {'role_id': roleId}).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<List> getAllDoctor(
    String name, String specialistId, String subSpecialist, String requestStatus) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/ViewAllDoctor.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'get',
      'name': name,
      'specialistId': specialistId,
      'subSpecialist': subSpecialist,
      'requestStatus': requestStatus
    }).timeout(Duration(seconds: 10)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<Map> updateToken() async {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _token = await _firebaseMessaging.getToken();
  print(_token);
  String _roleId = await getRoleId();

  var url = 'http://www.breakvoid.com/DoktorSaya/UpdateToken.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {'role_id': _roleId, 'token': _token}).timeout(
        Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
