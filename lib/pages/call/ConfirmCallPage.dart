import 'package:doktorsaya/WritePrescription.dart';
import 'package:flutter/material.dart';

class ConfirmCall extends StatefulWidget {
  @override
  _ConfirmCallState createState() => _ConfirmCallState();
}

class _ConfirmCallState extends State<ConfirmCall> {
  bool _isVisible = true;

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
              "Aiman",
              style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _callButton(),
                SizedBox(
                  width: 100,
                ),
                _endCallButton(),
              ],
            ),
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
          SizedBox(
            width: 60,
            height: 60,
            child: RaisedButton(
              color: Colors.red,
              shape: CircleBorder(),
              child: Icon(Icons.call_end),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WritePrescription()),
                );
              },
            ),
          ),
          SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }

  Widget _endCallButton() {
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

  Widget _callButton() {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        color: Colors.green,
        shape: CircleBorder(),
        child: Icon(Icons.call),
        onPressed: () {
          setState(() {
            _isVisible = false;
          });
        },
      ),
    );
  }
}
