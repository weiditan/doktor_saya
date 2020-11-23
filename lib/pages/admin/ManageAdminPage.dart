import 'package:flutter/material.dart';

import 'navDrawer.dart';

class ManageAdminPage extends StatefulWidget {
  @override
  _ManageAdminPageState createState() => _ManageAdminPageState();
}

class _ManageAdminPageState extends State<ManageAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Menguruskan Admin'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.search), onPressed: () {})
        ],

      ),
    );
  }
}
