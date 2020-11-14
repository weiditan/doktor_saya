import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<List> getSpecialist() async {
  var url = 'http://www.breakvoid.com/DoktorSaya/GetSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'getSpecialist',
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<List> getSubSpecialist() async {
  var url = 'http://www.breakvoid.com/DoktorSaya/GetSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'getSubSpecialist',
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<List> getDoctorSpecialist(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {'action': 'get', 'role_id': roleId}).timeout(
        Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<Map> addDoctorSpecialist(
    String roleId, int specialistId, String subSpecialist) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'add',
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

Future<Map> deleteDoctorSpecialist(String doctorSpecialistId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'delete',
      'doctor_spec_id': doctorSpecialistId
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
