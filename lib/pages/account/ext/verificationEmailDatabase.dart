import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

var url = 'http://www.breakvoid.com/DoktorSaya/VerificationEmail.php';

Future<Map> sendVerificationEmail(String email) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'sendVerificationEmail',
      'email': email,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> checkRegisterCode(String email, String code) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'checkRegisterCode',
      'email': email,
      'code': code
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
