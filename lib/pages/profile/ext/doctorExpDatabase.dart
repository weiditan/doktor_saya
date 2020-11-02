import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<List> getDoctorExp(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorExperience.php';
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

Future<Map> addDoctorExp(
    String roleId, String location, String startDate, String endDate) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorExperience.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'add',
      'role_id': roleId,
      'location': location,
      'startdate': startDate,
      'enddate': endDate
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> deleteDoctorExp(String doctorExpId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorExperience.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'delete',
      'doctor_exp_id': doctorExpId
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}