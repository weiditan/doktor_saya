import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ViewPrescription.dart';
import '../profile/ext/profileImage.dart';
import 'ext/callDatabase.dart';

class CallListPage extends StatefulWidget {
  @override
  _CallListPageState createState() => _CallListPageState();

  final String roleId;
  CallListPage({Key key, @required this.roleId}) : super(key: key);
}

class _CallListPageState extends State<CallListPage> {

  Stream<List<dynamic>> _getData() async* {
    while (true) {
      yield await getCallList(widget.roleId);
      await Future.delayed(Duration(seconds: 5));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<List>(
        stream: _getData(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
          if (snapshot.hasError) return Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.none:
              return Text('没有Stream');
            case ConnectionState.waiting:
              return Center(
                child: CircularProgressIndicator(),
              );
            case ConnectionState.active:
              return _secondScreen(snapshot.data);
          //return Text('active: ${snapshot.data}');
            case ConnectionState.done:
              return Text('Stream已关闭');
          }
          return null; // unreachable
        },
      ),
    );
  }

  Widget _secondScreen(_arrayCallList) {
    return (_arrayCallList == null || _arrayCallList.length == 0)
        ? Container(
            child: Center(
              child: Text("Tiada Panggilan"),
            ),
          )
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                for (int i = 0; i < _arrayCallList.length; i++)
                  _messageRow(
                    _arrayCallList[i]['call_id'],
                    _arrayCallList[i]['caller'],
                    _arrayCallList[i]['accept_call'],
                    (_arrayCallList[i]['id'][0] == "d")
                        ? "Dr " + _arrayCallList[i]['nickname']
                        : _arrayCallList[i]['nickname'],
                    _arrayCallList[i]['image'],
                    _arrayCallList[i]['sendtime'],
                    _arrayCallList[i]['prescription'],
                    _arrayCallList[i]['online'],
                  ),
              ],
            ),
          );
  }

  Widget _messageRow(
      String callId,
      String callerId,
      String acceptCall,
      String name,
      String image,
      String sendTime,
      String prescription,
      String online) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                showIconProfileImage(image, 65, online),
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
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "Montserrat",
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (prescription != "")
                          _prescriptionButton(callId, prescription),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 90,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          _outputDate(sendTime),
                          textAlign: TextAlign.center,
                        ),
                        (acceptCall == "1")
                            ? (widget.roleId == callerId)
                                ? Icon(
                                    Icons.call_made,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.call_received,
                                    color: Colors.green,
                                  )
                            : (widget.roleId == callerId)
                                ? Icon(
                                    Icons.call_missed_outgoing,
                                    color: Colors.red,
                                  )
                                : Icon(
                                    Icons.call_missed,
                                    color: Colors.red,
                                  ),
                      ]),
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
    Duration _timeZone = DateTime.now().timeZoneOffset;
    DateTime _today = DateTime.now();
    DateTime _sendTime = DateTime.parse(sendTime).add(_timeZone);

    return (DateFormat('MMM d, yyyy').format(_today) !=
            DateFormat('MMM d, yyyy').format(_sendTime))
        ? (DateFormat('MMM d, yyyy').format(_today.add(Duration(days: -1))) !=
                DateFormat('MMM d, yyyy').format(_sendTime))
            ? DateFormat('MMM d, yyyy\n').add_jm().format(_sendTime)
            : "Semalam\n" + DateFormat().add_jm().format(_sendTime)
        : DateFormat().add_jm().format(_sendTime);
  }

  Widget _prescriptionButton(String callId, String prescription) {
    return SizedBox(
      width: 100,
      child: RaisedButton(
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.message,
              size: 20,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              "Nasihat",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 12,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPrescription(
                    callId: callId, prescription: prescription)),
          );
        },
      ),
    );
  }
}
