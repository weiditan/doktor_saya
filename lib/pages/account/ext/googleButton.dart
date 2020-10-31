import 'package:flutter/material.dart';

Widget googleButton() {
  return SizedBox(
    width: double.infinity,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: Colors.white,
      splashColor: Colors.grey,
      highlightColor: Colors.grey[300],
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google.jpg"),
                width: 25,
                height: 25,
              ),
              Text(
                "Log masuk dengan Google",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          )),
      onPressed: () {},
    ),
  );
}