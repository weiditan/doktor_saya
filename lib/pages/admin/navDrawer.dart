import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:doktorsaya/pages/account/ext/logout.dart';
import 'package:flutter/material.dart';

import 'ManageAdminPage.dart';
import 'ManageDoctorPage.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('ADMIN'),
            accountEmail: FutureBuilder<String>(
                future: getEmail(),
                builder: (context, AsyncSnapshot<String> snapshot) {
                  if (snapshot.hasData) {
                    return Text(snapshot.data);
                  } else {
                    return Text('');
                  }
                }),
            currentAccountPicture: CircleAvatar(
              backgroundImage: AssetImage('assets/logo.png'),
            ),
          ),
          ListTile(
            leading: Icon(Icons.border_color),
            title: Text('Menguruskan Doktor'),
            onTap: () => { Navigator.of(context).pop(),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ManageDoctorPage())),
            },
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Menguruskan Admin'),
            onTap: () => {
              Navigator.of(context).pop(),
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => ManageAdminPage())),
            },
          ),
          ListTile(
            leading: Icon(Icons.verified_user),
            title: Text('Tukar Kata Laluan'),
            onTap: () =>
                {Navigator.popAndPushNamed(context, '/ChangePasswordPage')},
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Log Keluar'),
            onTap: () => {logout(context)},
          ),
        ],
      ),
    );
  }
}
