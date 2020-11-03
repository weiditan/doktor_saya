
import 'package:doktorsaya/functions/loadingScreen.dart';
import 'package:doktorsaya/pages/profile/ext/editProfileDatabase.dart';
import 'package:doktorsaya/pages/profile/ext/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path/path.dart' as path;

import '../../functions/sharedPreferences.dart' as sp;
import '../../functions/progressDialog.dart' as pr;
import 'ext/profileDatabase.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool _loadingIconVisible = true;
  bool _loadingVisible = true;

  final _fullNameController = TextEditingController();
  final _nickNameController = TextEditingController();
  int _valueGender;
  DateTime _dateOfBirth;
  DateTime _selectDate;
  final _dateController = TextEditingController();
  final _phoneController = TextEditingController();
  final _mmcController = TextEditingController();
  String _role;

  String _email = "";
  File _image;
  String _imageName = "";
  String _base64Image = "";
  String _roleId;
  String _uploadedImage;

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
  void initState() {
    super.initState();
    _getData().then((_) {
      _hideLoadingScreen();
    });
  }

  Future _getData() async {
    _roleId = await sp.getRoleId();

    if (_roleId != null) {
      Map userData = await getUserDetail(_roleId);

      setState(() {
        _fullNameController.text = userData['fullname'];
        _nickNameController.text = userData['nickname'];

        _valueGender = int.parse(userData['gender']);
        _dateOfBirth = DateTime.parse(userData['birthday']);
        _dateController.text = DateFormat('MMM d, yyyy').format(_dateOfBirth);
        _email = userData['email'];

        if (_role == "doctor") {
          _mmcController.text = userData['mmc'];
        }

        _phoneController.text = userData['phone'];
        _uploadedImage = userData['image'];
      });
    } else {
      await sp.getEmail().then((email) {
        setState(() {
          _email = email;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _role = ModalRoute.of(context).settings.arguments;

    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _maxWidth;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenWidth * 0.7;
    } else {
      _maxWidth = _screenWidth;
    }

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
        firstChild: loadingScreen(_loadingIconVisible),
        secondChild: _secondScreen(_maxWidth),
      ),
    );
  }

  Widget _secondScreen(_maxWidth) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _imageBox(_maxWidth),
            SizedBox(height: 20),
            heading1("PROFIL"),
            _entryField("Nama Penuh", _fullNameController),
            _entryField("Nama Panggilan", _nickNameController),
            Wrap(
              children: <Widget>[
                _selectGender(),
                _dateField(),
              ],
            ),
            if (_role == "doctor")
              _entryField("Nombor Pendaftaran MMC", _mmcController),
            Divider(
              thickness: 1,
            ),
            heading1("HUBUNGAN"),
            heading2("Email"),
            heading3(_email),
            _phoneField(),
            Divider(
              thickness: 1,
            ),
            (_role == "doctor")
                ? _submitButton("Seterusnya")
                : _submitButton("Simpan"),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _imageBox(_maxWidth) {
    return InkWell(
      onTap: _getFromGallery,
      child: (_uploadedImage != null && _image == null)
          ? Container(
              width: _maxWidth,
              height: _maxWidth,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                      "http://www.breakvoid.com/DoktorSaya/Images/Profiles/" +
                          _uploadedImage),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ), //_logo(_maxWidth),
            )
          : Container(
              width: _maxWidth,
              height: _maxWidth,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Center(
                child: (_image == null)
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Icon(
                            Icons.account_circle,
                            size: _maxWidth * 0.8,
                            color: Colors.grey,
                          ),
                          Text(
                            "Tukar Gambar Profil",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Montserrat",
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          )
                        ],
                      )
                    : Image.file(
                        _image,
                        width: _maxWidth,
                        height: _maxWidth,
                        fit: BoxFit.fill,
                      ),
              ),
            ),
    );
  }

  Future _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    _cropImage(pickedFile.path);
  }

  Future _cropImage(filePath) async {
    File croppedImage = await ImageCropper.cropImage(
        sourcePath: filePath,
        maxHeight: 1080,
        maxWidth: 1080,
        aspectRatioPresets: [CropAspectRatioPreset.square],
        androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Gambar Profil',
        ),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));

    if (croppedImage != null) {
      setState(() {
        _image = croppedImage;
      });
    }
  }

  Widget _entryField(_label, _controller) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20, right: 20),
      child: TextFormField(
        style: TextStyle(
          fontSize: 16,
        ),
        decoration: new InputDecoration(
          border: OutlineInputBorder(),
          labelText: _label,
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
        controller: _controller,
        validator: (String value) {
          if (value.isEmpty) {
            return 'Sila Masukkan ' + _label;
          }
          return null;
        },
      ),
    );
  }

  Widget _selectGender() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20),
      child: SizedBox(
        width: 120,
        child: DropdownButtonFormField(
          decoration: new InputDecoration(
            contentPadding: const EdgeInsets.only(left: 10, bottom: 10),
            border: OutlineInputBorder(),
            labelText: "Jantina",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          items: [
            DropdownMenuItem<int>(
              child: Text('Lelaki'),
              value: 0,
            ),
            DropdownMenuItem<int>(
              child: Text('Perempuan'),
              value: 1,
            ),
          ],
          onChanged: (value) {
            setState(() {
              _valueGender = value;
            });
          },
          value: _valueGender,
          validator: (value) {
            if (_valueGender == null) {
              return 'Sila Pilih Jantina';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _dateField() {
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
            labelText: "Tarikh Lahir",
            labelStyle: TextStyle(
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
            ),
          ),
          controller: _dateController,
          readOnly: true,
          focusNode: FocusNode(),
          onTap: _showDateDialog,
          validator: (String value) {
            if (value.isEmpty) {
              return 'Sila Pilih Tarikh Lahir';
            }
            return null;
          },
        ),
      ),
    );
  }

  _showDateDialog() {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              title: new Text("Tarikh Lahir"),
              content: Container(
                height: 200,
                width: 700,
                child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: _dateOfBirth,
                    minimumYear: DateTime.now().year - 100,
                    maximumDate: DateTime.now().add(Duration(seconds: 10)),
                    onDateTimeChanged: (_date) {
                      setState(() {
                        _selectDate = _date;
                      });
                    }),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Simpan'),
                  onPressed: () {
                    setState(() {
                      _dateOfBirth = _selectDate;
                      if (_dateOfBirth != null) {
                        _dateController.text =
                            DateFormat('MMM d, yyyy').format(_dateOfBirth);
                      }
                    });
                    Navigator.of(context).pop();
                  },
                )
              ],
            ));
  }

  Widget _phoneField() {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 20),
      child: Container(
        alignment: Alignment.topLeft,
        child: SizedBox(
          width: 150,
          child: TextFormField(
            style: TextStyle(
              fontSize: 16,
            ),
            decoration: new InputDecoration(
              border: OutlineInputBorder(),
              labelText: "No Telefon",
              labelStyle: TextStyle(
                fontFamily: "Montserrat",
                fontWeight: FontWeight.bold,
              ),
            ),
            obscureText: false,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly
            ],
            maxLength: 11,
            autovalidate: true,
            validator: (String value) {
              if (value.isNotEmpty && value.length < 9) {
                return 'Sila Masukkan\n Nombor Telefon\n Yang Betul';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            controller: _phoneController,
          ),
        ),
      ),
    );
  }

  Widget _submitButton(_label) {
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
                _label,
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
            ),
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                await pr.show(context, "Memuatkan");

                sp.getUserId().then((id) {
                  if (_image != null) {
                    _imageName = _role[0] +
                        id.toString() +
                        "_" +
                        DateTime.now().millisecondsSinceEpoch.toString() +
                        path.extension(_image.path);
                    _base64Image = base64Encode(_image.readAsBytesSync());
                  }

                  addOrUpdateProfile(
                          _role[0] + id.toString(),
                          id.toString(),
                          _role,
                          _fullNameController.text,
                          _nickNameController.text,
                          _valueGender.toString(),
                          DateFormat('yyyy-MM-dd').format(_dateOfBirth),
                          _phoneController.text,
                          _imageName,
                          _base64Image,
                          _mmcController.text)
                      .timeout(new Duration(seconds: 15))
                      .then((s) async {
                    if (s["status"]) {
                      sp.saveRoleId(s["data"]);
                      await pr.hide();
                      if (_role == "patient") {
                        Navigator.pushNamedAndRemoveUntil(context, '/HomePage',
                            (Route<dynamic> route) => false);
                      } else {
                        Navigator.pushReplacementNamed(context,
                            '/EditDoctorPage');
                      }
                    } else {
                      await pr.warning("Sila cuba lagi !");
                      print(s);
                    }
                  }).catchError((e) async {
                    await pr.warning("Sila cuba lagi !");
                    print(e);
                  });
                });
              }
            }),
      ),
    );
  }
}
