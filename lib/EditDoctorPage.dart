import 'package:flutter/material.dart';

import 'function/Text.dart' as tx;
import 'function/DatabaseConnect.dart' as db;

class EditDoctorPage extends StatefulWidget {
  @override
  _EditDoctorPageState createState() => _EditDoctorPageState();
}

class _EditDoctorPageState extends State<EditDoctorPage> {
  double _screenWidth;
  int _valueSpecialist;
  List _arraySpecialist;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    db.getSpecialist().then((onValue) {
      setState(() {
        _arraySpecialist = onValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profil'),
      ),
      body: _secondScreen(),
    );
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
                Card(
                  child: ListTile(
                    title: Text(
                      "Pakar Bedah",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Pakar Oftalmologi",
                        style:
                            TextStyle(fontSize: 16, fontFamily: "Montserrat"),
                      ),
                    ),
                    trailing: IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ),
                Card(
                  child: InkWell(
                    onTap: () {

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
          if (_arraySpecialist != null) _selectSpecialist(),
          _subSpecialistField(),
          Divider(
            thickness: 1,
          ),
          tx.heading1("TEMPAT KERJA"),
          tx.heading2("Hospital Melaka Eye Specialist Clinic"),
          tx.heading3("Melaka, Malaysia"),
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

  Widget _selectSpecialist() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10),
      child: SizedBox(
        width: 150,
        child: DropdownButtonFormField(
          decoration: new InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
            border: OutlineInputBorder(),
            labelText: "Jenis Pakar",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          items: [
            for (int i = 0; i < _arraySpecialist.length; i++)
              DropdownMenuItem<int>(
                child: Text(_arraySpecialist[i]['malay']),
                value: int.parse(_arraySpecialist[i]['specialist_id']),
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
    );
  }

  Widget _subSpecialistField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 10, right: 20),
      child: TextFormField(
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
        textInputAction: TextInputAction.next,
        onFieldSubmitted: (_) {
          FocusScope.of(context).nextFocus();
        },
        //controller: _controller,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Sila masukkan nama pakar.';
          }
          return null;
        },
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
