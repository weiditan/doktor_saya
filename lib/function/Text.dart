import 'package:flutter/material.dart';

Widget heading1(_text) {
  return Padding(
    padding: EdgeInsets.only(left: 10, top: 5),
    child: Text(
      _text,
      style: TextStyle(
        fontSize: 22,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
        color: Colors.orange,
      ),
    ),
  );
}

Widget heading2(_text) {
  return Padding(
    padding: EdgeInsets.only(left: 20, top: 5),
    child: Text(
      _text,
      style: TextStyle(
        fontSize: 18,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}

Widget heading3(_text) {
  return Padding(
    padding: EdgeInsets.only(left: 30, top: 3,right: 30),
    child: Text(
      _text,
      style: TextStyle(
        fontSize: 16,
        fontFamily: "Montserrat",
      ),
    ),
  );
}