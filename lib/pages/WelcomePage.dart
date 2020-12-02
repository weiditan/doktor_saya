import 'dart:async';

import 'package:doktorsaya/functions/exitWithDoubleBack.dart';
import 'package:flutter/material.dart';

import '../functions/sharedPreferences.dart' as sp;

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  BoxDecoration _boxDecoration;
  bool _buttonVisible = true;
  bool _loadingIconVisible = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    if (await sp.getUserId() == null) {
      _hideLoadingScreen();
    } else {
      String _role = await sp.getRole();

      if (_role == "admin") {
        Navigator.pushNamedAndRemoveUntil(
            context, '/ManageDoctorPage', (Route<dynamic> route) => false);
      } else if (_role == "user") {
        if (await sp.getRoleId() != null) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/HomePage', (Route<dynamic> route) => false);
        } else {
          Navigator.pushNamedAndRemoveUntil(
              context, '/RolePage', (Route<dynamic> route) => false);
        }
      }
    }
  }

  Future _hideLoadingScreen() async {
    setState(() {
      _loadingIconVisible = false;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _buttonVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Brightness _brightness = MediaQuery.of(context).platformBrightness;

    if (_brightness == Brightness.light) {
      _boxDecoration = BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xfffbb448), Color(0xffe46b10)]));
    }

    return Scaffold(
      body: WillPopScope(
          child: (MediaQuery.of(context).orientation == Orientation.portrait)
              ? _portrait()
              : _landscape(),
          onWillPop: onWillPop),
    );
  }

  Widget _landscape() {
    return Container(
      decoration: _boxDecoration,
      child: Center(
        child: Row(
          children: <Widget>[
            Expanded(
              child: _logo(),
            ),
            Expanded(
              child: _showButton(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _portrait() {
    return Container(
      decoration: _boxDecoration,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _logo(),
            _showButton(),
          ],
        ),
      ),
    );
  }

  Widget _logo() {
    return Container(
      margin: EdgeInsets.all(50),
      child: Image(
        image: AssetImage("assets/logo.png"),
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _loadingIcon() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _loadingIconVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 300),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _showButton() {
    return AnimatedCrossFade(
      // If the widget is visible, animate to 0.0 (invisible).
      // If the widget is hidden, animate to 1.0 (fully visible).
      crossFadeState:
          _buttonVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      firstCurve: Curves.easeOut,
      secondCurve: Curves.easeIn,
      duration: Duration(milliseconds: 500),
      firstChild: _loadingIcon(),
      secondChild: Container(
        margin: EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _loginButton(),
            SizedBox(
              height: 10,
            ),
            _registerButton(),
          ],
        ),
      ),
    );
  }

  Widget _loginButton() {
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
          "Log Masuk",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, '/LoginPage');
      },
    );
  }

  Widget _registerButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/EditUserPage1', arguments: "Register");
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Daftar Akaun',
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
