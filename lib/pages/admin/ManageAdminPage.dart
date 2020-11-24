import 'package:doktorsaya/functions/progressDialog.dart' as pr;
import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:doktorsaya/pages/account/ext/accountDatabase.dart';
import 'package:flutter/material.dart';

import 'navDrawer.dart';

class ManageAdminPage extends StatefulWidget {
  @override
  _ManageAdminPageState createState() => _ManageAdminPageState();
}

class _ManageAdminPageState extends State<ManageAdminPage> {
  String _email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title: Text('Menguruskan Admin'),
      ),
      body: (_email != null)
          ? FutureBuilder<List>(
              future: getAllAdmin(_email),
              builder: (context, snapshot) {
                return _list(snapshot, _email);
              })
          : FutureBuilder<String>(
              future: getEmail(),
              builder: (context, snapshotEmail) {
                if (snapshotEmail.hasData) {
                  _email = snapshotEmail.data;
                  return FutureBuilder<List>(
                      future: getAllAdmin(_email),
                      builder: (context, snapshot) {
                        return _list(snapshot, _email);
                      });
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _showAddAdminDialog,
      ),
    );
  }

  Widget _list(AsyncSnapshot snapshot, String email) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 80),
      physics: BouncingScrollPhysics(),
      itemCount: (snapshot.hasData) ? snapshot.data.length + 1 : 2,
      itemBuilder: (context, position) {
        return (position == 0)
            ? _cardAdmin("", email, "Saya", false)
            : (snapshot.hasData)
                ? _cardAdmin(snapshot.data[position - 1]['user_id'],
                    snapshot.data[position - 1]['email'], "", true)
                : (snapshot.hasError)
                    ? Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: Text(
                            "Sila cuba lagi !",
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.all(15),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
      },
    );
  }

  Widget _cardAdmin(
      String userId, String title, String subTitle, bool deleteButton) {
    return Card(
      child: ListTile(
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            subTitle,
            style: TextStyle(fontSize: 16, fontFamily: "Montserrat"),
          ),
        ),
        trailing: (deleteButton)
            ? IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                  size: 30,
                ),
                onPressed: () async {},
              )
            : null,
      ),
    );
  }

  Future<void> _showAddAdminDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Admin'),
          content: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: ListBody(
              children: <Widget>[
                Text('Email'),
                Text('This is a demo alert dialog.'),
                Text('Password'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tambah'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _addAdmin(String email, String password) async {
    await pr.show(context, "Memuatkan");

    registerAccount(email, password, "admin")
        .timeout(new Duration(seconds: 15))
        .then((s) async {
      if (s["status"]) {
        await pr.success("Admin telah berjaya didaftarkan.");
        setState(() {});
      } else {
        await pr.error(s["data"]);
      }
    }).catchError((e) async {
      await pr.warning("Sila cuba lagi !");
      print(e);
    });
  }
}
