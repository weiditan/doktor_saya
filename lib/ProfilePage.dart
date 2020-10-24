import 'package:doktorsaya/widget/ProfileImage.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'function/DatabaseConnect.dart' as db;
import 'function/SharedPreferences.dart' as sp;
import 'widget/DoctorExperience.dart';
import 'widget/DoctorSpecialist.dart';
import 'widget/DoctorWorkplace.dart';
import 'widget/LoadingScreen.dart';
import 'widget/ProfileDetail.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  bool _loadingVisible = true;
  bool _loadingIconVisible = true;
  double _maxWidth;

  String _role;
  String _roleId;
  List _arrayDoctorSpecialist;
  List _arrayDoctorExp;
  Map _userData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData().then((onValue) {
      setState(() {
        _hideLoadingScreen();
      });
    });
  }

  Future _getData() async {
    await Future.wait([
      sp.getRole().then((onValue) {
        _role = onValue;
      }),
      sp.getRoleId().then((onValue) {
        _roleId = onValue;
      }),
    ]);

    await Future.wait([
      db.getUserDetail(_roleId, _role).then((onValue) {
        _userData = onValue;
      }),
      db.getDoctorSpecialist(_roleId).then((onValue) {
        _arrayDoctorSpecialist = onValue;
      }),
      db.getDoctorExp(_roleId).then((onValue) {
        _arrayDoctorExp = onValue;
      })
    ]);
  }

  Future _hideLoadingScreen() async {
    setState(() {
      _loadingIconVisible = false;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _loadingVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenWidth * 0.7;
    } else {
      _maxWidth = _screenWidth;
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
        firstChild: loadingScreen(_loadingIconVisible),
        secondChild: _secondScreen(),
      ),
    );
  }

  Widget _secondScreen() {
    if (_userData != null) {
      return ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          showProfileImage(_userData['image'], _maxWidth),
          SizedBox(height: 10),
          showProfileDetail(_role, _userData),
          if (_role == "doctor")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                showDoctorSpecialist(_arrayDoctorSpecialist),
                showDoctorWorkplace(_userData),
                showDoctorExperience(_arrayDoctorExp),
              ],
            ),
          _logoutButton(context),
        ],
      );
    }
    return Container();
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
          sp.clear().then((s) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/WelcomePage', (Route<dynamic> route) => false);
          });
        },
      ),
    );
  }
}
