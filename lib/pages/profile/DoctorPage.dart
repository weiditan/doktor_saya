import 'dart:async';

import 'package:doktorsaya/pages/call/ext/callFunction.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../functions/loadingScreen.dart';
import 'ext/doctorExpDatabase.dart';
import 'ext/profileDatabase.dart';
import 'ext/profileImage.dart';

import 'ext/diffDate.dart' as dd;
import '../../functions/sharedPreferences.dart' as sp;
import 'ext/specialistDatabase.dart';

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;
  double _screenWidth;

  String _roleId;
  List _arrayDoctor;

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
    await getAllDoctor().then((onValue) async {
      _arrayDoctor = onValue;

      await Future.wait([
        sp.getRoleId().then((onValue) {
          _roleId = onValue;
        }),
        for (int i = 0; i < _arrayDoctor.length; i++)
          _getSpecialist(_arrayDoctor[i]),
        for (int i = 0; i < _arrayDoctor.length; i++)
          _getTotalExp(_arrayDoctor[i]),
      ]);
    });
  }

  Future _getSpecialist(Map doctor) async {
    await getDoctorSpecialist(doctor['doctor_id']).then((onValue) {
      if (onValue != null) {
        String output = "";
        for (int i = 0; i < onValue.length; i++) {
          if (i == 0) {
            output += onValue[i]['malay'];
          } else if (onValue[i - 1]['malay'] != onValue[i]['malay']) {
            output += onValue[i]['malay'];
          }
          if (onValue[i]['sub_specialist'] != "") {
            output += (" - " + onValue[i]['sub_specialist']);
          }
          if ((i + 1) != onValue.length) {
            output += ",\n";
          }
          doctor['specialist'] = output;
        }
      }
    });
  }

  Future _getTotalExp(Map doctor) async {
    await getDoctorExp(doctor['doctor_id']).then((onValue) {
      if (onValue != null) {
        doctor['total_exp'] = dd.outputDiffDate(dd.totalExp(onValue));
      }
    });
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
    _screenWidth = MediaQuery.of(context).size.width;

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
    return (_arrayDoctor == null)
        ? _noDoctor()
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < _arrayDoctor.length; i++)
                  if (_arrayDoctor[i]['doctor_id'] != _roleId)
                    _doctorRow(_arrayDoctor[i]),
              ],
            ),
          );
  }

  Widget _noDoctor() {
    return Center(
      child: Text("Tiada Doktor"),
    );
  }

  Widget _doctorRow(Map doctor) {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/ViewDoctorDetail', arguments: doctor);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      SizedBox(width: 5),
                      showIconProfileImage(doctor['image'], 80, doctor['online']),
                      SizedBox(width: 10),
                      SizedBox(
                        width: _screenWidth - 260,
                        height: 80,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr " + doctor['nickname'],
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "100% Kadar Tindakbalas",
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Montserrat",
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        )
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      _callButton(doctor['doctor_id'], doctor['nickname'],
                          doctor['image']),
                      _messageButton(doctor['doctor_id'], doctor['nickname'],
                          doctor['image']),
                    ],
                  ),
                ],
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (doctor['specialist'] != null)
                        Text(
                          doctor['specialist'],
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      if (doctor['total_exp'] != null)
                        Text(
                          doctor['total_exp'] + " Pengalaman",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                          ),
                        ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _callButton(String doctorId, String doctorName, String doctorImage) {
    return SizedBox(
      width: 110,
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.call),
            SizedBox(
              width: 5,
            ),
            Text(
              "Panggil",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
            ),
          ],
        ),
        onPressed: () {
          callDoctor(context, _roleId, doctorId, doctorName, doctorImage);
        },
      ),
    );
  }

  Widget _messageButton(
      String doctorId, String doctorName, String doctorImage) {
    return SizedBox(
      width: 110,
      child: RaisedButton(
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.message),
            SizedBox(
              width: 5,
            ),
            Text(
              "Mesej",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/Message', arguments: {
            'sender': _roleId,
            'receiver': doctorId,
            'doctor_name': doctorName,
            'doctor_image': doctorImage
          });
        },
      ),
    );
  }
}
