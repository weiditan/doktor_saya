import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import 'functions/ProgressDialog.dart' as pr;

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

    if(_screenWidth>_screenHeight){
      _maxWidth = _screenWidth*0.7;
    }else{
      _maxWidth = _screenWidth*0.9;
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
              minHeight: _screenHeight-80,
              maxWidth: _maxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top:10,bottom: 20),
                      child: _logo(_maxWidth),
                    ),
                    Form(
                      key: _formKey,
                      child: _emailField(),
                    ),
                    SizedBox(height: 20),
                    _nextButton(),
                    _divider(),
                    _googleButton(),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:20,bottom: 10),
                  child: _login(),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _logo(double _maxWidth) {
    return Container(
      child: Image(
        image: AssetImage("assets/logo.png"),
        width: _maxWidth*0.5,
      ),
    );
  }

  Widget _emailField(){
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
        if(value.isNotEmpty){
          return EmailValidator.validate(value) ? null : "Sila Masukkan Email Yang Betul";
        }else {
          return 'Sila Masukkan Email';
        }
      },
    );
  }

  Widget _nextButton(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.orange,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Seterusnya",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () async {

          if(_formKey.currentState.validate()) {

            await pr.show(context,"Memuatkan");

            _sendVerificationEmail(_emailController.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
                  if (s["status"]) {
                    await pr.hide();
                    Navigator.pushNamed(context, '/RegisterPage2', arguments: _emailController.text);
                  }else{
                    await pr.error(s["data"]);
                  }
                })
                .catchError((e) async {
                  await pr.hide();
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

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.white,
        splashColor: Colors.grey,
        highlightColor: Colors.grey[300],
        child:Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image(
                  image: AssetImage("assets/google.jpg"),
                  width: 25,
                  height: 25,
                ),
                Text("Log masuk dengan Google",
                  style: TextStyle(
                    fontFamily: "Montserrat",
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ],
            )
        ),

        onPressed: (){

        },
      ),
    );
  }

  Widget _login(){
    return Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Menpunyai akaun ?",
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w600),
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
                Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', ModalRoute.withName('/'));
              },
            ),
          ],
        )
    );
  }

  Future<Map> _sendVerificationEmail(_email) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/SendVerificationEmail.php';
    http.Response response = await retry(
      // Make a GET request
          () => http.post(url, body: {'email': _email}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);

    return data;
  }
}
