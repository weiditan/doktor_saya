import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          for (var i = 0; i < 20; i++)
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(padding: EdgeInsets.all(10), child: Text(i.toString())),

                Padding(
                    padding: EdgeInsets.all(10),
                    child: Text("qwe" + i.toString()))
              ],
            )
        ],
      ),
    );
  }


}
