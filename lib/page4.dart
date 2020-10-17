import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import 'SharedPreferencesFunction.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {

  bool _loadingVisible = true;
  bool _loadingIconVisible = true;
  double _maxWidth;
  Map _userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SharedPreferencesFunction sp = SharedPreferencesFunction();
    sp.getUserId().then((id){
      sp.getRole().then((role){
        _getUserDetail(id.toString(), role)
            .timeout(new Duration(seconds: 15))
            .then((s) {
              setState(() {
                _userData = s;
                _loadingIconVisible = false;
              });
              Timer(Duration(milliseconds: 500), () {
                setState(() {
                  _loadingVisible = false;
                });
              });
            })
            .catchError((e) {
          print(e);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenWidth * 0.7;
    } else {
      _maxWidth = _screenWidth * 0.9;
    }

    return Scaffold(
      body: AnimatedCrossFade(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        crossFadeState: _loadingVisible
        ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstCurve: Curves.easeOut,
        secondCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        firstChild: _firstScreen(),
        secondChild: _secondScreen(),
      ),
    );
  }



  Widget _firstScreen(){
    return Center(
      child: _loadingIcon(),
    );
  }

  Widget _secondScreen(){
    if(_userData != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          _profileImage(_maxWidth),
          _heading1("PROFIL"),
          _heading2("Nama Penuh"),
          _heading3(_userData['fullname']),
          _heading2("Jantina"),
          _heading3(_gender()),
          _heading2("Umur"),
          _heading3(_age()),
          Divider(
            thickness: 1,
          ),
          _heading1("HUBUNGAN"),
          _heading2("Email"),
          _heading3(_userData['email']),
          _heading2("No Telefon"),
          _heading3(_userData['phone']),
          Divider(
            thickness: 1,
          ),
          _logoutButton(context),
        ],
      );
    }
    return Container();
  }

  Widget _loadingIcon() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _loadingIconVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _profileImage(_maxWidth) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: Icon(
          Icons.account_circle,
          size: _maxWidth * 0.7,
          color: Colors.grey,
        ) //_logo(_maxWidth),
        );
  }

  Widget _heading1(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 22,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _heading2(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _heading3(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 30, top: 3),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }

  Widget _logoutButton(context) {
    return SizedBox(
      width: 120,
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "logout",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          SharedPreferencesFunction sp = SharedPreferencesFunction();
          sp.clear().then((s) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/WelcomePage', (Route<dynamic> route) => false);
          });
        },
      ),
    );
  }

  String _gender(){
    if(_userData['gender']=="0"){
      return "Lelaki";
    }else{
      return "Perempuan";
    }
  }

  String _age(){

    DateTime birthday = DateTime.parse(_userData['birthday']);
    DateTime today = DateTime.now();
    int differenceYears = today.year - birthday.year;
    int differenceDays = today.difference(DateTime(today.year,birthday.month,birthday.day)).inDays;

    if(differenceDays<0){
      differenceYears = differenceYears - 1;
    }

    return differenceYears.toString();

  }

  Future<Map> _getUserDetail(_userId, _role) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/ViewUserDetail.php';
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
