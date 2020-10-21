import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<List> getSpecialist() async {
  var url = 'http://www.breakvoid.com/DoktorSaya/GetSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<List> getDoctorSpecialist(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/GetDoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
    () =>
        http.post(url, body: {'role_id': roleId}).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<Map> addDoctorSpecialist(
    String roleId, int specialistId, String subSpecialist) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/AddDoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'role_id': roleId,
      'specialist_id': specialistId.toString(),
      'sub_specialist': subSpecialist
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

/*
Future<Map> _getUserDetail(_userId, _role) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/ViewUserDetail.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {'user_id': _userId, 'role': _role}).timeout(
        Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
*/
