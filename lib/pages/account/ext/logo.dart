import 'package:flutter/material.dart';

Widget logo(double _maxWidth) {
  return Container(
    child: Image(
      image: AssetImage("assets/logo.png"),
      width: _maxWidth * 0.5,
    ),
  );
}