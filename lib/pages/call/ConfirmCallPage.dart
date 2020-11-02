import 'package:doktorsaya/pages/call/ext/callDatabase.dart';
import 'package:doktorsaya/functions/DatabaseConnect.dart';
import 'package:doktorsaya/pages/call/ext/callFunction.dart';
import 'package:doktorsaya/functions/loadingScreen.dart';
import 'package:doktorsaya/pages/profile/ext/profileImage.dart';
import 'package:flutter/material.dart';

class ConfirmCallPage extends StatefulWidget {
  @override
  _ConfirmCallPageState createState() => _ConfirmCallPageState();
  final Map arguments;
  const ConfirmCallPage(this.arguments);
}

class _ConfirmCallPageState extends State<ConfirmCallPage> {
  bool _loadingVisible = true;
  bool _loadingIconVisible = true;
  Map _userData;
  bool _loop = true;

  @override
  void initState() {
    super.initState();

    _getData().then((_) {
      setState(() {
        _hideLoadingScreen();
      });
    });

    _checkEndCall();
  }

  @override
  void dispose() {
    _loop = false;
    super.dispose();
  }


  Future _getData() async {
    _userData = await getUserDetail(widget.arguments['caller']);
  }

  Future _hideLoadingScreen() async {
    setState(() {
      _loadingIconVisible = false;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _loadingVisible = false;
    });
  }

  Future _checkEndCall() async {
    while (_loop) {
      await checkEndCall(widget.arguments['call_id']).then((s){
        if(s['status']){
          Navigator.pop(context);
        }
      });
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCrossFade(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        crossFadeState: _loadingVisible
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstCurve: Curves.easeOut,
        secondCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        firstChild: loadingScreen(_loadingIconVisible),
        secondChild: (_userData != null) ? _secondScreen() : Container(),
      ),
    );
  }

  Widget _secondScreen() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    showIconProfileImage(_userData['image'], 100),
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                          ),
                          Flexible(
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  (widget.arguments['caller'][0] == "d")
                                      ? "Dr " + _userData['nickname']
                                      : _userData['nickname'],
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          )
                        ],
                      ),
                      width: double.infinity,
                      height: 50.0,
                    ),
                  ],
                ),
              ),
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

  Widget _endCallButton() {
    return SizedBox(
      width: 60,
      height: 60,
      child: RaisedButton(
        color: Colors.red,
        shape: CircleBorder(),
        child: Icon(Icons.call_end),
        onPressed: () {
          endCall(widget.arguments['call_id']);
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
          _loop = false;
          acceptCall(context, widget.arguments['call_id'], widget.arguments['caller']);
        },
      ),
    );
  }
}
