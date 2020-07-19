import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WritePrescription extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Preskripsi Perubatan"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            child: TextFormField(
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.multiline,
              maxLines: 10,
            ),
          ),
          SizedBox(height: 10,),
          _submitButton(context),
        ],
      ),
    );
  }

  Widget _submitButton(context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(5)),
          ),
          color: Colors.orange,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text(
              "Hantar",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/HomePage');
          }),
    );
  }
}
