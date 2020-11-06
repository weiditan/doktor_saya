import 'package:doktorsaya/pages/profile/DoctorPage.dart';
import 'package:doktorsaya/pages/message/MessageListPage.dart';
import 'package:doktorsaya/pages/profile/ProfilePage.dart';
import 'package:doktorsaya/pages/profile/ext/profileDatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_mac/get_mac.dart';
import 'package:flutter/services.dart';

import 'call/CallListPage.dart';
import 'call/ext/callDatabase.dart';
import 'profile/ext/doctorOnlineStatusDatabase.dart';
import '../functions/exitWithDoubleBack.dart';
import '../functions/sharedPreferences.dart' as sp;

class HomePage extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<HomePage> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  String _role, _roleId;
  int _selectedIndex = 2;
  var _arrayTitle = ['Mesej', 'Panggilan', 'Doktor', 'Profil'];

  List<Widget> _body = [
    MessageListPage(),
    CallListPage(),
    DoctorPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();

    _getMac().then((onValue){
      if(onValue!="Error"){
        print(onValue);
      }
    });

    updateToken();

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
        /* final notification = message['notification'];
        setState(() {
          messages.add(Message(
            title: notification['title'],
            body: notification['body'],
          ));
        });*/
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        Navigator.popUntil(context, ModalRoute.withName('/HomePage'));
        setState(() {
          _selectedIndex = 0;
        });
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));

    _updateOnlineStatus().then((_) {
      _checkCall();
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<String> _getMac() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await GetMac.macAddress;
      return platformVersion;
    } on PlatformException {
      print('Failed to get Device MAC Address.');
      return "Error";
    }
  }

  Future _updateOnlineStatus() async {
    _role = await sp.getRole();

    if (_role == 'doctor') {
      _roleId = await sp.getRoleId();

      await updateDoctorStatus(_roleId, "online");
    }
  }

  Future _checkCall() async {
    bool _showConfirmCallPage = false;

    if (_role == 'doctor') {
      while (true) {
        await checkCall(_roleId).then((s) {
          if (s['status'] == true) {
            if (_showConfirmCallPage == false) {
              _showConfirmCallPage = true;
              Navigator.pushNamed(context, '/ConfirmCallPage', arguments: s);
            }
          } else {
            _showConfirmCallPage = false;
          }
        });
        await Future.delayed(Duration(seconds: 3));
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
