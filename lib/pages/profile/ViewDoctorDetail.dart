import 'package:doktorsaya/functions/dateConvert.dart';
import 'package:doktorsaya/pages/profile/ext/editProfileDatabase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:doktorsaya/pages/call/ext/callFunction.dart';
import '../../functions/sharedPreferences.dart' as sp;
import 'ext/doctorExpDatabase.dart';
import 'ext/doctorExperience.dart';
import 'ext/doctorSpecialist.dart';
import 'ext/doctorWorkplace.dart';
import 'ext/profileDatabase.dart';
import 'ext/profileDetail.dart';
import 'ext/profileImage.dart';
import '../../functions/loadingScreen.dart';
import 'ext/specialistDatabase.dart';
import 'ext/text.dart' as tx;

class ViewDoctorDetail extends StatefulWidget {
  @override
  _ViewDoctorDetailState createState() => _ViewDoctorDetailState();

  final Map doctor;
  final StateSetter doctorSetState;
  ViewDoctorDetail(this.doctor, this.doctorSetState);
}

class _ViewDoctorDetailState extends State<ViewDoctorDetail> {
  double _screenWidth;
  List _arrayDoctorSpecialist;
  List _arrayDoctorExp;
  Map _userData;
  bool _loadingVisible = true;
  bool _loadingIconVisible = true;
  String _role, _roleId;

  @override
  void initState() {
    super.initState();
    Future.wait([
      getUserDetail(widget.doctor['doctor_id']).then((onValue) {
        setState(() {
          _userData = onValue;
        });
      }),
      sp.getRoleId().then((onValue) {
        _roleId = onValue;
      }),
      sp.getRole().then((onValue) {
        _role = onValue;
      }),
      getDoctorSpecialist(widget.doctor['doctor_id']).then((onValue) {
        _arrayDoctorSpecialist = onValue;
      }),
      getDoctorExp(widget.doctor['doctor_id']).then((onValue) {
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
      body: _portrait(),
    );
  }

  Widget _portrait() {
    return ListView(
      physics: BouncingScrollPhysics(),
      children: <Widget>[
        Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                showProfileImage(widget.doctor['image'], _screenWidth),
                if (_role != "admin")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      _callButton(),
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
              if (_role == "admin") _confirmButton(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _confirmButton() {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_userData != null) _comment(),
          if (_userData != null && _userData['request_status'] != "2")
            _approveButton(),
          if (_userData != null && _userData['request_status'] != "3")
            _disapproveButton(),
        ],
      ),
    );
  }

  Widget _comment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_userData['request_status'] == "1") tx.heading1('Mengesahkan'),
        if (_userData['request_status'] == "2") tx.heading1('Diluluskan'),
        if (_userData['request_status'] == "3") tx.heading1('Tidak Diluluskan'),
        tx.heading2('Tarikh Mohon'),
        tx.heading3(toLocalDateTime(_userData['date_request'])),
        if (_userData['request_status'] != "1")
          tx.heading2('Tarikh Mengesahkan'),
        if (_userData['request_status'] != "1")
          tx.heading3(toLocalDateTime(_userData['date_verification'])),
        if (_userData['request_status'] == "3") tx.heading2('Komen'),
        if (_userData['request_status'] == "3")
          tx.heading3(_userData['comment']),
      ],
    );
  }

  Widget _approveButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "Luluskan",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          approveDoctor(widget.doctor['doctor_id']).then((value) {
            widget.doctorSetState(() {});
            Navigator.pop(context);
          });
        },
      ),
    );
  }

  Widget _disapproveButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Text(
          "Tidak Luluskan",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 14,
          ),
        ),
        onPressed: () {
          _disapproveDialog();
        },
      ),
    );
  }

  Future<void> _disapproveDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        final _formKey = GlobalKey<FormState>();
        final _controller = TextEditingController();

        Widget _entryField() {
          return Padding(
            padding: EdgeInsets.only(left: 20, top: 20, right: 20),
            child: TextFormField(
              style: TextStyle(
                fontSize: 16,
              ),
              decoration: new InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Komen",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              keyboardType: TextInputType.text,
              controller: _controller,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Sila Masukkan Komen';
                }
                return null;
              },
            ),
          );
        }

        return AlertDialog(
          title: Text('Tidak Luluskan'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Form(key: _formKey, child: _entryField())],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Membatalkan'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Tidak Luluskan'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  disapproveDoctor(widget.doctor['doctor_id'], _controller.text)
                      .then((value) {
                    widget.doctorSetState(() {});
                    Navigator.pop(context);
                    Navigator.pop(context);
                  });
                }
              },
            ),
          ],
        );
      },
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
            Text('Kembali',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black))
          ],
        ),
      ),
    );
  }

  Widget _callButton() {
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
        onPressed: () {
          callDoctor(context, _roleId, widget.doctor['doctor_id'],
              widget.doctor['nickname'], widget.doctor['image']);
        },
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
