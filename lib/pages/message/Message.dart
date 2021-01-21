import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:doktorsaya/functions/viewImage.dart';
import 'package:doktorsaya/functions/viewVideo.dart';
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
  List _arrayMessage = [];
  Timer _t;
  final _messageController = TextEditingController();

  _getData() async {

    _arrayMessage =
        await getMessage(widget.data['sender'], widget.data['receiver']);

    setState(() {});

    List _data;
    _t = Timer.periodic(Duration(seconds: 5), (Timer timer) async {
      _data = await getMessage(widget.data['sender'], widget.data['receiver']);
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
    _t.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: _title()),
      body: _secondScreen(_arrayMessage),
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
      child: _messageDetail(message),
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
          AudioPlayer _player = AudioPlayer();
          String _playingFile = "";
          Duration _duration = new Duration();
          Duration _position = new Duration();

          _play(url) async {
            await _player.play(url);
            _playingFile = url;

            print(_player.state);
          }

          _pause() async {
            await _player.pause();
          }


          Widget _icon(filepath) {
            String _fullFilepath =
                "http://www.breakvoid.com/DoktorSaya/Files/Attachments/" + filepath;

            if (_playingFile == _fullFilepath &&
                _player.state == AudioPlayerState.PLAYING) {
              return IconButton(
                icon: Icon(
                  Icons.pause,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  _pause();
                },
              );
            } else {
              return IconButton(
                icon: Icon(
                  Icons.play_arrow,
                  color: Colors.grey[600],
                ),
                onPressed: () {
                  _play(_fullFilepath);
                },
              );
            }
          }

          _player.onDurationChanged.listen((Duration d) {
            print('Max duration: $d');
            setState(() {
              _duration = d;
            });
          });

          _player.onAudioPositionChanged.listen((Duration  p) {
            print('Current position: $p');
            setState(() => _position = p);
          });

          return Row(
            children: [
              _icon(message["filepath"]),
              Slider(
                value: _position.inSeconds.toDouble(),
                min: 0.0,
                max: _duration.inSeconds.toDouble(),
                onChanged: (double value) {},
              ),
            ],
          );
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
              showRecordAudioBottomSheet(
                  context, widget.data['sender'], widget.data['receiver']);
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
              showAttachmentBottomSheet(
                  context, widget.data['sender'], widget.data['receiver']);
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
                    getMessage(widget.data['sender'], widget.data['receiver'])
                        .then((onValue) {
                      setState(() {
                        //_arrayMessage = onValue;
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
    );
  }

/*
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
*/
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
