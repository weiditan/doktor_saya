import 'package:doktorsaya/pages/profile/ext/diffDate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../functions/progressDialog.dart' as pr;
import '../../functions/sharedPreferences.dart' as sp;
import 'ext/text.dart' as tx;
import '../../functions/DatabaseConnect.dart' as db;
import '../../functions/loadingScreen.dart' as ls;

class EditDoctorPage extends StatefulWidget {
  @override
  _EditDoctorPageState createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  final _formKey = GlobalKey<FormState>();

  bool _loadingIconVisible = true;
  bool _loadingVisible = true;

  double _screenWidth;

  String _roleId;
  List _arraySpecialist;
  List _arrayState;
  List _arrayDoctorSpecialist;
  List _arrayDoctorExp;

  int _valueCountry;
  int _valueState;
  final _workplaceController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();

  @override
  void initState() {
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
      db.getWorkplace(_roleId).then((array) {
        if (array["workplace"] != "") {
          _workplaceController.text = array["workplace"];
          if (array["state_id"] == null) {
            _valueCountry = 1;
          } else {
            _valueCountry = 0;
            _valueState = int.parse(array["state_id"]);
          }
          _countryController.text = array["country"];
          _stateController.text = array["state"];
        }
      }),
      db.getDoctorExp(_roleId).then((onValue) {
        _arrayDoctorExp = onValue;
      })
    ]);
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

  Widget _secondScreen() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
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
                        _arrayDoctorSpecialist[i]['malay'],
                        _arrayDoctorSpecialist[i]['sub_specialist']),
                Card(
                  child: InkWell(
                    onTap: () {
                      _showAddSpecialistDialog(setState);
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
          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _workplaceField(),
                if (_workplaceController.text.isNotEmpty)
                  Wrap(
                    children: <Widget>[
                      _selectCountry(),
                      if (_arrayState != null && _valueCountry == 0)
                        _selectState(),
                    ],
                  ),
                if (_workplaceController.text.isNotEmpty && _valueCountry == 1)
                  _countryField(),
                if (_workplaceController.text.isNotEmpty && _valueCountry == 1)
                  _stateField(),
              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          tx.heading1("PENGALAMAN"),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Column(children: <Widget>[
              if (_arrayDoctorExp != null)
                for (int i = 0; i < _arrayDoctorExp.length; i++)
                  (_arrayDoctorExp[i]['enddate'] != '0000-00-00')
                      ? _cardExp(
                          _arrayDoctorExp[i]['doctor_exp_id'],
                          _arrayDoctorExp[i]['location'],
                          outputDiffDate(diffDate(
                              DateTime.parse(_arrayDoctorExp[i]['startdate']),
                              DateTime.parse(_arrayDoctorExp[i]['enddate']))))
                      : _cardExp(
                          _arrayDoctorExp[i]['doctor_exp_id'],
                          _arrayDoctorExp[i]['location'],
                          DateFormat('MMM d, yyyy').format(DateTime.parse(
                                  _arrayDoctorExp[i]['startdate'])) +
                              " \nSampai Sekarang"),
              Card(
                child: InkWell(
                  onTap: () {
                    _showExpDialog(setState);
                  },
                  child: ListTile(
                    leading: Icon(
                      Icons.add_circle,
                      color: Colors.orange,
                      size: 30,
                    ),
                    title: Text(
                      "Tambah Pengalaman",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
          ),
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

  Widget _cardExp(String doctorExpId, String title, String subtitle) {
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
                  .deleteDoctorExp(doctorExpId)
                  .timeout(new Duration(seconds: 15))
                  .then((s) async {
                if (s['status']) {
                  db.getDoctorExp(_roleId).then((onValue) async {
                    setState(() {
                      _arrayDoctorExp = onValue;
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
            }),
      ),
    );
  }

  _showExpDialog(StateSetter pageSetState) {
    final _expFormKey = GlobalKey<FormState>();
    final _startDateController = TextEditingController();
    final _endDateController = TextEditingController();
    final _expWorkplaceController = TextEditingController();
    DateTime _startDate;
    DateTime _endDate;
    int _valueStatus;

    Widget _expWorkplaceField() {
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
          controller: _expWorkplaceController,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Sila Masukkan Tempat Kerja';
            }
            return null;
          },
        ),
      );
    }

    Widget _selectStatus(StateSetter setState) {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 20),
        child: SizedBox(
          width: 130,
          child: DropdownButtonFormField(
            decoration: new InputDecoration(
              contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
              border: OutlineInputBorder(),
              labelText: "Status",
              labelStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            items: [
              DropdownMenuItem<int>(
                child: Text('Sudah Tamat'),
                value: 0,
              ),
              DropdownMenuItem<int>(
                child: Text('Belum Tamat'),
                value: 1,
              ),
            ],
            onChanged: (onValue) {
              setState(() {
                _valueStatus = onValue;
              });
            },
            value: _valueStatus,
            validator: (onValue) {
              if (onValue == null) {
                return 'Sila Pilih Status';
              }
              return null;
            },
          ),
        ),
      );
    }

    Future<DateTime> _showDateDialog(
        String label, DateTime initialDateTime) async {
      DateTime _selectDate;

      await showDialog(
        context: context,
        builder: (_) => new AlertDialog(
          title: new Text(label),
          content: Container(
            height: 200,
            width: 700,
            child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: (initialDateTime != null)
                    ? initialDateTime
                    : DateTime.now(),
                minimumYear: DateTime.now().year - 100,
                maximumDate: DateTime.now().add(Duration(seconds: 10)),
                onDateTimeChanged: (_date) {
                  _selectDate = _date;
                }),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Simpan'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        ),
      );
      return _selectDate;
    }

    Widget _startDateField() {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SizedBox(
          width: 150,
          child: TextFormField(
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tarikh Mula",
              labelStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            controller: _startDateController,
            readOnly: true,
            focusNode: FocusNode(),
            onTap: () {
              _showDateDialog("Tarikh Mula", _startDate).then((onValue) {
                if (onValue != null) {
                  _startDate = onValue;
                  _startDateController.text =
                      DateFormat('MMM d, yyyy').format(onValue);
                }
              });
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Sila Pilih Tarikh Mula';
              }
              return null;
            },
          ),
        ),
      );
    }

    Widget _endDateField() {
      return Padding(
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
        child: SizedBox(
          width: 150,
          child: TextFormField(
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Tarikh Tamat",
              labelStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            controller: _endDateController,
            readOnly: true,
            focusNode: FocusNode(),
            onTap: () {
              _showDateDialog("Tarikh Tamat", _endDate).then((onValue) {
                if (onValue != null) {
                  _endDate = onValue;
                  _endDateController.text =
                      DateFormat('MMM d, yyyy').format(onValue);
                }
              });
            },
            validator: (String value) {
              if (value.isEmpty) {
                return 'Sila Pilih Tarikh Tamat';
              }
              return null;
            },
          ),
        ),
      );
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Tambah Pengalaman"),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                width: _screenWidth,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Form(
                    key: _expFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _expWorkplaceField(),
                        _startDateField(),
                        _selectStatus(setState),
                        if (_valueStatus == 0) _endDateField()
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
                if (_expFormKey.currentState.validate()) {
                  if (_valueStatus != 1) {
                    if (_endDate.difference(_startDate).inDays <= 0) {
                      pr.show(context, "");
                      pr.error(
                          "Tarikh tamat tidak boleh sama atau kurang daripada tarikh mula.");
                    } else {
                      await pr.show(context, "Memuatkan");
                      db
                          .addDoctorExp(
                              _roleId,
                              _expWorkplaceController.text,
                              DateFormat('yyyy-MM-dd').format(_startDate),
                              DateFormat('yyyy-MM-dd').format(_endDate))
                          .timeout(new Duration(seconds: 15))
                          .then(
                        (s) async {
                          if (s['status']) {
                            db.getDoctorExp(_roleId).then((onValue) async {
                              pageSetState(() {
                                _arrayDoctorExp = onValue;
                              });
                            });
                            await pr.hide();
                            Navigator.pop(context);
                          } else {
                            await pr.warning("Sila cuba lagi !");
                            print(s);
                          }
                        },
                      ).catchError(
                        (e) async {
                          await pr.warning("Sila cuba lagi !");
                          print(e);
                        },
                      );
                    }
                  } else {
                    await pr.show(context, "Memuatkan");
                    db
                        .addDoctorExp(_roleId, _expWorkplaceController.text,
                            DateFormat('yyyy-MM-dd').format(_startDate), "")
                        .timeout(new Duration(seconds: 15))
                        .then(
                      (s) async {
                        if (s['status']) {
                          db.getDoctorExp(_roleId).then((onValue) async {
                            pageSetState(() {
                              _arrayDoctorExp = onValue;
                            });
                          });
                          await pr.hide();
                          Navigator.pop(context);
                        } else {
                          await pr.warning("Sila cuba lagi !");
                          print(s);
                        }
                      },
                    ).catchError(
                      (e) async {
                        await pr.warning("Sila cuba lagi !");
                        print(e);
                      },
                    );
                  }
                }
              },
            )
          ],
        );
      },
    );
  }

  _showAddSpecialistDialog(StateSetter pageSetState) {
    final _specialistFormKey = GlobalKey<FormState>();
    int _valueSpecialist;
    final _subSpecialistController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
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
                                  return 'Sila Pilih Pakar';
                                }
                                return null;
                              },
                            ),
                          ),
                        SizedBox(height: 10),
                        if (_valueSpecialist != null && _valueSpecialist != 1)
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
                                  return 'Sila Masukkan Nama Pakar';
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
                      db.getDoctorSpecialist(_roleId).then((onValue) {
                        pageSetState(() {
                          _arrayDoctorSpecialist = onValue;
                        });
                      });
                      await pr.hide();
                      Navigator.pop(context);
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
        controller: _workplaceController,
        onChanged: (_) {
          setState(() {});
        },
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
        validator: (value) {
          if (_workplaceController.text.isNotEmpty && value.isEmpty) {
            return 'Sila Masukkan Negara';
          }
          return null;
        },
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
        validator: (value) {
          if (_workplaceController.text.isNotEmpty && value.isEmpty) {
            return 'Sila Masukkan Negeri';
          }
          return null;
        },
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
            if (_workplaceController.text.isNotEmpty && value == null) {
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
            if (_workplaceController.text.isNotEmpty && value == null) {
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
            onPressed: () async {
              if (_arrayDoctorSpecialist != null) {
                if (_formKey.currentState.validate()) {
                  if (_workplaceController.text.isNotEmpty) {
                    if (_valueCountry == 0) {
                      _updateWorkplace(_roleId, _workplaceController.text,
                          _valueState, '', '');
                    } else if (_valueCountry == 1) {
                      _updateWorkplace(_roleId, _workplaceController.text, null,
                          _countryController.text, _stateController.text);
                    }
                  } else {
                    _updateWorkplace(_roleId, '', null, '', '');
                  }
                }
              } else {
                pr.show(context, "");
                pr.error("Sila Tambar Pakar");
              }
            }),
      ),
    );
  }

  Future _updateWorkplace(String roleId, String workplace, int stateId,
      String country, String state) async {
    await pr.show(context, "Memuatkan");
    db
        .updateWorkplace(roleId, workplace, stateId, country, state)
        .timeout(new Duration(seconds: 15))
        .then((s) async {
      if (s['status']) {
        await pr.hide();
        Navigator.pushNamedAndRemoveUntil(
            context, '/HomePage', (Route<dynamic> route) => false);
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
}
