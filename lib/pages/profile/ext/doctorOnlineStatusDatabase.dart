import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

var url = 'http://www.breakvoid.com/DoktorSaya/DoctorOnlineStatus.php';

Future<Map> getDoctorStatus(String doctorId) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'get',
      'doctor_id': doctorId
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> updateDoctorStatus(String doctorId, String status) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'update',
      'doctor_id': doctorId,
      'status': status
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
