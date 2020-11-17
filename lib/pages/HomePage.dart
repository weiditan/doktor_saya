import 'package:doktorsaya/pages/profile/DoctorPage.dart';
import 'package:doktorsaya/pages/message/MessageListPage.dart';
import 'package:doktorsaya/pages/profile/ProfilePage.dart';
import 'package:doktorsaya/pages/profile/SearchPage.dart';
import 'package:doktorsaya/pages/profile/ext/profileDatabase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'call/CallListPage.dart';
import 'call/ext/callDatabase.dart';
import 'profile/ext/doctorOnlineStatusDatabase.dart';
import '../functions/exitWithDoubleBack.dart';
import '../functions/sharedPreferences.dart' as sp;

class HomePage extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<HomePage> with WidgetsBindingObserver {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String _roleId;
  bool _showConfirmCallPage = false;
  bool _loop = true;
  int _selectedIndex = 2;
  var _arrayTitle = ['Mesej', 'Panggilan', 'Doktor', 'Profil'];

  List<Widget> _body = [
    MessageListPage(),
    CallListPage(),
    DoctorPage(),
    ProfilePage(),
  ];

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('$state');
    if (state == AppLifecycleState.paused) {
      print("stop loop");
      _loop = false;
      updateDoctorStatus(_roleId, "offline");
    }

    if (state == AppLifecycleState.resumed) {
      print("resumed loop");
      _loopFunction();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _init();
  }

  Future _init() async {
    updateToken();
    _firebaseMessagingFunction();
/*
    WidgetsFlutterBinding.ensureInitialized();
    await FlutterDownloader.initialize(
        debug: true // optional: set false to disable printing logs to console
    );
*/
    _roleId = await sp.getRoleId();
    _loopFunction();
  }

  Future _loopFunction() async {
    _loop = true;

    if (_roleId[0] == 'd') {
      int _noLoop = 0;
      while (_loop) {
        if (_noLoop % 20 == 0) {
          _updateOnlineStatus();
        }
        _checkCall();
        _noLoop++;
        await Future.delayed(Duration(seconds: 3));
      }
    }
  }

  Future _firebaseMessagingFunction() async {
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
  }

  Future _updateOnlineStatus() async {
    print("updateDoctorStatus " + DateTime.now().toString());
    await updateDoctorStatus(_roleId, "online");
  }

  Future _checkCall() async {
    print("checkCall " + DateTime.now().toString());
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
  }

  @override
  void dispose() {
    print('dispose+++');
    _loop = false;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //leading: IconButton(icon: Icon(Icons.menu),onPressed: () {}),

        title: Text(_arrayTitle[_selectedIndex]),

        actions: <Widget>[
          if (_selectedIndex == 2)
            IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchPage()),
                  );
                })
        ],
      ),
      body: WillPopScope(child: _body[_selectedIndex], onWillPop: onWillPop),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: _arrayTitle[0],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.call),
            label: _arrayTitle[1],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: _arrayTitle[2],
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: _arrayTitle[3],
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
