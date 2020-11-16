import 'package:doktorsaya/functions/loadingScreen.dart';
import 'package:doktorsaya/functions/sharedPreferences.dart';
import 'package:doktorsaya/pages/profile/ext/doctorExpDatabase.dart';
import 'package:doktorsaya/pages/profile/ext/profileDatabase.dart';
import 'package:doktorsaya/pages/profile/ext/profileImage.dart';
import 'package:doktorsaya/pages/profile/ext/specialistDatabase.dart';
import 'package:flutter/material.dart';
import 'ext/diffDate.dart' as dd;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List _arraySpecialist, _arraySubSpecialist, _arrayDoctor;
  String _valueSpecialist = "";
  String _valueSubSpecialist = "";
  String _roleId;
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    _roleId = await getRoleId();
    _arraySpecialist = await getSpecialist();
    _arraySubSpecialist = await getSubSpecialist();
    _arrayDoctor = await getAllDoctor("", "", "");
    await Future.wait([
      for (int i = 0; i < _arrayDoctor.length; i++)
        _getTotalExp(_arrayDoctor[i]),
    ]);
    setState(() {
      _hideLoadingScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: TextField(
            controller: _searchController,
            onChanged: (s) {
              _search();
            },
            decoration: new InputDecoration(
                prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  _searchController.text = "";
                  _search();
                })
          ],
          bottom: PreferredSize(
              child: Container(
                margin: EdgeInsets.only(bottom: 5, left: 10, right: 10),
                child: Row(
                  children: [
                    _selectSpecialist(),
                    if (_valueSpecialist != "0" && _valueSpecialist != "1")
                      SizedBox(width: 5),
                    _selectSubSpecialist(),
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(60.0)),
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
          firstChild: loadingScreen(_loadingIconVisible),
          secondChild: _secondScreen(),
        ));
  }

  Widget _selectSpecialist() {
    return (_arraySpecialist == null)
        ? Container()
        : Flexible(
            // width: 150,
            child: DropdownButtonFormField(
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                labelText: "Jenis Pakar",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: [
                DropdownMenuItem<String>(
                  child: Text("Semua"),
                  value: "",
                ),
                for (int i = 0; i < _arraySpecialist.length; i++)
                  DropdownMenuItem<String>(
                    child: Text(_arraySpecialist[i]['malay']),
                    value: _arraySpecialist[i]['specialist_id'],
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _valueSpecialist = value;
                  _valueSubSpecialist = "";
                });
                _search();
              },
              value: _valueSpecialist,
            ),
          );
  }

  Widget _selectSubSpecialist() {
    return (_arraySubSpecialist == null ||
            _valueSpecialist == null ||
            _valueSpecialist == "" ||
            _valueSpecialist == "0" ||
            _valueSpecialist == "1")
        ? Container()
        : Flexible(
            //width: 150,
            child: DropdownButtonFormField(
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                labelText: "Pakar",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              isExpanded: true,
              items: [
                DropdownMenuItem<String>(
                  child: Text("Semua"),
                  value: "",
                ),
                for (int i = 0; i < _arraySubSpecialist.length; i++)
                  if (_valueSpecialist ==
                      _arraySubSpecialist[i]['specialist_id'])
                    DropdownMenuItem<String>(
                      child: Text(
                        _arraySubSpecialist[i]['sub_specialist'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      value: _arraySubSpecialist[i]['sub_specialist'],
                    ),
              ],
              onChanged: (String value) {
                setState(() {
                  _valueSubSpecialist = value;
                });
                _search();
              },
              value: _valueSubSpecialist,
            ),
          );
  }

  Future _search() async {
    setState(() {
      _loadingVisible = true;
      _loadingIconVisible = true;
    });

    _arrayDoctor = await getAllDoctor(
        _searchController.text, _valueSpecialist, _valueSubSpecialist);

    await Future.wait([
      for (int i = 0; i < _arrayDoctor.length; i++)
        _getTotalExp(_arrayDoctor[i]),
    ]);

    setState(() {
      _hideLoadingScreen();
    });
  }

  Future _getTotalExp(Map doctor) async {
    await getDoctorExp(doctor['doctor_id']).then((onValue) {
      if (onValue != null) {
        doctor['total_exp'] = dd.outputDiffDate(dd.totalExp(onValue));
      }
    });
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
    return (_arrayDoctor == null  || _arrayDoctor.length == 0)
        ? _noDoctor()
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                for (int i = 0; i < _arrayDoctor.length; i++)
                  if (_arrayDoctor[i]['doctor_id'] != _roleId)
                    _doctorRow(_arrayDoctor[i]),
              ],
            ),
          );
  }

  Widget _noDoctor() {
    return Center(
      child: Text("Tiada Doktor"),
    );
  }

  Widget _doctorRow(Map doctor) {
    return Card(
      margin: EdgeInsets.only(left: 15, right: 15, top: 10),
      child: InkWell(
        onTap: () {
          Navigator.pushNamed(context, '/ViewDoctorDetail', arguments: doctor);
        },
        child: Padding(
          padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 80,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    SizedBox(width: 5),
                    showIconProfileImage(doctor['image'], 80, doctor['online']),
                    SizedBox(width: 10),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr " + doctor['nickname'],
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontFamily: "Montserrat",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "100% Kadar Tindakbalas",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Montserrat",
                                    color: Colors.grey[600],
                                  ),
                                ),
                                if (doctor['total_exp'] != null)
                                  Text(
                                    doctor['total_exp'] + " Pengalaman",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: "Montserrat",
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (doctor['specialist'] != null)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: _transformWord(doctor['specialist']),
                        ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _transformWord(String word) {
    List<String> _splitWord = word.split('\n');
    List<Widget> textWidgets = [];
    for (int i = 0; i < _splitWord.length; i++) {
      if (_splitWord[i] == "Doktor Umum" ||
          _splitWord[i] == "Pakar Bedah" ||
          _splitWord[i] == "Pakar Internis" ||
          _splitWord[i] == "Pakar Psikiatri" ||
          _splitWord[i] == "Lain-lain") {
        Text bold = Text(
          _splitWord[i],
          style: TextStyle(
            fontSize: 16,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.bold,
          ),
        );
        textWidgets.add(bold);
      } else {
        Widget normal = Padding(
          padding: EdgeInsets.only(left: 10),
          child: Text(
            _splitWord[i],
            style: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
            ),
          ),
        );
        textWidgets.add(normal);
      }
    }
    return textWidgets;
  }
}
