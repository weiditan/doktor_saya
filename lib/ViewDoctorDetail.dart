import 'package:flutter/material.dart';

import 'function/DatabaseConnect.dart' as db;
import 'function/SharedPreferences.dart' as sp;
import 'widget/DoctorExperience.dart';
import 'widget/DoctorSpecialist.dart';
import 'widget/DoctorWorkplace.dart';
import 'widget/ProfileDetail.dart';
import 'widget/ProfileImage.dart';
import 'widget/LoadingScreen.dart';

class ViewDoctorDetail extends StatefulWidget {
  @override
  _ViewDoctorDetailState createState() => _ViewDoctorDetailState();

  final Map doctor;
  ViewDoctorDetail(this.doctor);
}

class _ViewDoctorDetailState extends State<ViewDoctorDetail> {
  double _screenWidth;
  List _arrayDoctorSpecialist;
  List _arrayDoctorExp;
  bool _loadingVisible = true;
  bool _loadingIconVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Future.wait([
      db.getDoctorSpecialist(widget.doctor['doctor_id']).then((onValue) {
        _arrayDoctorSpecialist = onValue;
      }),
      db.getDoctorExp(widget.doctor['doctor_id']).then((onValue) {
        _arrayDoctorExp = onValue;
      })
    ]).then((onValue) {
      _hideLoadingScreen();
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
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  showProfileImage(widget.doctor['image'], _screenWidth),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _callButton(context),
                      SizedBox(width: 10),
                      _messageButton(),
                      SizedBox(width: 10),
                    ],
                  )
                ],
              ),
              Positioned(top: 0, left: 0, child: _backButton(context)),
            ],
          ),
          SizedBox(height: 10),
          showProfileDetail("doctor", widget.doctor),
          AnimatedCrossFade(
            crossFadeState: _loadingVisible
                ? CrossFadeState.showFirst
                : CrossFadeState.showSecond,
            firstCurve: Curves.easeOut,
            secondCurve: Curves.easeIn,
            duration: Duration(milliseconds: 500),
            firstChild: loadingScreen(_loadingIconVisible),
            secondChild: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                showDoctorSpecialist(_arrayDoctorSpecialist),
                showDoctorWorkplace(widget.doctor),
                showDoctorExperience(_arrayDoctorExp),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _backButton(context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black))
          ],
        ),
      ),
    );
  }

  Widget _callButton(context) {
    return SizedBox(
      width: 120,
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
        onPressed: () {},
      ),
    );
  }

  Widget _messageButton() {
    return SizedBox(
      width: 120,
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
          sp.getRoleId().then((onValue) {
            Navigator.pushNamed(context, '/Message', arguments: {
              'sender': onValue,
              'receiver': widget.doctor['doctor_id'],
              'doctor_name': widget.doctor['nickname'],
              'doctor_image': widget.doctor['image']
            });
          });
        },
      ),
    );
  }
}
