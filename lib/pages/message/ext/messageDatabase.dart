import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:doktorsaya/pages/message/ext/setting.dart';
import 'package:doktorsaya/pages/profile/ext/profileDatabase.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

var url = 'http://www.breakvoid.com/DoktorSaya/Message.php';

Future<List> getMessage(String sender, String receiver) async {
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

  pushNotification(sender, receiver, context);

  return data;
}

Future<Map> deleteMessage(messageId) async {
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'delete',
      'message_id': messageId
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<List> getMessageList(String roleId) async {
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

Future pushNotification(String sender, String receiver, String context) async {
  Map _sender = await getUserDetail(sender);
  Map _receiver = await getUserDetail(receiver);

  var url = 'https://fcm.googleapis.com/fcm/send';
  http.Response response = await retry(
    // Make a GET request
    () => http
        .post(url,
            headers: {
              'content-type': 'application/json',
              'Authorization': 'key=' + serverKey
            },
            body: jsonEncode({
              "to": _receiver["token"],
              "collapse_key": "New Message",
              "priority": "high",
              "notification": {
                "title": (sender[0] == "d")
                    ? "Dr " + _sender['nickname']
                    : _sender['nickname'],
                "body": context,
              },
              "data": {
                "click_action": "FLUTTER_NOTIFICATION_CLICK",
                "id": "1",
                "status": "done"
              }
            }))
        .timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  // check the status code for the result
  int statusCode = response.statusCode;
  // this API passes back the id of the new item added to the body
  String body = response.body;
  print(body);
  print(statusCode);
}
