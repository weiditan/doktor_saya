import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doktorsaya/functions/viewImage.dart';
import 'package:doktorsaya/functions/viewVideo.dart';
import 'package:doktorsaya/pages/message/ext/voiceMessagePlayer.dart';
import 'package:flutter/material.dart';

import 'ext/bubble.dart';
import 'package:doktorsaya/pages/profile/ext/profileImage.dart';

import 'ext/attachment.dart';
import 'ext/messageDatabase.dart';
import 'ext/recordAudio.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();

  final Map data;
  Message(this.data);
}

class _MessageState extends State<Message> {
  final _messageController = TextEditingController();

  Stream<List> _getData() async* {
    while (true) {
      yield await getMessage(widget.data['sender'], widget.data['receiver']);
      await Future.delayed(Duration(seconds: 5));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
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
      bottomSheet: _messageBar(),
    );
  }

  Widget _title() {
    return Container(
      child: Row(
        children: <Widget>[
          showSmallIconProfileImage(
              widget.data['doctor_image'], widget.data['doctor_online']),
          SizedBox(width: 10),
          Flexible(
            child: Container(child: Text(widget.data['doctor_name'])),
          ),
          SizedBox(width: 10),
        ],
      ),
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
        _deleteMenu(message["message_id"], details.globalPosition.dx,
            details.globalPosition.dy);
      },
      child: Bubble(
        margin: (message['sender'] == widget.data['sender'])
            ? BubbleEdges.only(top: 5, left: 50, bottom: 5)
            : BubbleEdges.only(top: 5, right: 50, bottom: 5),
        nipRadius: 2,
        alignment: (message['sender'] == widget.data['sender'])
            ? Alignment.topRight
            : Alignment.topLeft,
        nipWidth: 10,
        nipHeight: 8,
        nip: (message['sender'] == widget.data['sender'])
            ? BubbleNip.rightTop
            : BubbleNip.leftTop,
        color: (message['sender'] == widget.data['sender'])
            ? Color.fromRGBO(225, 255, 199, 1.0)
            : Colors.white,
        child: _messageDetail(message),
      ),
    );
  }

  Future _deleteMenu(messageId, positionX, positionY) async {
    int selected = await showMenu(
      items: [
        PopupMenuItem(
          value: 0,
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
      deleteMessage(messageId).then((s) {
        if (s['status']) {
          setState(() {});
        }
      });
    }
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
                textAlign: (message['sender'] == widget.data['sender'])
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
                textAlign: (message['sender'] == widget.data['sender'])
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
            textAlign: (message['sender'] == widget.data['sender'])
                ? TextAlign.right
                : TextAlign.left,
            style: TextStyle(fontSize: 16, color: Colors.black),
          );
        }
        break;
    }
  }

  Widget _messageBar() {
    return Container(
      height: 51.5,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: Colors.grey[300], width: 1.5),
        ),
        color: Colors.white,
      ),
      child: Row(
        children: <Widget>[
          IconButton(
            icon: Icon(
              Icons.mic,
              color: Colors.black,
            ),
            onPressed: () {
              showRecordAudioBottomSheet(context, widget.data['sender'],
                  widget.data['receiver'], setState);
            },
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: TextFormField(
                style: TextStyle(
                  fontSize: 15.0,
                  color: Colors.black,
                ),
                decoration: InputDecoration.collapsed(
                  hintText: 'Tulis mesej',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                controller: _messageController,
                //onTap: _scrollToEnd,
              ),
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.attach_file,
              color: Colors.black,
            ),
            onPressed: () {
              showAttachmentBottomSheet(context, widget.data['sender'],
                  widget.data['receiver'], setState);
            },
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: Colors.black,
            ),
            onPressed: () {
              if (_messageController.text != "") {
                addTextMessage(widget.data['sender'], widget.data['receiver'],
                        _messageController.text)
                    .then((s) {
                  if (s['status']) {
                    setState(() {
                      _messageController.text = "";
                    });
                  }
                });
              }
            },
          ),
        ],
      ),
    );
  }

  /*Future _downloadFile(String fileUrl) async {
    final Directory downloadsDirectory =
        await DownloadsPathProvider.downloadsDirectory;
    final String downloadsPath = downloadsDirectory.path;
    await FlutterDownloader.enqueue(
      url: fileUrl,
      savedDir: downloadsPath,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
  }*/
}
