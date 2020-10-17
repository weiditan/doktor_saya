import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';
import 'package:shared_preferences/shared_preferences.dart';


class RegisterPatient extends StatefulWidget {
  @override
  _RegisterPatientState createState() => _RegisterPatientState();
}

class _RegisterPatientState extends State<RegisterPatient> {


  int _valueGender;
  DateTime _dateOfBirth;
  DateTime _selectDate;
  final _fullNameController = TextEditingController();
  final _nickNameController = TextEditingController();
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _maxWidth;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenWidth * 0.7;
    } else {
      _maxWidth = _screenWidth * 0.9;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
            child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxWidth,
          ),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Icon(
                  Icons.account_circle,
                  size: _maxWidth * 0.4,
                  color: Colors.grey,
                )//_logo(_maxWidth),
              ),
              _entryField("Nama Penuh", TextInputType.text, false, null, _fullNameController, true),
              _entryField("Nama Panggilan", TextInputType.text, false, null, _nickNameController, true),
              _selectGender(),
              _dateField(),
              _entryField("No Telefon", TextInputType.text, false, null, _phoneController, true),
              SizedBox(height: 20),
              _submitButton(),
            ],
          ),
        )),
      ),
    );
  }

  Widget _entryField(_label, _keyboardType, _obscureText, _initialValue,
      _controller, _enabled) {
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextFormField(
          style: TextStyle(
            fontSize: 16,
          ),
          decoration: new InputDecoration(
            border: OutlineInputBorder(),
            labelText: _label,
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          keyboardType: _keyboardType,
          obscureText: _obscureText,
          initialValue: _initialValue,
          controller: _controller,
          enabled: _enabled,
        ));
  }

  Widget _selectGender(){
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: DropdownButtonFormField(
          decoration: new InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10,bottom: 10),
            border: OutlineInputBorder(),
            labelText: "Jantina",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          items: [
            DropdownMenuItem<int>(
              child: Text('Lelaki'),
              value: 0,
            ),
            DropdownMenuItem<int>(
              child: Text('Perempuan'),
              value: 1,
            ),
          ],
          onChanged: (value) {
            setState(() {
              _valueGender = value;
            });
          },
          value: _valueGender,

        ),
    );
  }

  Widget _dateField(){
    return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextFormField(
          style: TextStyle(
            fontSize: 16,
          ),
          decoration: new InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Tarikh Lahir",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          controller: _dateController,
          onTap: _showDateDialog,
          focusNode: FocusNode(),

        )
    );
  }

  _showDateDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text("Tarikh Lahir"),
          content: Container(
            height: 200,
            width: 700,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: _dateOfBirth,
                maximumDate: DateTime.now().add(Duration(seconds: 10)),
                onDateTimeChanged: (_date) {
                  setState(() {
                    _selectDate = _date;
                  });
                }
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                setState(() {
                  _dateOfBirth = _selectDate;
                  if(_dateOfBirth!=null) {
                    _dateController.text = DateFormat('MMM d, yyyy').format(_dateOfBirth);
                  }
                });
                Navigator.of(context).pop();
              },
            )
          ],
        )
    );
  }

  Widget _submitButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.orange,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Hantar",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () {
          _getUserIdSharedPreferences().then((id){
            _savePatientData(
                id.toString(),
                _fullNameController.text,
                _nickNameController.text,
                _valueGender.toString(),
                DateFormat('yyyy-MM-dd').format(_dateOfBirth),
                _phoneController.text)
                .timeout(new Duration(seconds: 15))
                .then((s){
              if(s["status"]){
                Navigator.pushNamed(context, '/HomePage');
              }else{
                print(s);
              }
            })
                .catchError((e){
              print(e);
            });
          });
        }
      ),
    );
  }

  Future<Map> _savePatientData(_userId, _fullName,_nickName,_gender,_dateOfBirth,_phone) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/RegisterPatient.php';
    http.Response response = await retry(
      // Make a GET request
          () => http.post(url, body: {
            'user_id' : _userId,
            'role' : 'patient',
            'fullname' : _fullName,
            'nickname' : _nickName,
            'gender' : _gender,
            'birthday' : _dateOfBirth,
            'phone' : _phone,
          }).timeout(Duration(seconds: 5)),

      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);
    return data;
  }

  Future<int> _getUserIdSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

}
