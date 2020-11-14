import 'package:doktorsaya/pages/profile/ext/specialistDatabase.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = TextEditingController();
  List _arraySpecialist,_arraySubSpecialist;
  int _valueSpecialist;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future _init() async {
    _arraySpecialist = await getSpecialist();
    _arraySubSpecialist = await getSubSpecialist();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextField(
          controller: _searchController,
          decoration: new InputDecoration(
              prefixIcon: new Icon(Icons.search), hintText: 'Search...'),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _searchController.text = "";
              })
        ],
        bottom: PreferredSize(
            child: Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _selectSpecialist(),
                  _selectSubSpecialist(),
                ],
              ),
            ),
            preferredSize: Size.fromHeight(60.0)),
      ),
    );
  }

  Widget _selectSpecialist() {
    return (_arraySpecialist == null)
        ? Container()
        : SizedBox(
            width: 150,
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
                DropdownMenuItem<int>(
                  child: Text("Semua"),
                  value: 0,
                ),
                for (int i = 0; i < _arraySpecialist.length; i++)
                  DropdownMenuItem<int>(
                    child: Text(_arraySpecialist[i]['malay']),
                    value: int.parse(_arraySpecialist[i]['specialist_id']),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _valueSpecialist = value;
                  _searchController.text = value.toString();
                });
              },
              value: _valueSpecialist,
            ),
          );
  }

  Widget _selectSubSpecialist() {
    return (_arraySubSpecialist == null)
        ? Container()
        : SizedBox(
            width: 150,
            child: DropdownButtonFormField(
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
                labelText: "Pakar",
                labelStyle: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                ),
              ),
              items: [
                DropdownMenuItem<int>(
                  child: Text("Semua"),
                  value: 0,
                ),
                for (int i = 0; i < _arraySpecialist.length; i++)
                  DropdownMenuItem<int>(
                    child: Text(_arraySpecialist[i]['malay']),
                    value: int.parse(_arraySpecialist[i]['specialist_id']),
                  ),
              ],
              onChanged: (value) {
                setState(() {
                  _valueSpecialist = value;
                  _searchController.text = value.toString();
                });
              },
              value: _valueSpecialist,
            ),
          );
  }
}
