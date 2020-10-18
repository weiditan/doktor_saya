import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _nickNameController = TextEditingController();
  int _valueGender;
  DateTime _dateOfBirth;
  DateTime _selectDate;
  final _dateController = TextEditingController();
  final _mmcController = TextEditingController();
  String _role;

  File _image;

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
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: _maxWidth,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  _imageBox(_maxWidth),
                  SizedBox(height: 20),
                  _heading1("PROFIL"),
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
                  _heading1("HUBUNGAN"),
                  _heading2("Email"),
                  _heading3("weiditan@hotmail.com"),
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
          ),
        ),
      ),
    );
  }

  Widget _imageBox(_maxWidth) {
    return InkWell(
      onTap: _getFromGallery,
      child: Container(
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
              ? Icon(
                  Icons.account_circle,
                  size: _maxWidth,
                  color: Colors.grey,
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

  /// Get from gallery
  _getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    _cropImage(pickedFile.path);
  }

  /// Crop Image
  _cropImage(filePath) async {
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
        print(_image.lengthSync());
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
            if (value == null) {
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
                return 'Sila masukkan\n nombor telefon\n yang betul';
              }
              return null;
            },
            textInputAction: TextInputAction.done,
            // controller: ,
          ),
        ),
      ),
    );
  }

  Widget _submitButton(_label) {
    return SizedBox(
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
          onPressed: () {
            if (_formKey.currentState.validate()) {
              Navigator.pushNamed(context, '/HomePage');
            }
          }),
    );
  }

  Widget _heading1(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 22,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _heading2(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _heading3(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 30, top: 3),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }

  Future<Map> _saveData(_userId, _role, _fullName, _nickName, _gender,
      _dateOfBirth, _phone, _mmc) async {
    var url = 'http://www.breakvoid.com/DoktorSaya/RegisterPatient.php';
    http.Response response = await retry(
      // Make a GET request
      () => http.post(url, body: {
        'user_id': _userId,
        'role': _role,
        'fullname': _fullName,
        'nickname': _nickName,
        'gender': _gender,
        'birthday': _dateOfBirth,
        'phone': _phone,
        'MMC': _mmc,
      }).timeout(Duration(seconds: 5)),

      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    Map data = jsonDecode(response.body);
    return data;
  }
}
