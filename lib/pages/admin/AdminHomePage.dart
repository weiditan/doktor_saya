import 'package:doktorsaya/pages/account/ext/logout.dart';
import 'package:flutter/material.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  int _selectedIndex = 0;

  List _arrayTitle = ['Doktor Diluluskan', 'Doktor Belum Diluluskan', 'Profil'];
  List _arrayIcon = [Icons.group, Icons.group, Icons.info];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Doktor'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
          bottom: TabBar(
            tabs: [
              Tab(text: "Doktor Diluluskan"),
              Tab(text: "Belum Diluluskan"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Center(child: Text("Page 1")),
            Center(child: Text("Page 2")),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
