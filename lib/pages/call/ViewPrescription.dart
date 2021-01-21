import 'package:flutter/material.dart';

class ViewPrescription extends StatelessWidget {
  final String callId, prescription;
  ViewPrescription(
      {Key key, @required this.callId, @required this.prescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nasihat"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Card(
              child: Container(
                margin: EdgeInsets.all(20),
                width: double.infinity,
                child: Text(
                  prescription,
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Montserrat",
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
