import 'package:flutter/material.dart';

Widget logo() {
  return Center(
    child: AspectRatio(
      aspectRatio: 1 / 1,
      child: Container(
        margin: EdgeInsets.all(20),
        child: Image(
          image: AssetImage("assets/logo.png"),
          fit: BoxFit.fill,
        ),
      ),
    ),
  );
}