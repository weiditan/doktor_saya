import 'package:flutter/material.dart';

import 'bubble.dart';

class Page0 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          for (var i = 0; i <= 5; i++)
            Bubble(
              margin: BubbleEdges.only(top: 10),
              nipRadius: 4,
              alignment: Alignment.topRight,
              nipWidth: 30,
              nipHeight: 10,
              nip: BubbleNip.rightTop,
              color: Color.fromRGBO(225, 255, 199, 1.0),
              child: Text('Hello, World!', textAlign: TextAlign.right),
            ),
            Bubble(
              margin: BubbleEdges.only(top: 10),
              nipRadius: 4,
              alignment: Alignment.topLeft,
              nipWidth: 30,
              nipHeight: 10,
              nip: BubbleNip.leftTop,
              child: Text('Hi, developer!/nasdad\nasd'),
            ),
        ],
      ),
    );
  }
}
