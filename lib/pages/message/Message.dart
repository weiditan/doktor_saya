import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:doktorsaya/functions/viewImage.dart';
import 'package:doktorsaya/functions/viewVideo.dart';
import 'package:flutter/material.dart';

import 'package:doktorsaya/pages/message/bubble.dart';
import 'package:doktorsaya/functions/loadingScreen.dart';
import 'package:doktorsaya/pages/profile/ext/profileImage.dart';

import 'ext/attachment.dart';
import 'ext/messageDatabase.dart';

class Message extends StatefulWidget {
  @override
  _MessageState createState() => _MessageState();

  final Map data;
  Message(this.data);
}

class _MessageState extends State<Message> {
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;
  bool _loop = true;
  List _arrayMessage;
  final _messageController = TextEditingController();
  final _scrollController = new ScrollController();

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  void dispose() {
    super.dispose();
    _loop = false;
  }

  Future _getData() async {

    while (_loop) {
      await getMessage(widget.data['sender'], widget.data['receiver'])
          .then((onValue) {
        if (_arrayMessage == null) {
          setState(() {
            _arrayMessage = onValue;
            _hideLoadingScreen();
          });
        } else if (_arrayMessage.length != onValue.length) {
          setState(() {
            _arrayMessage = onValue;
          });
        }
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToEnd();
    });

    return Scaffold(
      appBar: AppBar(title: _title()),
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

  Widget _secondScreen() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        controller: _scrollController,
        children: <Widget>[
          if (_arrayMessage != null)
            for (int i = 0; i < _arrayMessage.length; i++)
              _message(_arrayMessage[i]),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget _message(Map message) {
    switch (message['type']) {
      case "Gambar":
        {
          return Bubble(
            margin: (message['sender'] == widget.data['sender'])
                ? BubbleEdges.only(top: 10, left: 50)
                : BubbleEdges.only(top: 10, right: 50),
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
            child: InkWell(
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
                  child: CircularProgressIndicator(
                      value: downloadProgress.progress),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          );
        }
        break;

      case "Video":
        {
          return Bubble(
            margin: (message['sender'] == widget.data['sender'])
                ? BubbleEdges.only(top: 10, left: 50)
                : BubbleEdges.only(top: 10, right: 50),
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
            child: Column(
              children: <Widget>[
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
            ),
          );
        }
        break;

      case "Dokumen":
        {
          return Bubble(
            margin: (message['sender'] == widget.data['sender'])
                ? BubbleEdges.only(top: 10, left: 50)
                : BubbleEdges.only(top: 10, right: 50),
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
            child: Column(
              children: <Widget>[
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
            ),
          );
        }
        break;

      default:
        {
          return Bubble(
            margin: (message['sender'] == widget.data['sender'])
                ? BubbleEdges.only(top: 10, left: 50)
                : BubbleEdges.only(top: 10, right: 50),
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
            child: Text(
              message['context'],
              textAlign: (message['sender'] == widget.data['sender'])
                  ? TextAlign.right
                  : TextAlign.left,
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
          );
        }
        break;
    }
  }

  Widget _messageBar() {
    return Container(
      color: Colors.white,
      child: Row(
        children: <Widget>[
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
                onTap: _scrollToEnd,
              ),
              color: Colors.white,
            ),
          ),
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.attach_file,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      showAttachmentBottomSheet(context, widget.data['sender'],
                          widget.data['receiver']);
                    },
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      if (_messageController.text != "") {
                        addTextMessage(
                                widget.data['sender'],
                                widget.data['receiver'],
                                _messageController.text)
                            .then((s) {
                          if (s['status']) {
                            getMessage(widget.data['sender'],
                                    widget.data['receiver'])
                                .then((onValue) {
                              setState(() {
                                _arrayMessage = onValue;
                                _messageController.text = "";
                              });
                            });
                          }
                        });
                      }
                    },
                  ),
                ],
              ),
              color: Colors.white,
            ),
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
    );
  }

  Future _scrollToEnd() async {
    await Future.delayed(Duration(milliseconds: 500)).then((value) async {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 100),
        );
      }
    });
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
