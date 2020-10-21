import 'package:flutter/material.dart';

import 'function/ProgressDialog.dart' as pr;
import 'function/SharedPreferences.dart' as sp;
import 'function/Text.dart' as tx;
import 'function/DatabaseConnect.dart' as db;
import 'LoadingScreen.dart' as ls;

class EditDoctorPage extends StatefulWidget {
  @override
  _EditDoctorPageState createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;

  double _screenWidth;

  String _roleId;
  List _arraySpecialist;
  List _arrayState;
  List _arrayDoctorSpecialist;

  int _valueCountry;
  int _valueState;
  final _workplaceController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getData().then((onValue) {
      setState(() {
        _hideLoadingScreen();
      });
    });
  }

  Future _getData() async {
    _roleId = await sp.getRoleId();

    await Future.wait([
      db.getSpecialist().then((onValue) {
        _arraySpecialist = onValue;
      }),
      db.getDoctorSpecialist(_roleId).then((onValue) {
        _arrayDoctorSpecialist = onValue;
      }),
      db.getState().then((onValue) {
        _arrayState = onValue;
      }),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: AnimatedCrossFade(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        crossFadeState: _loadingVisible
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstCurve: Curves.easeOut,
        secondCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        firstChild: ls.loadingScreen(_loadingIconVisible),
        secondChild: _secondScreen(),
      ),
    );
  }

  Future _hideLoadingScreen() async {
    setState(() {
      _loadingIconVisible = false;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _loadingVisible = false;
    });
  }

  Widget _secondScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          tx.heading1("PAKAR DOKTOR"),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(
              children: <Widget>[
                if (_arrayDoctorSpecialist != null)
                  for (int i = 0; i < _arrayDoctorSpecialist.length; i++)
                    _cardSpecialist(
                        _arrayDoctorSpecialist[i]['doctor_spec_id'],
                        _arrayDoctorSpecialist[i]['specialist_id'],
                        _arrayDoctorSpecialist[i]['sub_specialist']),
                Card(
                  child: InkWell(
                    onTap: () {
                      _showAddSpecialistDialog().then((_) {
                        db.getDoctorSpecialist(_roleId).then((onValue) {
                          setState(() {
                            _arrayDoctorSpecialist = onValue;
                          });
                        });
                      });
                    },
                    child: ListTile(
                      leading: Icon(
                        Icons.add_circle,
                        color: Colors.orange,
                        size: 30,
                      ),
                      title: Text(
                        "Tambah Pakar",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          tx.heading1("TEMPAT KERJA"),
          _workplaceField(),
          Wrap(
            children: <Widget>[
              _selectCountry(),
              if (_arrayState != null && _valueCountry == 0) _selectState(),
            ],
          ),
          if (_valueCountry == 1) _countryField(),
          if (_valueCountry == 1) _stateField(),
          Divider(
            thickness: 1,
          ),
          tx.heading1("PENGALAMAN"),
          tx.heading2("Hospital Melaka Eye Specialist Clinic"),
          tx.heading3("2 tahun"),
          tx.heading2("The Tun Hussein Onn National Eye Hospital"),
          tx.heading3("3 tahun 8 bulan"),
          Divider(
            thickness: 1,
          ),
          _submitButton(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _cardSpecialist(
      String doctorSpecialistId, String title, String subtitle) {
    return Card(
      child: ListTile(
        title: Text(
          _selectedSpecialist(title),
          style: TextStyle(
            fontSize: 18,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            subtitle,
            style: TextStyle(fontSize: 16, fontFamily: "Montserrat"),
          ),
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.red,
            size: 30,
          ),
          onPressed: () async {
            await pr.show(context, "Memuatkan");
            db
                .deleteDoctorSpecialist(doctorSpecialistId)
                .timeout(new Duration(seconds: 15))
                .then((s) async {
              if (s['status']) {
                db.getDoctorSpecialist(_roleId).then((onValue) async {
                  setState(() {
                    _arrayDoctorSpecialist = onValue;
                  });
                  await pr.hide();
                });
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
          },
        ),
      ),
    );
  }

  String _selectedSpecialist(String specialistId) {
    String data = "";
    if (_arraySpecialist != null) {
      _arraySpecialist.forEach((item) {
        if (item['specialist_id'] == specialistId) {
          data = item['malay'];
        }
      });
    }
    return data;
  }

  Future _showAddSpecialistDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final _specialistFormKey = GlobalKey<FormState>();
        int _valueSpecialist;
        final _subSpecialistController = TextEditingController();

        return AlertDialog(
          title: new Text("Tambar Pakar"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: _screenWidth,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _specialistFormKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        if (_arraySpecialist != null)
                          SizedBox(
                            width: 150,
                            child: DropdownButtonFormField(
                              decoration: new InputDecoration(
                                contentPadding:
                                    const EdgeInsets.only(left: 10, bottom: 10),
                                border: OutlineInputBorder(),
                                labelText: "Jenis Pakar",
                                labelStyle: TextStyle(
                                  fontFamily: "Montserrat",
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              items: [
                                for (int i = 0;
                                    i < _arraySpecialist.length;
                                    i++)
                                  DropdownMenuItem<int>(
                                    child: Text(_arraySpecialist[i]['malay']),
                                    value: int.parse(
                                        _arraySpecialist[i]['specialist_id']),
                                  ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _valueSpecialist = value;
                                });
                              },
                              value: _valueSpecialist,
                              validator: (value) {
                                if (value == null) {
                                  return 'Sila pilih pakar.';
                                }
                                return null;
                              },
                            ),
                          ),
                        SizedBox(height: 10),
                        TextFormField(
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          decoration: new InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: "Nama Pakar",
                            labelStyle: TextStyle(
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          keyboardType: TextInputType.text,
                          controller: _subSpecialistController,
                          validator: (String value) {
                            if (_valueSpecialist != 1) {
                              if (value.isEmpty) {
                                return 'Sila masukkan nama pakar.';
                              }
                            }

                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Tambah'),
              onPressed: () async {
                if (_specialistFormKey.currentState.validate()) {
                  await pr.show(context, "Memuatkan");

                  db
                      .addDoctorSpecialist(_roleId, _valueSpecialist,
                          _subSpecialistController.text)
                      .timeout(new Duration(seconds: 15))
                      .then((s) async {
                    if (s['status']) {
                      Navigator.pop(context);
                      await pr.hide();
                    } else {
                      await pr.hide();
                      print(s);
                    }
                  }).catchError(
                    (e) async {
                      await pr.hide();
                      print(e);
                    },
                  );
                }
              },
            )
          ],
        );
      },
    );
  }

  Widget _workplaceField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Tempat Kerja",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
        controller: _workplaceController,
      ),
    );
  }

  Widget _countryField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Negara",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
        controller: _countryController,
      ),
    );
  }

  Widget _stateField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: "Negeri",
          labelStyle: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.done,
        controller: _stateController,
      ),
    );
  }

  Widget _selectCountry() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: SizedBox(
        width: 160,
        child: DropdownButtonFormField(
          decoration: new InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
            border: OutlineInputBorder(),
            labelText: "Negara",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          items: [
            DropdownMenuItem<int>(
              child: Text("Malaysia"),
              value: 0,
            ),
            DropdownMenuItem<int>(
              child: Text("Lain-Lain"),
              value: 1,
            ),
          ],
          onChanged: (value) {
            setState(() {
              _valueCountry = value;
            });
          },
          value: _valueCountry,
          validator: (value) {
            if (value == null) {
              return 'Sila Pilih Negara';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _selectState() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: SizedBox(
        width: 160,
        child: DropdownButtonFormField(
          decoration: new InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
            border: OutlineInputBorder(),
            labelText: "Negeri",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          items: [
            for (int i = 0; i < _arrayState.length; i++)
              DropdownMenuItem<int>(
                child: Text(_arrayState[i]['state']),
                value: int.parse(_arrayState[i]['state_id']),
              ),
          ],
          onChanged: (value) {
            setState(() {
              _valueState = value;
            });
          },
          value: _valueState,
          validator: (value) {
            if (value == null) {
              return 'Sila Pilih Negeri';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _submitButton() {
    return Padding(
      padding: EdgeInsets.all(10),
      child: SizedBox(
        width: double.infinity,
        child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5)),
            ),
            color: Colors.orange,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Text(
                "Simpan",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () {}),
      ),
    );
  }
}
