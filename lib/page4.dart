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
        child: ListView(
          children: <Widget>[
            _profileImage(_maxWidth),
            _heading1("PROFIL"),
            _heading2("Nama Penuh"),
            _heading3("Azhar Bin Zainub"),
            _heading2("Jantina"),
            _heading3("Lelaki"),
            _heading2("Umur"),
            _heading3("42"),
            Divider(
              thickness: 1,
            ),
            _heading1("HUBUNGAN"),
            _heading2("Email"),
            _heading3("azhar@email.com"),
            _heading2("No Telefon"),
            _heading3("012-345 6789"),
            Divider(
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileImage(_maxWidth) {
    return Padding(
        padding: EdgeInsets.only(top: 10, bottom: 20),
        child: Icon(
          Icons.account_circle,
          size: _maxWidth * 0.7,
          color: Colors.grey,
        ) //_logo(_maxWidth),
        );
  }

  Widget _heading1(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 22,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _heading2(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 5),
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
      padding: EdgeInsets.only(left: 30, top: 3),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Montserrat",
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
        onPressed: () {},
      ),
    );
  }
}
