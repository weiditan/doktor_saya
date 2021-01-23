import 'dart:async';

import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'ViewDoctorDetail.dart';
import 'ext/doctorExpDatabase.dart';
import 'ext/profileDatabase.dart';
import 'ext/profileImage.dart';

import 'ext/diffDate.dart' as dd;

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();

  final String requestStatus;
  DoctorPage({Key key, @required this.requestStatus}) : super(key: key);
}

class _DoctorPageState extends State<DoctorPage> {
  List _arrayDoctor;
  String _roleId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    _roleId = await getRoleId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List>(
        future: getAllDoctor("", "", "", widget.requestStatus),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _arrayDoctor = snapshot.data;
            return _secondScreen();
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Future<String> _getTotalExp(doctorId) async {
    String _data;
    await getDoctorExp(doctorId).then((onValue) {
      if (onValue != null) {
        _data = dd.outputDiffDate(dd.totalExp(onValue));
      }
    });
    return _data;
  }

  Widget _secondScreen() {
    return (_arrayDoctor == null || _arrayDoctor.length == 0)
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
    Color _bgColour;

    if (widget.requestStatus == "3") {
      _bgColour = Colors.pink[200];
    } else if (widget.requestStatus == "1") {
      _bgColour = Colors.amber[300];
    }

    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      color: _bgColour,
      child: InkWell(
        onTap: () {
          Navigator.push(context,MaterialPageRoute(builder: (context) => ViewDoctorDetail(doctor,setState)));
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(width: 5),
                    showIconProfileImage(doctor['image'], 80, doctor['online']),
                    SizedBox(width: 10),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr " + doctor['nickname'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  doctor['rate'] + "% Kadar Tindakbalas",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    color: Colors.grey[600],
                                  ),
                                ),
                                FutureBuilder<String>(
                                    future: _getTotalExp(doctor['doctor_id']),
                                    builder: (context,
                                        AsyncSnapshot<String> snapshot) {
                                      if (snapshot.hasData) {
                                        return Text(
                                          snapshot.data,
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontFamily: "Montserrat",
                                          ),
                                        );
                                      } else {
                                        return Container();
                                      }
                                    }),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _transformWord(doctor['specialist']),
                        ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _transformWord(String word) {
    List<String> _splitWord = word.split('\n');
    List<Widget> textWidgets = [];
    for (int i = 0; i < _splitWord.length; i++) {
      if (_splitWord[i] == "Doktor Umum" ||
          _splitWord[i] == "Pakar Bedah" ||
          _splitWord[i] == "Pakar Internis" ||
          _splitWord[i] == "Pakar Psikiatri" ||
          _splitWord[i] == "Lain-lain") {
        Text bold = Text(
          _splitWord[i],
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        );
        textWidgets.add(bold);
      } else {
        Widget normal = Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            _splitWord[i],
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
            ),
          ),
        );
        textWidgets.add(normal);
      }
    }
    return textWidgets;
  }
}
