import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterUser extends StatefulWidget {
  final String role;
  RegisterUser({Key key, @required this.role}) : super(key: key);

  @override
  _RegisterUserState createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  @override
  Widget build(BuildContext context) {

    Widget _button;

    if(widget.role=="doctor"){
      _button = _registerDoctorButton();
    }else{
    _button = _submitButton();
    }

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
              _entryField("Nama Penuh", TextInputType.text, true, null, null, true),
              _entryField("Nama Panggilan", TextInputType.text, true, null, null, true),
              _entryField("Jantina", TextInputType.text, true, null, null, true),
              _entryField("Tarikh Lahir", TextInputType.text, true, null, null, true),
              _entryField("No Telefon", TextInputType.text, true, null, null, true),
              SizedBox(height: 20),
              _button,
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

  Widget _registerDoctorButton() {
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
            "Seterusnya",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: () {
          Navigator.pushNamed(context, '/RegisterDoctor');
        }

      ),
    );
  }
}
