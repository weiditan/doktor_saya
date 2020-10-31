import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

import '../../functions/ProgressDialog.dart' as pr;
import 'ext/googleButton.dart';
import 'ext/logo.dart';
import 'ext/verificationEmailDatabase.dart';

class RegisterPage1 extends StatefulWidget {
  @override
  _RegisterPage1State createState() => _RegisterPage1State();
}

class _RegisterPage1State extends State<RegisterPage1> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

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
        title: Text('Daftar Akaun'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            minHeight: _screenHeight - 80,
            maxWidth: _maxWidth,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 20),
                    child: logo(_maxWidth),
                  ),
                  Form(
                    key: _formKey,
                    child: _emailField(),
                  ),
                  SizedBox(height: 20),
                  _nextButton(),
                  _divider(),
                  googleButton(),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 20, bottom: 10),
                child: _login(),
              ),
            ],
          ),
        )),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
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
      keyboardType: TextInputType.emailAddress,
      obscureText: false,
      controller: _emailController,
      onChanged: (String value) {
        _formKey.currentState.validate();
      },
      validator: (String value) {
        if (value.isNotEmpty) {
          return EmailValidator.validate(value)
              ? null
              : "Sila Masukkan Email Yang Betul";
        } else {
          return 'Sila Masukkan Email';
        }
      },
    );
  }

  Widget _nextButton() {
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
            "Seterusnya",
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

            sendVerificationEmail(_emailController.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                await pr.hide();
                Navigator.pushNamed(context, '/RegisterPage2',
                    arguments: _emailController.text);
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

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('atau'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _login() {
    return Container(
        child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          "Menpunyai akaun ?",
          style:
              TextStyle(fontFamily: "Montserrat", fontWeight: FontWeight.w600),
        ),
        SizedBox(
          width: 10,
        ),
        InkWell(
          child: Text(
            'Log Masuk',
            style: TextStyle(
              fontFamily: "Montserrat",
              color: Color(0xfff79c4f),
              fontWeight: FontWeight.bold,
            ),
          ),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/LoginPage', ModalRoute.withName('/'));
          },
        ),
      ],
    ));
  }
}
