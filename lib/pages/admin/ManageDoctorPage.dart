import 'package:doktorsaya/pages/profile/DoctorPage.dart';
import 'package:flutter/material.dart';

import 'navDrawer.dart';

class ManageDoctorPage extends StatefulWidget {
  @override
  _ManageDoctorPageState createState() => _ManageDoctorPageState();
}

class _ManageDoctorPageState extends State<ManageDoctorPage> {

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
          title: Text('Menguruskan Doktor'),
          actions: <Widget>[
            IconButton(icon: Icon(Icons.search), onPressed: () {})
          ],
          bottom: TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "Belum\nDiluluskan"),
              Tab(text: "Diluluskan"),
              Tab(text: "Tidak\nDiluluskan"),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            DoctorPage(requestStatus: "1",),
            DoctorPage(requestStatus: "2",),
            DoctorPage(requestStatus: "3",),
          ],
        ),
      ),
    );
  }
}
