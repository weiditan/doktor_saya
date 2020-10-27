import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<List> getSpecialist() async {
  var url = 'http://www.breakvoid.com/DoktorSaya/GetSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'get',
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  List data = jsonDecode(response.body);

  return data;
}

Future<List> getDoctorSpecialist(String roleId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorSpecialist.php';
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

Future<Map> addDoctorSpecialist(
    String roleId, int specialistId, String subSpecialist) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'add',
      'role_id': roleId,
      'specialist_id': specialistId.toString(),
      'sub_specialist': subSpecialist
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

Future<Map> deleteDoctorSpecialist(String doctorSpecialistId) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/DoctorSpecialist.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'action': 'delete',
      'doctor_spec_id': doctorSpecialistId
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

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

Future<Map> getUserDetail(String roleId, String role) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/ViewUserDetail.php';
  http.Response response = await retry(
    // Make a GET request
    () => http.post(url,
        body: {'role_id': roleId, 'role': role}).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}

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
