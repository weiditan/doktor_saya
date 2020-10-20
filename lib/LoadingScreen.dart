import 'package:flutter/material.dart';

Widget loading(_loadingIconVisible){
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _loadingIconVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: CircularProgressIndicator(),
      ),
    ),
  );
}




