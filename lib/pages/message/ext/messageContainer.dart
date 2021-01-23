import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:doktorsaya/functions/viewImage.dart';
import 'package:doktorsaya/functions/viewVideo.dart';
import 'package:doktorsaya/pages/message/ext/voiceMessagePlayer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';

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
            return (snapshot.data != null)
                ? _messageList(snapshot.data)
                : Container();
          // return _secondScreen(snapshot.data);
          //return Text('active: ${snapshot.data}');
          case ConnectionState.done:
            return Text('Stream已关闭');
        }
        return null; // unreachable
      },
    );
  }

  Widget _messageList(_arrayMessage) {
    return StickyGroupedListView<dynamic, String>(
      elements: _arrayMessage,
      groupBy: (dynamic element) => _groupDate(element['sendtime']),
      groupSeparatorBuilder: (dynamic element) => Container(
        height: 50,
        child: Align(
          alignment: Alignment.center,
          child: Container(
            width: 120,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              border: Border.all(
                color: Colors.grey[300],
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                (_date(element['sendtime']) ==
                        DateFormat('MMM d, yyyy').format(DateTime.now()))
                    ? "Hari Ini"
                    : _date(element['sendtime']),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ),
      ),
      itemBuilder: (context, dynamic element) => _message(element),
      itemComparator: (element1, element2) =>
          element1['sendtime'].compareTo(element2['sendtime']), // optional
      itemScrollController: GroupedItemScrollController(), // optional
      order: StickyGroupedListOrder.DESC,
      floatingHeader: true,
      physics: BouncingScrollPhysics(),
      reverse: true, // optional
      padding: EdgeInsets.only(bottom: 60),
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

  String _groupDate(sendTime) {
    Duration _timeZone = DateTime.now().timeZoneOffset;
    DateTime _sendTime = DateTime.parse(sendTime).add(_timeZone);

    return DateFormat('yyyy-MM-dd').format(_sendTime);
  }

  String _date(sendTime) {
    Duration _timeZone = DateTime.now().timeZoneOffset;
    DateTime _sendTime = DateTime.parse(sendTime).add(_timeZone);

    return DateFormat('MMM d, yyyy').format(_sendTime);
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
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ViewVideo(
                      message['context'],
                      "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                          message["filepath"]),
                ),
              );
            },
            child: Container(
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.videocam,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        message['context'],
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        }
        break;

      case "Dokumen":
        {
          return GestureDetector(
            onTap: () {
              _download(
                  "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" +
                      message["filepath"],
                  message['context']);
            },
            child: Container(
              color: Colors.grey[300],
              child: Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.file_download,
                      //Icons.insert_drive_file,
                      color: Colors.orange,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      child: Text(
                        message['context'],
                        style: TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );

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

  final Dio _dio = Dio();

  Future<void> _download(url, fileName) async {
    Directory appDocDirectory;
    if (Platform.isIOS) {
      appDocDirectory = await getApplicationDocumentsDirectory();
    } else {
      appDocDirectory = await getExternalStorageDirectory();
    }

    String _savePath = appDocDirectory.path + "/" + fileName;

    print(_savePath);

    await _dio.download(url, _savePath, onReceiveProgress: _onReceiveProgress);
  }

  void _onReceiveProgress(int received, int total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }
}
