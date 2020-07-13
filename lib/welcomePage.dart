import 'dart:async';

import 'package:flutter/material.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {

  bool _buttonVisible = true;
  bool _loadingIconVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 3000), (){
      setState(() {
        _buttonVisible = false;
      });
    });

    Timer(Duration(milliseconds: 2000), (){
      setState(() {
        _loadingIconVisible = false;
      });
    });

  }

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

      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: _screenHeight,
              minWidth: 20,
              maxWidth: _maxWidth,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _logo(_maxWidth),
                AnimatedCrossFade(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  crossFadeState: _buttonVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                  firstCurve: Curves.easeOut,
                  secondCurve: Curves.easeIn,
                  duration: Duration(milliseconds: 500),
                  firstChild: _loadingIcon(),
                  secondChild: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _loginButton(),
                      SizedBox(height: 10,),
                      _registerButton(),
                    ],
                  ),
                ),
              ],
            ),
          )
        ),
      ),
    );
  }

  Widget _loadingIcon(){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _loadingIconVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1000),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _logo(double _maxWidth) {
    return Container(
      child: Image(
        image: AssetImage("assets/logo.png"),
        width: _maxWidth*0.6,
      ),
    );
  }

  Widget _loginButton(){
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: Colors.white,
      splashColor: Colors.grey,
      highlightColor: Colors.grey[300],
      child:Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text("Log Masuk",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: Colors.black,
          ),
        ),
      ),
      onPressed: (){
        Navigator.pushNamed(context, '/LoginPage');
      },
    );
  }

  Widget _registerButton() {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/RegisterPage');
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Buat Akaun',
          style: TextStyle(
            fontFamily: "Montserrat",
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}