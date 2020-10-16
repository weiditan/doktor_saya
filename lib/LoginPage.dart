
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:retry/retry.dart';

import 'SharedPreferencesFunction.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  SharedPreferencesFunction sp = SharedPreferencesFunction();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
        title: Text("Log Masuk"),
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
                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  child: _logo(_maxWidth),
                ),
                Form(
                  key: _formKey,
                  child:Column(
                    children: <Widget>[
                      _emailField(),
                      SizedBox(height: 8),
                      _entryField("Kata Laluan",TextInputType.text,true,_passwordController),
                      _forgotPassword(),
                      SizedBox(height: 5),
                      _loginButton(),
                      _divider(),
                      _googleButton()
                    ],
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  child: _register(),
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

  Widget _entryField(_label,_keyboardType,_obscureText,_controller){
    return TextFormField(
      style: TextStyle(
        fontSize: 16,
      ),
      decoration: new InputDecoration(
        border: OutlineInputBorder(),
          labelText: _label,
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
      ),
      keyboardType: _keyboardType,
      obscureText: _obscureText,
      controller: _controller,
      onChanged: (String value) {
        _formKey.currentState.validate();
      },
      validator: (String value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
      },
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
      onChanged: (String value) {
        _formKey.currentState.validate();
      },
      controller: _emailController,
      validator: (String value) {
        if(value.isNotEmpty){
          return EmailValidator.validate(value) ? null : "Please enter a valid email";
        }else {
          return 'Please enter some text';
        }
      },
    );
  }

  Widget _forgotPassword(){
    return Container(
      padding: EdgeInsets.only(top: 10,right: 10,bottom: 10),
      alignment: Alignment(1.0,0.0),
      child: InkWell(
        child: Text(
          "Terlupa kala laluan ?",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {

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

  Widget _loginButton(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.orange,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Log Masuk",
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
            message: "Log Masuk",
          );


          if (_formKey.currentState.validate()) {
            await pr.show();

            _login(_emailController.text, _passwordController.text)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s["status"]) {
                sp.saveUserId(int.parse(s["data"]));
                await pr.hide();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/RolePage', (Route<dynamic> route) => false);
              } else {
                await pr.hide();
                print(s);
              }
            })
                .catchError((e) {
              print(e);
            });
          }
        }
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

  Widget _register(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tiada account ?",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Text(
              'Daftar Akaun',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xfff79c4f),
                  fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/RegisterPage1', ModalRoute.withName('/'));
            },
          ),
        ],
      )
    );
  }

  Future<Map> _login(_email, _password) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/Login.php';
    http.Response response = await retry(
      // Make a GET request
          () => http.post(url, body: {'email': _email,'password':_password}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);

    return data;
  }
}
