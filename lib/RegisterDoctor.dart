import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterDoctor extends StatefulWidget {
  @override
  _RegisterDoctorState createState() => _RegisterDoctorState();
}

class _RegisterDoctorState extends State<RegisterDoctor> {

  File _image;
  final picker = ImagePicker();

  Future _getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      _image = File(pickedFile.path);
    });
  }

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
              Row(
                children: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 20),
                      child: Icon(
                        Icons.account_circle,
                        size: _maxWidth * 0.4,
                        color: Colors.grey,
                      )//_logo(_maxWidth),
                  ),
                  Text(
                    "Dr Name"
                  ),
                ],
              ),
              _entryField("Jenis Pakar Doktor", TextInputType.text, true, null, null, true),
              _entryField("Pakar Doktor", TextInputType.text, true, null, null, true),
              _entryField("Tempat Kerja", TextInputType.text, true, null, null, true),
              _entryField("Negeri Tempat Kerja", TextInputType.text, true, null, null, true),
              SizedBox(height: 20),
              _imageBox(_maxWidth),
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

  Widget _imageBox(_maxWidth){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Sijil Doktor",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5),
        InkWell(
          onTap: _getImage,
          child: Container(
              width: _maxWidth,
              height: _maxWidth*0.71,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: _image == null
                    ? Text(
                  'No image selected.',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: "Montserrat",
                  ),
                )
                    : Image.file(_image),
              )
          ),
        ),
      ],
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
