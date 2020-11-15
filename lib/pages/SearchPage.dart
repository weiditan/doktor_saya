import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:doktorsaya/pages/profile/ext/profileDatabase.dart';
import 'package:doktorsaya/pages/profile/ext/profileImage.dart';
import 'package:doktorsaya/pages/profile/ext/specialistDatabase.dart';
import 'package:flutter/material.dart';

import 'call/ext/callFunction.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List _arraySpecialist, _arraySubSpecialist, _arrayDoctor;
  String _valueSpecialist = "";
  String _valueSubSpecialist = "";
  String _roleId;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    _roleId = await getRoleId();
    _arraySpecialist = await getSpecialist();
    _arraySubSpecialist = await getSubSpecialist();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          onChanged: (s) {
            getAllDoctor(_searchController.text, _valueSpecialist, _valueSubSpecialist)
                .then((onValue) {
              setState(() {
                _arrayDoctor = onValue;
              });
            });
          },
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _searchController.text = "";
              })
        ],
        bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
              child: Row(
                children: [
                  _selectSpecialist(),
                  if (_valueSpecialist != "0" && _valueSpecialist != "1")
                    SizedBox(width: 5),
                  _selectSubSpecialist(),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60.0)),
      ),
      body: _secondScreen(),
    );
  }

  Widget _selectSpecialist() {
    return (_arraySpecialist == null)
        ? Container()
        : Flexible(
            // width: 150,
            child: DropdownButtonFormField(
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                labelText: "Jenis Pakar",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: [
                DropdownMenuItem<String>(
                  child: Text("Semua"),
                  value: "",
                ),
                for (int i = 0; i < _arraySpecialist.length; i++)
                  DropdownMenuItem<String>(
                    child: Text(_arraySpecialist[i]['malay']),
                    value: _arraySpecialist[i]['specialist_id'],
                  ),
              ],
              onChanged: (value) {
                getAllDoctor(_searchController.text, _valueSpecialist, _valueSubSpecialist)
                    .then((onValue) {
                  setState(() {
                    _arrayDoctor = onValue;
                  });
                });
                setState(() {
                  _valueSpecialist = value;
                  _valueSubSpecialist = "";
                });
              },
              value: _valueSpecialist,
            ),
          );
  }

  Widget _selectSubSpecialist() {
    return (_arraySubSpecialist == null ||
            _valueSpecialist == null ||
            _valueSpecialist == "" ||
            _valueSpecialist == "0" ||
            _valueSpecialist == "1")
        ? Container()
        : Flexible(
            //width: 150,
            child: DropdownButtonFormField(
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                labelText: "Pakar",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(
                  child: Text("Semua"),
                  value: "",
                ),
                for (int i = 0; i < _arraySubSpecialist.length; i++)
                  if (_valueSpecialist ==
                      _arraySubSpecialist[i]['specialist_id'])
                    DropdownMenuItem<String>(
                      child: Text(
                        _arraySubSpecialist[i]['sub_specialist'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: _arraySubSpecialist[i]['sub_specialist'],
                    ),
              ],
              onChanged: (String value) {
                getAllDoctor(_searchController.text, _valueSpecialist, _valueSubSpecialist)
                    .then((onValue) {
                  setState(() {
                    _arrayDoctor = onValue;
                  });
                });
                setState(() {
                  _valueSubSpecialist = value;
                });
              },
              value: _valueSubSpecialist,
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
      margin: EdgeInsets.only(left: 15, right: 10, top: 10),
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
                      showIconProfileImage(
                          doctor['image'], 80, doctor['online']),
                      SizedBox(width: 10),
                      SizedBox(
                          // width: _screenWidth - 260,
                          height: 80,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dr " + doctor['nickname'],
                                overflow: TextOverflow.ellipsis,
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
                          )),
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
