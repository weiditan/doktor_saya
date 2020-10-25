import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'widget/LoadingScreen.dart';
import 'function/DatabaseConnect.dart' as db;
import 'function/DiffDate.dart' as dd;

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;
  double _screenWidth;

  List _arrayDoctor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db.getAllDoctor().then((onValue) {
      _arrayDoctor = onValue;
      _arrayDoctor.forEach((doctor){
        db.getDoctorExp(doctor['doctor_id']).then((onValue){
          if(onValue!=null) {
            doctor['total_exp'] = dd.outputDiffDate(dd.totalExp(onValue));
          }
          _hideLoadingScreen();
        });
        db.getDoctorSpecialist(doctor['doctor_id']).then((onValue){
          if(onValue!=null) {
            for (int i = 0; i < onValue.length; i++)
              {

              }




          }
          _hideLoadingScreen();
        });
      });
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
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
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
                    _profileImage(
                        "http://www.breakvoid.com/DoktorSaya/Images/Profiles/" +
                            doctor['image']),
                    SizedBox(width: 10),
                    SizedBox(
                      width: _screenWidth - 260,
                      child: Text(
                        "Dr " + doctor['nickname'],
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: <Widget>[
                    _callButton(),
                    _messageButton(),
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
                    Text(
                      "specialist asdassssssssssssssssssssssssssssssssss",
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    if(doctor['total_exp']!=null)
                    Text(
                      doctor['total_exp']+" Pengalaman",
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
    );
  }


  Future _totalExp(Map doctor) async {
    db.getDoctorExp(doctor['doctor_id']).then((onValue){
      doctor['total_exp'] = dd.outputDiffDate(dd.totalExp(onValue));
    });

  }

  Widget _profileImage(String imageUrl) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        image: DecorationImage(fit: BoxFit.fill, image: NetworkImage(imageUrl)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 10,
            offset: Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
    );
  }



  Widget _callButton() {
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
        onPressed: () {},
      ),
    );
  }

  Widget _messageButton() {
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
        onPressed: () {},
      ),
    );
  }
}
