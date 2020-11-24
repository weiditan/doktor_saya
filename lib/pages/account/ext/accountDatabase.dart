import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:doktorsaya/pages/account/ext/encryptData.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

var url = 'http://www.breakvoid.com/DoktorSaya/Account.php';

Future<Map> login(String email, String password) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'login',
      'email': email,
      'password': encrypt(password)
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> googleLogin(String email) async {
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'googleLogin',
      'email': email,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> registerAccount(String email, String password, String role) async {

  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'registerAccount',
      'email': email,
      'password': encrypt(password),
      'role': role
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> resetPassword(String email, String password) async {

  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'resetPassword',
      'email': email,
      'password': encrypt(password)
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> changePassword(String password, String newPassword) async {

  int userId = await getUserId();

  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'changePassword',
      'userId': userId.toString(),
      'password': encrypt(password),
      'newPassword': encrypt(newPassword)
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<List> getAllAdmin(String email) async {

  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'getAllAdmin',
      'email': email,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}
