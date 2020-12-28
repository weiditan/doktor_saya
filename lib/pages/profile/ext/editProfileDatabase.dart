import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

Future<Map> addOrUpdateProfile(_roleId, _userId, _role, _fullName, _nickName,
    _gender, _dateOfBirth, _phone, _imageName, _base64image, _mmc) async {
  var url = 'http://www.breakvoid.com/DoktorSaya/EditProfile.php';

  http.Response response = await retry(
    // Make a GET request
    () => http.post(url, body: {
      'role_id': _roleId,
      'user_id': _userId,
      'role': _role,
      'fullname': _fullName,
      'nickname': _nickName,
      'gender': _gender,
      'birthday': _dateOfBirth,
      'phone': _phone,
      'image_name': _imageName,
      'base64image': _base64image,
      'mmc': _mmc,
    }).timeout(Duration(seconds: 5)),

    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);
  return data;
}

Future<Map> requestDoctor(String doctorId) async {

  var url = 'http://www.breakvoid.com/DoktorSaya/RequestDoctor.php';
  http.Response response = await retry(
    // Make a GET request
        () => http.post(url, body: {
      'action': 'request',
      'doctor_id': doctorId
    }).timeout(Duration(seconds: 5)),
    // Retry on SocketException or TimeoutException
    retryIf: (e) => e is SocketException || e is TimeoutException,
  );

  Map data = jsonDecode(response.body);

  return data;
}
