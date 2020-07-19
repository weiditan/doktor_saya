import 'package:flutter/material.dart';

import 'bubble.dart';

class Message extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Message"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Bubble(
            margin: BubbleEdges.only(top: 10),
            nipRadius: 4,
            alignment: Alignment.topRight,
            nipWidth: 30,
            nipHeight: 10,
            nip: BubbleNip.rightTop,
            color: Color.fromRGBO(225, 255, 199, 1.0),
            child: Text(
              'Selamat pagi, Doktor!',
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 16),
            ),
          ),
          Bubble(
            margin: BubbleEdges.only(top: 10),
            nipRadius: 4,
            alignment: Alignment.topLeft,
            nipWidth: 30,
            nipHeight: 10,
            nip: BubbleNip.leftTop,
            child: Text(
              'Selamat pagi',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      bottomSheet: _messageBar(context),
    );
  }

  Widget _messageBar(context) {
    return Container(
      child: Row(
        children: <Widget>[
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 1.0),
              child: new IconButton(
                icon: new Icon(Icons.face),
                onPressed: () {},
                //  color: Palette.primaryColor,
              ),
            ),
            color: Colors.white,
          ),

          // Text input
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(fontSize: 15.0),
                //controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),

          // Send Message Button
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => {},
                //  color: Palette.primaryColor,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: Colors.grey, width: 0.5)),
          color: Colors.white),
    );
  }
}
