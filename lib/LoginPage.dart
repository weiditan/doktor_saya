import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  @override
  Widget build(BuildContext context) {

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _maxWidth;

    if(_screenWidth>_screenHeight){
      _maxWidth = _screenWidth*0.7;
    }else{
      _maxWidth = _screenWidth*0.9;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Log Masuk"),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _screenHeight-80,
              maxWidth: _maxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  child: _logo(_maxWidth),
                ),
                Column(
                  children: <Widget>[
                    _entryField("Email",TextInputType.emailAddress,false),
                    SizedBox(height: 8),
                    _entryField("Kata Laluan",TextInputType.text,true),
                    _forgotPassword(),
                    SizedBox(height: 5),
                    _loginButton(),
                    _divider(),
                    _googleButton()
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  child: _register(),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _logo(double _maxWidth) {
    return Container(
      child: Image(
        image: AssetImage("assets/logo.png"),
        width: _maxWidth*0.5,
      ),
    );
  }

  Widget _entryField(_label,_keyboardType,_obscureText){
    return TextFormField(
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
    );
  }

  Widget _forgotPassword(){
    return Container(
      padding: EdgeInsets.only(top: 10,right: 10,bottom: 10),
      alignment: Alignment(1.0,0.0),
      child: InkWell(
        child: Text(
          "Terlupa kala laluan ?",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {

        },
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('atau'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _loginButton(){
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.orange,
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text("Log Masuk",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: (){
          Navigator.pushNamed(context, '/RolePage');
        },
      ),
    );
  }

  Widget _googleButton() {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        color: Colors.white,
        splashColor: Colors.grey,
        highlightColor: Colors.grey[300],
        child:Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google.jpg"),
                width: 25,
                height: 25,
              ),
              Text("Log masuk dengan Google",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  color: Colors.black,
                ),
              ),
            ],
          )
        ),

        onPressed: (){
        },
      ),
    );
  }

  Widget _register(){
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tiada account ?",
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Text(
              'Daftar Akaun',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xfff79c4f),
                  fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(context, '/RegisterPage1', ModalRoute.withName('/'));
            },
          ),
        ],
      )
    );
  }

}
