import 'dart:async';
import 'dart:convert';
import 'dart:io';
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

Future<List> getAllDoctor() async {
  var url = 'http://www.breakvoid.com/DoktorSaya/ViewAllDoctor.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {'action': 'get'}).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}
