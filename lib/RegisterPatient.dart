import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


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
          keyboardType: null,
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
          title: new Text("Material Dialog"),
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
          Navigator.pushNamed(context, '/HomePage');
        }
      ),
    );
  }


}
