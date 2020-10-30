import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

var url = 'http://www.breakvoid.com/DoktorSaya/Call.php';

Future<Map> checkCall(String roleId) async {

  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'get',
      'role_id': roleId,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> addCall(String roleId, String receiver) async {

  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'add',
      'role_id': roleId,
      'receiver': receiver,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> endCall(String callId) async {

  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'endcall',
      'call_id': callId,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
