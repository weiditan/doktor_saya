import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doktorsaya/functions/viewImage.dart';
import 'package:doktorsaya/functions/viewVideo.dart';
import 'package:doktorsaya/pages/message/ext/voiceMessagePlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'bubble.dart';
import 'messageDatabase.dart';

class MessageContainer extends StatefulWidget {
  final String sender, receiver;

  const MessageContainer(
      {Key key, @required this.sender, @required this.receiver})
      : super(key: key);

  @override
  _MessageContainerState createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  /* Timer _t1, _t2;
  List _arrayMessage,_arrayMessageOnPass;


  _getData() async {
    _t1 = Timer.periodic(Duration(milliseconds: 100), (Timer timer) {
      if (_arrayMessageOnPass != widget.arrayMessage) {
        setState(() {
          _arrayMessageOnPass = widget.arrayMessage;
          _arrayMessage = widget.arrayMessage;
        });
      }
    });

    List _data;

    _t2 = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      _data = await getMessage(widget.sender, widget.receiver);
      if (_arrayMessage != _data) {
        setState(() {
          _arrayMessage = _data;
        });
      }
    });
  }

  @override
  void initState() {
    _getData();
    super.initState();
  }

  @override
  void dispose() {
    _t1.cancel();
    _t2.cancel();
    super.dispose();
  }
*/
  Stream<List> _getData() async* {
    while (true) {
      yield await getMessage(widget.sender, widget.receiver);
      await Future.delayed(Duration(seconds: 1));
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
            return _secondScreen(snapshot.data);
          //return Text('active: ${snapshot.data}');
          case ConnectionState.done:
            return Text('Stream已关闭');
        }
        return null; // unreachable
      },
    );
  }

  Widget _secondScreen(_arrayMessage) {
    return Container(
      margin: EdgeInsets.all(10),
      child: ListView(
        physics: BouncingScrollPhysics(),
        reverse: true,
        children: <Widget>[
          SizedBox(height: 60),
          if (_arrayMessage != null)
            for (int i = 0; i < _arrayMessage.length; i++)
              _message(_arrayMessage[i]),
        ],
      ),
    );
  }

  Widget _message(Map message) {
    return GestureDetector(
      onLongPressStart: (LongPressStartDetails details) {
        _deleteMenu(message["message_id"], message["type"], message['context'],
            details.globalPosition.dx, details.globalPosition.dy);
      },
      child: Bubble(
        margin: (message['sender'] == widget.sender)
            ? BubbleEdges.only(top: 5, left: 50, bottom: 5)
            : BubbleEdges.only(top: 5, right: 50, bottom: 5),
        nipRadius: 2,
        alignment: (message['sender'] == widget.sender)
            ? Alignment.topRight
            : Alignment.topLeft,
        nipWidth: 10,
        nipHeight: 8,
        nip: (message['sender'] == widget.sender)
            ? BubbleNip.rightTop
            : BubbleNip.leftTop,
        color: (message['sender'] == widget.sender)
            ? Color.fromRGBO(225, 255, 199, 1.0)
            : Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            _messageDetail(message),
            Text(
              _time(message['sendtime']),
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }

  String _time(sendTime) {
    Duration _timeZone = DateTime.now().timeZoneOffset;
    DateTime _sendTime = DateTime.parse(sendTime).add(_timeZone);

    return DateFormat().add_jm().format(_sendTime);
  }

  Future _deleteMenu(
      messageId, messageType, messageContext, positionX, positionY) async {
    int selected = await showMenu(
      items: [
        if (messageType == "text")
          PopupMenuItem(
            value: 0,
            child: Row(
              children: <Widget>[
                Icon(Icons.copy),
                Text("Salin"),
              ],
            ),
          ),
        PopupMenuItem(
          value: 1,
          child: Row(
            children: <Widget>[
              Icon(Icons.delete),
              Text("Padam"),
            ],
          ),
        )
      ],
      context: context,
      position: RelativeRect.fromLTRB(
          positionX,
          positionY,
          MediaQuery.of(context).size.width,
          MediaQuery.of(context).size.height),
    );

    if (selected == 0) {
      Clipboard.setData(new ClipboardData(text: messageContext));
    } else if (selected == 1) {
      _deleteDialog(messageId);
    }
  }

  Future<void> _deleteDialog(messageId) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Padamkan mesej'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Adakah anda pasti mahu memadamkan mesej ini?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Membatalkan'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Padam'),
              onPressed: () {
                Navigator.of(context).pop();
                deleteMessage(messageId).then((s) {
                  if (s['status']) {
                    setState(() {});
                  }
                });
              },
            ),
          ],
        );
      },
    );
  }

  Widget _messageDetail(Map message) {
    switch (message['type']) {
      case "Gambar":
        {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewImage(
                      message['context'],
                      "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                          message["filepath"]),
                ),
              );
            },
            child: CachedNetworkImage(
              imageUrl:
                  "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                      message["filepath"],
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  Container(
                margin: EdgeInsets.all(15),
                child:
                    CircularProgressIndicator(value: downloadProgress.progress),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          );
        }
        break;

      case "Video":
        {
          return Column(
            children: <Widget>[
              Text(
                message['context'],
                textAlign: (message['sender'] == widget.sender)
                    ? TextAlign.right
                    : TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 5),
              Container(
                width: 130,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.videocam,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Video',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewVideo(
                              message['context'],
                              "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                                  message["filepath"]),
                        ),
                      );
                    }),
              ),
            ],
          );
        }
        break;

      case "Dokumen":
        {
          return Column(
            children: <Widget>[
              Text(
                message['context'],
                textAlign: (message['sender'] == widget.sender)
                    ? TextAlign.right
                    : TextAlign.left,
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
              SizedBox(height: 5),
              Container(
                width: 130,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.insert_drive_file,
                      color: Colors.white,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      'Dokumen',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 130,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10)),
                ),
                child: IconButton(
                    icon: Icon(
                      Icons.file_download,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      /*  _downloadFile(
                            "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                                message["filepath"]);*/
                    }),
              ),
            ],
          );
        }
        break;

      case "Audio":
        {
          return VoiceMessagePlayer(
              url: "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                  message["filepath"]);
        }
        break;

      default:
        {
          return Text(
            message['context'],
            style: TextStyle(fontSize: 16, color: Colors.black),
          );
        }
        break;
    }
  }
}