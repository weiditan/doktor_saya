import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'ext/accountDatabase.dart';
import '../../functions/progressDialog.dart' as pr;
import 'ext/logo.dart';
import 'ext/verificationEmailDatabase.dart';

class EditUserPage2 extends StatefulWidget {
  final Map arguments;
  EditUserPage2(this.arguments);

  @override
  _EditUserPage2State createState() => _EditUserPage2State();
}

class _EditUserPage2State extends State<EditUserPage2> {
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _isVisible = true;
  final _codeController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();
  final focus = FocusNode();

  @override
  Widget build(BuildContext context) {
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
        title: (widget.arguments['type'] == "Forgot Password")
            ? Text('Terlupa kala laluan')
            : Text('Daftar Akaun'),
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
                  child: logo(_maxWidth),
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
                        (widget.arguments['type'] == "Forgot Password")
                            ? _forgotPasswordButton()
                            : _registerButton(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
        initialValue: widget.arguments['email'],
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(focus);
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
          labelText: "Ulang Kata Laluan",
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
        autovalidateMode: AutovalidateMode.onUserInteraction,
        focusNode: focus,
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
              FilteringTextInputFormatter.digitsOnly,
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
          if (_formKey.currentState.validate()) {
            await pr.show(context, "Memuatkan");

            checkRegisterCode(widget.arguments['email'], _codeController.text,
                    widget.arguments['type'])
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.hide();
                setState(() {
                  _isVisible = false;
                });
              } else {
                await pr.error(s["data"]);
              }
            }).catchError((e) async {
              await pr.warning("Sila cuba lagi !");
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
          if (_formKey2.currentState.validate()) {
            await pr.show(context, "Memuatkan");

            registerAccount(
                    widget.arguments['email'], _password1Controller.text, "user")
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.success("Akaun telah berjaya didaftarkan.");
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else {
                await pr.error(s["data"]);
              }
            }).catchError((e) async {
              await pr.warning("Sila cuba lagi !");
              print(e);
            });
          }
        },
      ),
    );
  }

  Widget _forgotPasswordButton() {
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
            "Tukar",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () async {
          if (_formKey2.currentState.validate()) {
            await pr.show(context, "Memuatkan");

            resetPassword(widget.arguments['email'], _password1Controller.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.success("Kata Laluan telah berjaya diubah.");
                Navigator.popUntil(context, ModalRoute.withName('/'));
              } else {
                await pr.error(s["data"]);
              }
            }).catchError((e) async {
              await pr.warning("Sila cuba lagi !");
              print(e);
            });
          }
        },
      ),
    );
  }
}
