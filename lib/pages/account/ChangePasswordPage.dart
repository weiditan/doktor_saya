import 'package:doktorsaya/pages/account/ext/accountDatabase.dart';
import 'package:flutter/material.dart';
import '../../functions/progressDialog.dart' as pr;
import 'ext/logout.dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;
  bool _passAutoValidate = false;
  bool _pass1AutoValidate = false;
  bool _pass2AutoValidate = false;
  final _focus1 = FocusNode();
  final _focus2 = FocusNode();

  final _passwordController = TextEditingController();
  final _password1Controller = TextEditingController();
  final _password2Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tukar Kata Laluan"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(children: <Widget>[
                _passwordField(),
                _password1Field(),
                _password2Field(),
                SizedBox(
                  height: 20,
                ),
                _changePasswordButton(),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField() {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Kata Laluan Lama",
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
        controller: _passwordController,
        autovalidate: _passAutoValidate,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_focus1);
        },
        onChanged: (String value) {
          setState(() {
            _passAutoValidate = true;
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
          FocusScope.of(context).requestFocus(_focus2);
        },
        focusNode: _focus1,
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
          labelText: "Ulang Kata Laluan Baru",
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
        focusNode: _focus2,
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

  Widget _changePasswordButton() {
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
          if (_formKey.currentState.validate()) {
            await pr.show(context, "Memuatkan");

            changePassword(_passwordController.text, _password1Controller.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.success("Kata Laluan telah berjaya diubah.");
                logout(context);
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
