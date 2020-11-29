import 'package:doktorsaya/functions/progressDialog.dart' as pr;
import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:doktorsaya/pages/account/ext/accountDatabase.dart';
import 'package:email_validator/email_validator.dart';
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
        onPressed: () {
          _showAddAdminDialog(setState);
        },
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
                onPressed: () {
                  _deleteAdmin(userId);
                },
              )
            : null,
      ),
    );
  }

  Future<void> _deleteAdmin(String userId) async {
    await pr.show(context, "Memuatkan");

    deleteUser(userId).timeout(new Duration(seconds: 15)).then((s) async {
      if (s['status']) {
        setState(() {});
        await pr.hide();
      } else {
        await pr.warning("Sila cuba lagi !");
        print(s);
      }
    }).catchError(
      (e) async {
        await pr.warning("Sila cuba lagi !");
        print(e);
      },
    );
  }

  Future<void> _showAddAdminDialog(StateSetter pageSetState) async {
    final _formKey = GlobalKey<FormState>();
    bool _obscureText = true;
    final _focus1 = FocusNode();
    final _focus2 = FocusNode();

    final _emailController = TextEditingController();
    final _password1Controller = TextEditingController();
    final _password2Controller = TextEditingController();

    Widget _emailField() {
      return TextFormField(
        style: TextStyle(
          fontSize: 12,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Email",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.emailAddress,
        obscureText: false,
        controller: _emailController,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_focus1);
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: (String value) {
          if (value.isNotEmpty) {
            return EmailValidator.validate(value)
                ? null
                : "Sila Masukkan Email Yang Betul";
          } else {
            return 'Sila Masukkan Email';
          }
        },
      );
    }

    void _toggle(StateSetter setState) {
      setState(() {
        _obscureText = !_obscureText;
      });
    }

    Widget _password1Field(StateSetter setState) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextFormField(
          style: TextStyle(
            fontSize: 12,
          ),
          decoration: new InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Kata Laluan",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
              ),
              onPressed: () {
                _toggle(setState);
              },
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: _obscureText,
          controller: _password1Controller,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textInputAction: TextInputAction.next,
          onFieldSubmitted: (_) {
            FocusScope.of(context).requestFocus(_focus2);
          },
          focusNode: _focus1,
          validator: (String value) {
            if (value.isNotEmpty && value.length < 8) {
              return 'Kata Laluan Tidak Boleh Kurang Daripada 8 Perkataan';
            } else if (value.isEmpty) {
              return 'Sila Masukkan Kata Laluan';
            }
            return null;
          },
        ),
      );
    }

    Widget _password2Field(StateSetter setState) {
      return Padding(
        padding: EdgeInsets.only(top: 10),
        child: TextFormField(
          style: TextStyle(
            fontSize: 12,
          ),
          decoration: new InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Ulang Kata Laluan",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
              ),
              onPressed: () {
                _toggle(setState);
              },
            ),
          ),
          keyboardType: TextInputType.text,
          obscureText: _obscureText,
          controller: _password2Controller,
          focusNode: _focus2,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (String value) {
            if (value.isNotEmpty && value != _password1Controller.text) {
              return 'Kata Laluan Tidak Sama';
            } else if (value.isEmpty) {
              return 'Sila Masukkan Kata Laluan';
            }
            return null;
          },
        ),
      );
    }

    Future<void> _addAdmin(String email, String password) async {
      await pr.show(context, "Memuatkan");

      registerAccount(email, password, "admin")
          .timeout(new Duration(seconds: 15))
          .then((s) async {
        if (s["status"]) {
          await pr.success("Admin telah berjaya didaftarkan.");
          Navigator.of(context).pop();
          pageSetState(() {});
        } else {
          await pr.error(s["data"]);
        }
      }).catchError((e) async {
        await pr.warning("Sila cuba lagi !");
        print(e);
      });
    }

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Tambah Admin'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Form(
                  key: _formKey,
                  child: ListBody(
                    children: <Widget>[
                      _emailField(),
                      _password1Field(setState),
                      _password2Field(setState),
                    ],
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Tambah'),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _addAdmin(_emailController.text, _password1Controller.text);
                }
              },
            ),
          ],
        );
      },
    );
  }
}
