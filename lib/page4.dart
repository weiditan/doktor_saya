import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'function/DatabaseConnect.dart' as db;
import 'function/SharedPreferences.dart' as sp;
import 'function/Text.dart' as tx;
import 'LoadingScreen.dart' as ls;

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
        firstChild: ls.loadingScreen(_loadingIconVisible),
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
          (_userData['image'] == "")
              ? _noProfileImage(_maxWidth)
              : _profileImage(_maxWidth),
          SizedBox(height: 10),
          tx.heading1(_userData["nickname"]),
          tx.heading2("Nama Penuh"),
          tx.heading3(_userData['fullname']),
          tx.heading2("Jantina"),
          tx.heading3(_gender()),
          tx.heading2("Umur"),
          tx.heading3(_age()),
          if (_role == "doctor") tx.heading2("Nombor Pendaftaran MMC"),
          if (_role == "doctor") tx.heading3(_userData['mmc']),
          Divider(
            thickness: 1,
          ),
          tx.heading1("HUBUNGAN"),
          tx.heading2("Email"),
          tx.heading3(_userData['email']),
          if (_userData['phone'] != "") tx.heading2("No Telefon"),
          if (_userData['phone'] != "") tx.heading3(_userData['phone']),
          Divider(
            thickness: 1,
          ),
          if (_role == "doctor")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tx.heading1("PAKAR DOKTOR"),
                if (_arrayDoctorSpecialist != null)
                  for (int i = 0; i < _arrayDoctorSpecialist.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        tx.heading2(_arrayDoctorSpecialist[i]['malay']),
                        tx.heading3(
                            _arrayDoctorSpecialist[i]['sub_specialist']),
                      ],
                    ),
                Divider(
                  thickness: 1,
                ),
              ],
            ),
          if (_role == "doctor" && _userData['workplace'] != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tx.heading1("TEMPAT KERJA"),
                tx.heading2(_userData['workplace']),
                (_userData['country'] == "")
                    ? tx.heading3(_userData['selected_state'] + ", Malaysia")
                    : tx.heading3(
                        _userData['state'] + ", " + _userData['country']),
                Divider(
                  thickness: 1,
                ),
              ],
            ),

          if (_role == "doctor" && _userData['workplace'] != "")
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                tx.heading1("PENGALAMAN"),
                tx.heading2("Hospital Melaka Eye Specialist Clinic"),
                tx.heading3("2 tahun"),
                tx.heading2("The Tun Hussein Onn National Eye Hospital"),
                tx.heading3("3 tahun 8 bulan"),
                Divider(
                  thickness: 1,
                ),
              ],
            ),

          _logoutButton(context),
        ],
      );
    }
    return Container();
  }

  Widget _noProfileImage(_maxWidth) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 20, bottom: 20),
          child: Icon(
            Icons.account_circle,
            size: _maxWidth * 0.7,
            color: Colors.grey,
          ),
        ),
        Divider(
          thickness: 1,
        ),
      ],
    );
  }

  Widget _profileImage(_maxWidth) {
    return Container(
      width: _maxWidth,
      height: _maxWidth,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        image: DecorationImage(
            fit: BoxFit.fill,
            image: NetworkImage(
                "http://www.breakvoid.com/DoktorSaya/Images/Profiles/" +
                    _userData['image'])),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ), //_logo(_maxWidth),
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
          sp.clear().then((s) {
            Navigator.pushNamedAndRemoveUntil(
                context, '/WelcomePage', (Route<dynamic> route) => false);
          });
        },
      ),
    );
  }

  String _gender() {
    if (_userData['gender'] == "0") {
      return "Lelaki";
    } else {
      return "Perempuan";
    }
  }

  String _age() {
    DateTime birthday = DateTime.parse(_userData['birthday']);
    DateTime today = DateTime.now();
    int differenceYears = today.year - birthday.year;
    int differenceDays = today
        .difference(DateTime(today.year, birthday.month, birthday.day))
        .inDays;

    if (differenceDays < 0) {
      differenceYears = differenceYears - 1;
    }

    return differenceYears.toString();
  }
}
