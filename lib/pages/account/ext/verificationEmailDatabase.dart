import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

var url = 'http://www.breakvoid.com/DoktorSaya/VerificationEmail.php';

Future<Map> sendVerificationEmail(String email, String type) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'sendVerificationEmail',
      'email': email,
      'type' : type
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> checkRegisterCode(String email, String code, String type) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'checkRegisterCode',
      'email': email,
      'code': code,
      'type' : type
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
