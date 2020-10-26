import 'package:flutter/material.dart';

import 'bubble.dart';
import 'function/DatabaseConnect.dart' as db;

class Page123 extends StatefulWidget {
  final Map data;
  Page123(this.data);

  @override
  _Page123State createState() => _Page123State();
}

class _Page123State extends State<Page123> {
  List _arrayMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    await db
        .getMessage(widget.data['sender'], widget.data['receiver'])
        .then((onValue) {
      setState(() {
        _arrayMessage = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _body(),
      bottomSheet: _messageBar(),
    );
  }

  Widget _body() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: ListView(
        // controller: _scrollController,
        physics: BouncingScrollPhysics(),
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
                icon: new Icon(Icons.face),
                onPressed: () {},
              ),
            ),
            color: Colors.white,
          ),
          Flexible(
            child: Container(
              child: TextFormField(
                style: TextStyle(fontSize: 15.0),
                decoration: InputDecoration.collapsed(
                  hintText: 'Type a message',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => {},
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
}
