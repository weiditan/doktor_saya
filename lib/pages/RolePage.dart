import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import '../functions/sharedPreferences.dart' as sp;
import '../functions/progressDialog.dart' as pr;

class RolePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Brightness _brightness = MediaQuery.of(context).platformBrightness;
    BoxDecoration _boxDecoration;

    if (_brightness == Brightness.light) {
      _boxDecoration = BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffbb448), Color(0xffe46b10)]));
    }

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _maxWidth;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenWidth * 0.7;
    } else {
      _maxWidth = _screenWidth * 0.9;
    }

    return Scaffold(
      body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            decoration: _boxDecoration,
            child: Center(
                child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: _screenHeight,
                minWidth: 20,
                maxWidth: _maxWidth,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _doctorButton(context),
                  SizedBox(
                    height: 30,
                  ),
                  _patientButton(context),
                ],
              ),
            )),
          )),
    );
  }

  Widget _doctorButton(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: Colors.white,
      splashColor: Colors.grey,
      highlightColor: Colors.grey[300],
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          "Doktor",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {
        _submit(context, "doctor");
      },
    );
  }

  Widget _patientButton(BuildContext context) {
    return InkWell(
      onTap: () {
        _submit(context, "patient");
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Pesakit',
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _submit(context, _role) async {
    await pr.show(context, "Memuatkan");

    sp.getUserId().then((id) {
      _checkRole(id.toString(), _role)
          .timeout(new Duration(seconds: 15))
          .then((s) async {
        if (s["status"]) {
          sp.saveRoleId(s["data"]);
          await pr.hide();
          Navigator.pushNamedAndRemoveUntil(
              context, '/HomePage', (Route<dynamic> route) => false);
        } else {
          await pr.hide();
          Navigator.pushNamed(context, '/EditProfilePage', arguments: _role);
        }
      }).catchError((e) async {
        await pr.hide();
        print(e);
      });
    });
  }

  Future<Map> _checkRole(_userId, _role) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/CheckRole.php';
    http.Response response = await retry(
      // Make a GET request
      () => http.post(url, body: {'user_id': _userId, 'role': _role}).timeout(
          Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);

    return data;
  }
}
