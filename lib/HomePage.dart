import 'package:doktorsaya/DoctorPage.dart';
import 'package:doktorsaya/EditDoctorPage.dart';
import 'package:doktorsaya/EditProfilePage.dart';
import 'package:doktorsaya/page.dart';
import 'package:doktorsaya/page0.dart';
import 'package:doktorsaya/page1.dart';
import 'package:doktorsaya/page2.dart';
import 'package:doktorsaya/page3.dart';
import 'package:doktorsaya/ProfilePage.dart';
import 'package:flutter/material.dart';

import 'function/ExitWithDoubleBack.dart';

class HomePage extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<HomePage> {
  int _selectedIndex = 2;

  var _arrayTitle = ['Mesej', 'Panggilan', 'Doktor', 'Profil'];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _body = [
Page123({
  'sender': 'd8',
  'receiver': 'd10',
  'doctor_name': 'doctorName',
  'doctor_image': 'doctorImage'
}),
    Page0(),
    DoctorPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: IconButton(icon: Icon(Icons.menu),onPressed: () {}),

        title: Text(_arrayTitle[_selectedIndex]),

        actions: <Widget>[
          //IconButton(icon: Icon(Icons.search),onPressed: (){})
        ],
      ),
      body: WillPopScope(child: _body[_selectedIndex], onWillPop: onWillPop),
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
            icon: Icon(Icons.info),
            title: Text(_arrayTitle[3]),
          ),
        ],
        currentIndex: _selectedIndex,
        //selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}
