import 'package:flutter/material.dart';

import '../function/Text.dart' as tx;

Widget showProfileDetail(String role, Map userData){
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      tx.heading1(userData["nickname"]),
      tx.heading2("Nama Penuh"),
      tx.heading3(userData['fullname']),
      tx.heading2("Jantina"),
      tx.heading3(_gender(userData['gender'])),
      tx.heading2("Umur"),
      tx.heading3(_age(userData['birthday'])),
      if (role == "doctor") tx.heading2("Nombor Pendaftaran MMC"),
      if (role == "doctor") tx.heading3(userData['mmc']),
      Divider(
        thickness: 1,
      ),
      tx.heading1("HUBUNGAN"),
      tx.heading2("Email"),
      tx.heading3(userData['email']),
      if (userData['phone'] != "") tx.heading2("No Telefon"),
      if (userData['phone'] != "") tx.heading3(userData['phone']),
      Divider(
        thickness: 1,
      ),
    ],
  );
}

String _gender(String gender) {
  if (gender == "0") {
    return "Lelaki";
  } else {
    return "Perempuan";
  }
}

String _age(String date) {
  DateTime birthday = DateTime.parse(date);
  DateTime today = DateTime.now();
  int differenceYears = today.year - birthday.year;
  int differenceDays = today
      .difference(DateTime(today.year, birthday.month, birthday.day))
      .inDays;

  if (differenceDays < 0) {
    differenceYears = differenceYears - 1;
  }

  return differenceYears.toString();
}