import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../functions/DatabaseConnect.dart' as db;
import '../../functions/sharedPreferences.dart' as sp;
import '../../functions/loadingScreen.dart';
import '../profile/ext/profileImage.dart';

class MessagePage extends StatefulWidget {
  @override
  _MessagePageState createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  String _roleId;
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;
  bool _loop = true;
  List _arrayDoctor;

  @override
  void initState() {
    super.initState();

    getData().then((_) {
      _refresh();
    });
  }

  @override
  void dispose() {
    super.dispose();
    _loop = false;
  }

  Future getData() async {
    _roleId = await sp.getRoleId();
    _arrayDoctor = await db.getMessageList(_roleId);
    setState(() {
      _hideLoadingScreen();
    });
  }

  Future _refresh() async {
    while (_loop) {
      await db.getMessageList(_roleId).then((onValue) {
        setState(() {
          _arrayDoctor = onValue;
        });
      });
      await Future.delayed(Duration(seconds: 5));
    }
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
        secondChild: _secondScreen(),
      ),
    );
  }

  Widget _secondScreen() {
    return (_arrayDoctor == null)
        ? Container()
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < _arrayDoctor.length; i++)
                  _messageRow(
                      _arrayDoctor[i]['doctor_id'],
                      (_arrayDoctor[i]['doctor_id'][0]=="d")?
                      "Dr "+_arrayDoctor[i]['nickname']:_arrayDoctor[i]['nickname'],
                      _arrayDoctor[i]['image'],
                      _arrayDoctor[i]['message'],
                      _arrayDoctor[i]['sendtime'],
                      _arrayDoctor[i]['unread']),
              ],
            ),
          );
  }

  Widget _messageRow(String doctorId, String name, String image, String message,
      String sendTime, String unread) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/Message', arguments: {
          'sender': _roleId,
          'receiver': doctorId,
          'doctor_name': name,
          'doctor_image': image
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                showIconProfileImage(image, 65),
                SizedBox(
                  width: 15,
                ),
                Flexible(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          message,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Montserrat",
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(_outputDate(sendTime)),
                      SizedBox(
                        height: 10,
                      ),
                      (unread != "0")
                          ? Container(
                              width: 25,
                              height: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.red,
                              ),
                              child: Center(
                                child: (int.parse(unread) < 100)
                                    ? Text(unread)
                                    : Text("..."),
                              ))
                          : Text(""),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 80),
              child: Divider(
                thickness: 1,
              ),
            )
          ],
        ),
      ),
    );
  }

  String _outputDate(String sendTime) {
    DateTime _today = DateTime.now();
    DateTime _sendTime = DateTime.parse(sendTime);

    return (DateFormat('MMM d, yyyy').format(_today) !=
            DateFormat('MMM d, yyyy').format(_sendTime))
        ? (DateFormat('MMM d, yyyy').format(_today.add(Duration(days: -1))) !=
                DateFormat('MMM d, yyyy').format(_sendTime))
            ? DateFormat('MMM d, yyyy').format(_sendTime)
            : "Semalam"
        : "Hari ini";
  }
}
