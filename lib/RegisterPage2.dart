import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:retry/retry.dart';

import 'EncryptFunction.dart' as ef;

class RegisterPage2 extends StatefulWidget {
  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  String _email;
  bool _obscureText = true;
  bool _pass1AutoValidate = false;
  bool _pass2AutoValidate = false;
  bool _isVisible = true;
  final _codeController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
    _email = ModalRoute.of(context).settings.arguments;

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _maxWidth;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenWidth * 0.7;
    } else {
      _maxWidth = _screenWidth * 0.9;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Akaun'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxWidth,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: _logo(_maxWidth),
              ),
              _emailField(),
              AnimatedCrossFade(
                // If the widget is visible, animate to 0.0 (invisible).
                // If the widget is hidden, animate to 1.0 (fully visible).
                crossFadeState: _isVisible
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstCurve: Curves.easeOut,
                secondCurve: Curves.easeIn,
                duration: Duration(milliseconds: 500),
                firstChild: Column(
                  children: <Widget>[
                    SizedBox(height: 10),
                    Form(
                      key: _formKey,
                      child: _pinField(),
                    ),
                    SizedBox(height: 20),
                    _verifyButton(),
                  ],
                ),
                secondChild: Form(
                  key: _formKey2,
                  child: Column(
                    children: <Widget>[
                      _password1Field(),
                      _password2Field(),
                      SizedBox(height: 20),
                      _registerButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _logo(_maxWidth) {
    return Container(
      child: Image(
        image: AssetImage("assets/logo.png"),
        width: _maxWidth * 0.6,
      ),
    );
  }

  Widget _emailField() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Email",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        initialValue: _email,
        enabled: false,
      ),
    );
  }

  Widget _password1Field() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Kata Laluan Baru",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
            ),
            onPressed: () {
              _toggle();
            },
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscureText,
        controller: _password1Controller,
        autovalidate: _pass1AutoValidate,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(focus);
        },
        onChanged: (String value) {
          setState(() {
            _pass1AutoValidate = true;
          });
        },
        validator: (String value) {
          if (value.isNotEmpty && value.length < 8) {
            return 'Kata Laluan Tidak Boleh Kurang Daripada 8 Perkataan';
          } else if (value.isEmpty) {
            return 'Sila Masukkan Kata Laluan';
          }
          return null;
        },
      ),
    );
  }

  Widget _password2Field() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Ulang Laluan Baru",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.remove_red_eye,
            ),
            onPressed: () {
              _toggle();
            },
          ),
        ),
        keyboardType: TextInputType.text,
        obscureText: _obscureText,
        controller: _password2Controller,
        autovalidate: _pass2AutoValidate,
        focusNode: focus,
        onChanged: (String value) {
          setState(() {
            _pass2AutoValidate = true;
          });
        },
        validator: (String value) {
          if (value.isNotEmpty && value != _password1Controller.text) {
            return 'Kata Laluan Tidak Sama';
          } else if (value.isEmpty) {
            return 'Sila Masukkan Kata Laluan';
          }
          return null;
        },
      ),
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _pinField() {
    return Container(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 200,
          child: TextFormField(
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Kod Pengesahan Email",
              labelStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            obscureText: false,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            maxLength: 6,
            controller: _codeController,
            onChanged: (String value) {
              _formKey.currentState.validate();
            },
            validator: (String value) {
              if (value.isNotEmpty && value.length < 6) {
                return 'Sila Masukkan\n Kod Pengesahan\n Yang Betul';
              } else if (value.isEmpty) {
                return 'Sila Masukkan\n Kod Pengesahan';
              }
              return null;
            },
          ),
        ));
  }

  Widget _verifyButton() {
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
            "Mengesahkan",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () async {
          final ProgressDialog pr = ProgressDialog(
            context,
            type: ProgressDialogType.Normal,
            isDismissible: false,
          );

          pr.style(
            message: "Memuatkan",
          );

          if (_formKey.currentState.validate()) {
            await pr.show();

            _checkCode(_email, _codeController.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.hide();
                setState(() {
                  _isVisible = false;
                });
              } else {
                await pr.hide();
                print(s);
              }
            }).catchError((e) async {
              await pr.hide();
              print(e);
            });
          }
        },
      ),
    );
  }

  Widget _registerButton() {
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
            "Daftar",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () async {
          final ProgressDialog pr = ProgressDialog(
            context,
            type: ProgressDialogType.Normal,
            isDismissible: false,
          );

          pr.style(
            message: "Memuatkan",
          );

          if (_formKey2.currentState.validate()) {
            await pr.show();

            _registerAccount(_email, _password1Controller.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.hide();
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else {
                await pr.hide();
                print(s);
              }
            }).catchError((e) async {
              await pr.hide();
              print(e);
            });
          }
        },
      ),
    );
  }

  Future<Map> _checkCode(_email, _code) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/CheckCode.php';
    http.Response response = await retry(
      // Make a GET request
      () => http.post(url,
          body: {'email': _email, 'code': _code}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);

    return data;
  }

  Future<Map> _registerAccount(_email, _password) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/RegisterAccount.php';
    http.Response response = await retry(
      // Make a GET request
      () => http.post(url, body: {
        'email': ef.encrypt(_email),
        'password': ef.encrypt(_password)
      }).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);

    return data;
  }
}
