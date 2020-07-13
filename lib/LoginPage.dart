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
        title: Text("Login"),
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
                _backButton(),
                Padding(
                  padding: EdgeInsets.only(top:10,bottom: 10),
                  child: _logo(_maxWidth),
                ),
                Column(
                  children: <Widget>[
                    _entryField("Email",TextInputType.emailAddress,false),
                    _entryField("Password",TextInputType.text,true),
                    _forgotPassword(),
                    SizedBox(height: 10),
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

  Widget _backButton() {
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
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
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
        fontSize: 20,
      ),
      decoration: new InputDecoration(
          labelText: _label,
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 16,
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
          "Forgot Password",
          style: TextStyle(
            fontFamily: "Montserrat",
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
          Text('or'),
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
          child: Text("Login",
            style: TextStyle(
              fontFamily: "Montserrat",
              fontSize: 20,
              color: Colors.white,
            ),
          ),
        ),
        onPressed: (){
          Navigator.pushNamed(context, '/HomePage');
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
              Text("Sign in with Google",
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
            'Don\'t have an account ?',
            style: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Text(
              'Register',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  color: Color(0xfff79c4f),
                  fontWeight: FontWeight.w600
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/RegisterPage');
            },
          ),
        ],
      )
    );
  }

}
