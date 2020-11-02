import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<List> getMessage(String sender, String receiver) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/Message.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'get',
      'sender': sender,
      'receiver': receiver
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<Map> addTextMessage(
    String sender, String receiver, String context) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/Message.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'add',
      'type': 'text',
      'sender': sender,
      'receiver': receiver,
      'context': context
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<List> getMessageList(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/Message.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'getlist',
      'role_id': roleId,
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}
