import 'package:doktorsaya/pages/account/ext/logout.dart';
import 'package:doktorsaya/pages/profile/EditProfilePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import '../../functions/sharedPreferences.dart' as sp;
import 'ext/doctorExpDatabase.dart';
import 'ext/doctorExperience.dart';
import 'ext/doctorSpecialist.dart';
import 'ext/doctorWorkplace.dart';
import '../../functions/loadingScreen.dart';
import 'ext/profileDatabase.dart';
import 'ext/profileDetail.dart';
import 'ext/profileImage.dart';
import 'ext/specialistDatabase.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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
    super.initState();

    _getData().then((onValue) {
      setState(() {
        _hideLoadingScreen();
      });
    });
  }

  Future _getData() async {
    await Future.wait([
      sp.getRoleId().then((onValue) {
        _roleId = onValue;

        if (_roleId[0] == "d") {
          _role = "doctor";
        } else {
          _role = "patient";
        }
      }),
    ]);

    await Future.wait([
      getUserDetail(_roleId).then((onValue) {
        _userData = onValue;
      }),
      getDoctorSpecialist(_roleId).then((onValue) {
        _arrayDoctorSpecialist = onValue;
      }),
      getDoctorExp(_roleId).then((onValue) {
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
      return SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
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
            Padding(
              padding: EdgeInsets.only(left: 10, right: 10),
              child: Column(
                children: <Widget>[
                  if(_roleId[0]!="d")_registerDoctorButton(),
                  _editProfileButton(),
                  _changePasswordButton(),
                  _logoutButton(),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }

  Widget _registerDoctorButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.grey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "Memohon Untuk Menjadi Doktor",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          _registerDoctorDialog(_userData['date_request'],_userData['date_verification'],_userData['request_status'],_userData['comment']);
        },
      ),
    );
  }

  Future<void> _registerDoctorDialog(dateRequest, dateVerification, requestStatus, comment) async {
    Widget _dialogBody() {
      switch (requestStatus) {
        case "1":
          {
            return ListBody(
              children: <Widget>[
                Text(
                  'Tarikh Mohon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(DateFormat('MMM d, yyyy').format(
                      DateTime.parse(dateRequest))),
                ),
                SizedBox(height: 10),
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Mengesahkan',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                ),
              ],
            );
          }
          break;

        case "2":
          {
            return ListBody(
              children: <Widget>[
                Text(
                  'Tarikh Mohon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(DateFormat('MMM d, yyyy').format(
                      DateTime.parse(dateRequest))),
                ),
                SizedBox(height: 10),
                Text(
                  'Tarikh Mengesahkan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(DateFormat('MMM d, yyyy').format(
                      DateTime.parse(dateVerification))),
                ),
                SizedBox(height: 10),
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Lulus',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
              ],
            );
          }
          break;

        case "3":
          {
            return ListBody(
              children: <Widget>[
                Text(
                  'Tarikh Mohon',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(DateFormat('MMM d, yyyy').format(
                      DateTime.parse(dateRequest))),
                ),
                SizedBox(height: 10),
                Text(
                  'Tarikh Mengesahkan',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(DateFormat('MMM d, yyyy').format(
                      DateTime.parse(dateVerification))),
                ),
                SizedBox(height: 10),
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Tidak Lulus',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Komen',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(comment),
                ),
              ],
            );
          }
          break;

        default:
          {
            return ListBody(
              children: <Widget>[
                Text(
                  'Status',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text(
                    'Belum Mohon',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ],
            );
          }
          break;
      }
    }

    Widget _dialogButton() {
      switch (requestStatus) {
        case "1":
          {
            return TextButton(
              child: Text('Kemas Kini'),
              onPressed: () {
                Navigator.pushNamed(context, '/EditProfilePage',
                    arguments: EditProfilePage(role: "doctor", type: "request"));
              },
            );
          }
          break;

        case "2":
          {
            return null;
          }
          break;

        case "3":
          {
            return TextButton(
              child: Text('Mohon'),
              onPressed: () {
                Navigator.pushNamed(context, '/EditProfilePage',
                    arguments: EditProfilePage(role: "doctor", type: "request"));
              },
            );
          }
          break;

        default:
          {
            return TextButton(
              child: Text('Mohon'),
              onPressed: () {
                Navigator.pushNamed(context, '/EditProfilePage',
                    arguments: EditProfilePage(role: "doctor", type: "request"));
              },
            );
          }
          break;
      }
    }

    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Memohon Untuk Menjadi Doktor'),
          content: SingleChildScrollView(
            child: _dialogBody(),
          ),
          actions: <Widget>[
            _dialogButton(),
            TextButton(
              child: Text('Tutup'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _editProfileButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "Kemas Kini Profile",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/EditProfilePage', arguments: EditProfilePage(role: _role, type: null));
        },
      ),
    );
  }

  Widget _changePasswordButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "Tukar Kata Laluan",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/ChangePasswordPage');
        },
      ),
    );
  }

  Widget _logoutButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "Log Keluar",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          logout(context);
        },
      ),
    );
  }
}
