import 'dart:async';

import 'package:flutter/material.dart';

import 'bubble.dart';
import 'function/DatabaseConnect.dart' as db;
import 'widget/LoadingScreen.dart';
import 'widget/ProfileImage.dart';

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
    // TODO: implement initState
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
      await db
          .getMessage(widget.data['sender'], widget.data['receiver'])
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
    _scrollToEnd();
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
          showSmallIconProfileImage(widget.data['doctor_image']),
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
              (_arrayMessage[i]['sender'] == widget.data['sender'])
                  ? Bubble(
                      margin: BubbleEdges.only(top: 10),
                      nipRadius: 2,
                      alignment: Alignment.topRight,
                      nipWidth: 10,
                      nipHeight: 8,
                      nip: BubbleNip.rightTop,
                      color: Color.fromRGBO(225, 255, 199, 1.0),
                      child: Text(
                        _arrayMessage[i]['context'],
                        textAlign: TextAlign.right,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    )
                  : Bubble(
                      margin: BubbleEdges.only(top: 10),
                      nipRadius: 2,
                      alignment: Alignment.topLeft,
                      nipWidth: 20,
                      nipHeight: 8,
                      nip: BubbleNip.leftTop,
                      child: Text(
                        _arrayMessage[i]['context'],
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
          SizedBox(
            height: 60,
          ),
        ],
      ),
    );
  }

  Widget _messageBar() {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face,color: Colors.black),
                onPressed: () {
                  print(_scrollController);
                  _scrollToEnd();
                },
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextFormField(
                style: TextStyle(fontSize: 15.0,color: Colors.black, ),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                controller: _messageController,
                onTap: _scrollToEnd,
              ),
              color: Colors.white,
            ),
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send,color: Colors.black,),
                onPressed: () {
                  if (_messageController.text != "") {
                    db
                        .addTextMessage(widget.data['sender'],
                            widget.data['receiver'], _messageController.text)
                        .then((s) {
                      if (s['status']) {
                        db
                            .getMessage(
                                widget.data['sender'], widget.data['receiver'])
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
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
    );
  }

  Future _scrollToEnd() async {
    await Future.delayed(Duration(milliseconds: 300)).then((value) async {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          curve: Curves.easeOut,
          duration: const Duration(milliseconds: 100),
        );
      }
    });
  }
}
