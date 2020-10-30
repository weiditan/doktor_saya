import 'package:doktorsaya/DoctorPage.dart';
import 'package:doktorsaya/pages/message/MessagePage.dart';
import 'package:doktorsaya/ProfilePage.dart';
import 'package:flutter/material.dart';

import 'databases/CallDatabase.dart';
import 'pages/call/ConfirmCallPage.dart';
import 'databases/OnlineStatusDatabase.dart';
import 'functions/ExitWithDoubleBack.dart';
import 'functions/SharedPreferences.dart' as sp;


class HomePage extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<HomePage> {
  String _role, _roleId;
  int _selectedIndex = 2;
  var _arrayTitle = ['Mesej', 'Panggilan', 'Doktor', 'Profil'];

  List<Widget> _body = [
    MessagePage(),
    ConfirmCall(),
    DoctorPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _updateOnlineStatus().then((_){
      _checkCall();
    });
  }

  Future _updateOnlineStatus() async {
    _role = await sp.getRole();

    if (_role == 'doctor') {
      _roleId = await sp.getRoleId();

      await updateDoctorStatus(_roleId, "online");
    }
  }

  Future _checkCall() async {
    if (_role == 'doctor') {
      while(true){
        await checkCall(_roleId).then((onValue){
          print(onValue);
        });
        await Future.delayed(Duration(seconds: 5));
      }
    }
  }

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

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
