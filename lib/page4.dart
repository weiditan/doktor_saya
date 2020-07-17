import 'package:flutter/material.dart';

class Page4 extends StatelessWidget {
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
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxWidth,
          ),
          child: ListView(
            children: <Widget>[
              Row(
                children: <Widget>[
                  _profileImage(_maxWidth),
                  Text("Dr. Azhar"),
                ],
              ),
              _heading1("PROFIL"),
              _heading2("Azhar Bin Zainub"),
              _heading3("Lelaki"),
              _heading3("Umur 42 tahun"),
              Divider(
                thickness: 1,
              ),
              _heading1("PAKAR DOKTOR"),
              _heading2("Pakar Bedah"),
              _heading3("Pakar Oftalmologi"),
              Divider(
                thickness: 1,
              ),
              _heading1("TEMPAT KERJA"),
              _heading2("Hospital Melaka Eye Specialist Clinic"),
              _heading3("Melaka, Malaysia"),
              Divider(
                thickness: 1,
              ),
              _heading1("PENGALAMAN"),
              _heading2("Hospital Melaka Eye Specialist Clinic"),
              _heading3("2 tahun"),
              _heading2("The Tun Hussein Onn National Eye Hospital"),
              _heading3("3 tahun 8 bulan"),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileImage(_maxWidth) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: Icon(
          Icons.account_circle,
          size: _maxWidth * 0.4,
          color: Colors.grey,
        ) //_logo(_maxWidth),
        );
  }

  Widget _heading1(_text) {
    return Text(
      _text,
      style: TextStyle(
        fontSize: 22,
        fontFamily: "Montserrat",
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _heading2(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 10,top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _heading3(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 10,top: 3),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }
}
