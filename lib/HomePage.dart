import 'package:doktorsaya/page0.dart';
import 'package:doktorsaya/page1.dart';
import 'package:doktorsaya/page2.dart';
import 'package:doktorsaya/page3.dart';
import 'package:doktorsaya/page4.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<HomePage> {

  int _selectedIndex = 0;

  var _arrayTitle = [
    'Mesej',
    'Panggilan',
    'Doktor',
    'Hospital',
    'Info'
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _body = [
    Page0(),
    Page1(),
    Page2(),
    Page3(),
    Page4(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: IconButton(icon: Icon(Icons.menu),onPressed: () {}),

        title: Text(_arrayTitle[_selectedIndex]),

        actions: <Widget>[
          IconButton(icon: Icon(Icons.search),onPressed: (){})
        ],

      ),
      body: _body[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            title: Text(_arrayTitle[0]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            title: Text(_arrayTitle[1]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            title: Text(_arrayTitle[2]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            title: Text(_arrayTitle[3]),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            title: Text(_arrayTitle[4]),
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),

    );
  }
}
