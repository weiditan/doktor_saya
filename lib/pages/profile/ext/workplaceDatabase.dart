import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<Map> updateWorkplace(String roleId, String workplace, int stateId,
    String country, String state) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/Workplace.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'update',
      'role_id': roleId,
      'workplace': workplace,
      'state_id': stateId.toString(),
      'country': country,
      'state': state,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> getWorkplace(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/Workplace.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {'action': 'get', 'role_id': roleId}).timeout(
        Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
