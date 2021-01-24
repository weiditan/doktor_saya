import 'package:doktorsaya/pages/profile/ext/profileImage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ext/messageDatabase.dart';

class MessageListPage extends StatefulWidget {
  @override
  _MessageListPageState createState() => _MessageListPageState();

  final String roleId;
  MessageListPage({Key key, @required this.roleId}) : super(key: key);
}

class _MessageListPageState extends State<MessageListPage> {
  Stream<List> _getData() async* {
    while (true) {
      yield await getMessageList(widget.roleId);
      await Future.delayed(Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List>(
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
            return _showList(snapshot.data);
          //return Text('active: ${snapshot.data}');
          case ConnectionState.done:
            return Text('Stream已关闭');
        }
        return null; // unreachable
      },
    );
  }

  Widget _showList(_arrayDoctor) {
    return (_arrayDoctor == null || _arrayDoctor.length == 0)
        ? _noMessage()
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                if (_arrayDoctor != null || _arrayDoctor.length != 0)
                  for (int i = 0; i < _arrayDoctor.length; i++)
                    _messageRow(
                        _arrayDoctor[i]['doctor_id'],
                        (_arrayDoctor[i]['doctor_id'][0] == "d")
                            ? "Dr " + _arrayDoctor[i]['nickname']
                            : _arrayDoctor[i]['nickname'],
                        _arrayDoctor[i]['image'],
                        _arrayDoctor[i]['message'],
                        _arrayDoctor[i]['sendtime'],
                        _arrayDoctor[i]['unread'],
                        _arrayDoctor[i]['online'],
                        _arrayDoctor[i]['type']),
              ],
            ),
          );
  }

  Widget _noMessage() {
    return Container(
      child: Center(
        child: Text("Tiada Mesaj"),
      ),
    );
  }

  Widget _messageRow(String doctorId, String name, String image, String message,
      String sendTime, String unread, String online, String type) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/Message', arguments: {
          'sender': widget.roleId,
          'receiver': doctorId,
          'doctor_name': name,
          'doctor_image': image,
          'doctor_online': online
        });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 10, right: 10, top: 5),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                showIconProfileImage(image, 65, "0"),
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
                        SizedBox(
                          height: 10,
                        ),
                        (type == "text" || type == "Dokumen")
                            ? Text(
                                message,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: "Montserrat",
                                ),
                              )
                            : Text(
                                type,
                                //message,
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
                      Text(
                        _outputDate(sendTime),
                        textAlign: TextAlign.center,
                      ),
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
                                    ? Text(unread,
                                        style: TextStyle(color: Colors.white))
                                    : Text("...",
                                        style: TextStyle(color: Colors.white)),
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
}
