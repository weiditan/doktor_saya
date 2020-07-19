import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Call extends StatefulWidget {
  @override
  _CallState createState() => _CallState();
}

class _CallState extends State<Call> {
  bool _isVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 5000), () {
      setState(() {
        _isVisible = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCrossFade(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          crossFadeState:
              _isVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
          firstCurve: Curves.easeOut,
          secondCurve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
          firstChild: _waiting(),
          secondChild: _calling()),
    );
  }

  Widget _waiting() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Text(
              "Dr. Azhar",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            _callButton()
          ],
        ),
      ),
    );
  }

  Widget _calling() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(
              "http://www.breakvoid.com/doktorsaya/images/call.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _callButton(),
          SizedBox(height: 50,),
        ],
      ),
    );
  }

  Widget _callButton() {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        color: Colors.red,
        shape: CircleBorder(),
        child: Icon(Icons.call_end),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
