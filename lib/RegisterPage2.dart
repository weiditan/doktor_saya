import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class RegisterPage2 extends StatefulWidget {
  final String email;
  RegisterPage2({Key key, @required this.email}) : super(key: key);

  @override
  _RegisterPage2State createState() => _RegisterPage2State();
}

class _RegisterPage2State extends State<RegisterPage2> {

  bool _isVisible = true;
  final _codeController = TextEditingController();

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
              maxWidth: _maxWidth,
            ),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 20),
                  child: _logo(_maxWidth),
                ),
                _entryField("Email",TextInputType.emailAddress,false,widget.email,null,false),
                AnimatedCrossFade(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  crossFadeState: _isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstCurve: Curves.easeOut,
                  secondCurve: Curves.easeIn,
                  duration: Duration(milliseconds: 500),
                  firstChild: Column(
                    children: <Widget>[
                      SizedBox(height: 10),
                      _pinField(),
                      SizedBox(height: 20),
                      _verifyButton(),
                    ],
                  ),
                  secondChild: Column(
                    children: <Widget>[
                      _entryField("Kata Laluan Baru",TextInputType.text,true,null,null,true),
                      _entryField("Ulang Kata Laluan",TextInputType.text,true,null,null,true),
                      SizedBox(height: 20),
                      _registerButton(),
                    ],
                  ),
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
        width: _maxWidth*0.6,
      ),
    );
  }

  Widget _entryField(_label,_keyboardType,_obscureText,_initialValue,_controller,_enabled){
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: TextFormField(
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
        initialValue: _initialValue,
        controller: _controller,
        enabled: _enabled,
      )
    );
  }

  Widget _pinField(){
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
            labelText: "kod pengesahan e-mel",
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
        ),
      )
    );
  }

  Widget _verifyButton(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.orange,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Mengesahkan",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: (){
          postData(widget.email,_codeController.text).then((s){
            if(s=="Correct"){
              setState(() {
                _isVisible = false;
              });
            }
          });
        },
      ),
    );
  }

  Widget _registerButton(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.orange,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Daftar",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: (){
          Navigator.pushNamedAndRemoveUntil(context, '/LoginPage', ModalRoute.withName('/'));
        },
      ),
    );
  }

  Future<String> postData(String _email, String _code) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/CheckCode.php';
    http.Response response = await retry(
      // Make a GET request
          () => http.post(url, body: {'email': _email,'code':_code}).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    var data = jsonDecode(response.body);

    return data['status'].toString();
  }

}
