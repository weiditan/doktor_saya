
import 'package:doktorsaya/pages/account/ext/accountDatabase.dart';
import 'package:doktorsaya/pages/profile/EditProfilePage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../functions/sharedPreferences.dart' as sp;
import '../../functions/progressDialog.dart' as pr;
import 'ext/googleLogin.dart';
import 'ext/logo.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _obscureText = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _focus1 = FocusNode();

  @override
  void initState() {
    super.initState();
    checkGoogleLogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Log Masuk"),
      ),
      body: (MediaQuery.of(context).orientation == Orientation.portrait)
          ? _portrait()
          : _landscape(),
    );
  }

  Widget _landscape() {
    return Row(
      children: <Widget>[
        Expanded(
          child: logo(),
        ),
        Expanded(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              margin: EdgeInsets.all(20),
              child: Center(
                child: Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          _emailField(),
                          SizedBox(height: 3),
                          _passwordField(),
                          _forgotPassword(),
                          SizedBox(height: 3),
                          _loginButton(),
                          _divider(),
                          googleButton()
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      child: _register(),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _portrait() {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Container(
        margin: EdgeInsets.only(left: 20, right: 20),
        child: Column(
          children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.3,
              child: logo(),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  _emailField(),
                  SizedBox(height: 10),
                  _passwordField(),
                  _forgotPassword(),
                  SizedBox(height: 3),
                  _loginButton(),
                  _divider(),
                  googleButton()
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: _register(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _emailField() {
    return TextFormField(
      style: TextStyle(
        fontSize: 14,
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
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onFieldSubmitted: (_) {
        FocusScope.of(context).requestFocus(_focus1);
      },
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

  Widget _passwordField() {
    return TextFormField(
      style: TextStyle(
        fontSize: 14,
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
            _toggle();
          },
        ),
      ),
      focusNode: _focus1,
      keyboardType: TextInputType.text,
      obscureText: _obscureText,
      controller: _passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (String value) {
        if (value.isNotEmpty && value.length < 8) {
          return 'Kata Laluan Tidak Boleh Kurang Daripada 8 Perkataan';
        } else if (value.isEmpty) {
          return 'Sila Masukkan Kata Laluan';
        }
        return null;
      },
    );
  }

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Widget _forgotPassword() {
    return Container(
      padding: EdgeInsets.only(top: 10, right: 10, bottom: 10),
      alignment: Alignment(1.0, 0.0),
      child: InkWell(
        child: Text(
          "Terlupa kala laluan ?",
          style: TextStyle(
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
          ),
        ),
        onTap: () {
          Navigator.pushNamedAndRemoveUntil(
              context, '/EditUserPage1', ModalRoute.withName('/'),
              arguments: "Forgot Password");
        },
      ),
    );
  }

  Widget _divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('atau'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }

  Widget _loginButton() {
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
              "Log Masuk",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 20,
                color: Colors.white,
              ),
            ),
          ),
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              await pr.show(context, "Log Masuk");
              login(_emailController.text, _passwordController.text)
                  .timeout(new Duration(seconds: 15))
                  .then((s) async {
                if (s["status"]) {
                  sp.saveUserId(int.parse(s["user_id"]));
                  sp.saveRole(s["role"]);
                  sp.saveEmail(_emailController.text);

                  if (s["role"] == "admin") {
                    await pr.hide();
                    Navigator.pushNamedAndRemoveUntil(context,
                        '/ManageDoctorPage', (Route<dynamic> route) => false);
                  } else if (s["role"] == "user") {
                    checkRole(s["user_id"], "doctor").then((checkDoctorValue) async {
                      if (checkDoctorValue['status']) {
                        await pr.hide();
                        Navigator.pushNamedAndRemoveUntil(context, '/RolePage',
                            (Route<dynamic> route) => false);
                      } else {
                        checkRole(s["user_id"], "patient")
                            .then((checkPatientValue) async {
                          if (checkPatientValue["status"]) {
                            await sp.saveRoleId(checkPatientValue["data"]);
                            await pr.hide();
                            Navigator.pushNamedAndRemoveUntil(context,
                                '/HomePage', (Route<dynamic> route) => false);
                          } else {
                            await pr.hide();
                            Navigator.pushNamed(context, '/EditProfilePage',
                                arguments: EditProfilePage(
                                    role: "patient", type: null));
                          }
                        });
                      }
                    });
                  }
                } else {
                  await pr.error(s["data"]);
                }
              }).catchError((e) async {
                await pr.warning("Sila cuba lagi !");
                print(e);
              });
            }
          }),
    );
  }

  Widget _register() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Tiada account ?",
            style: TextStyle(
                fontFamily: "Montserrat", fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 10,
          ),
          InkWell(
            child: Text(
              'Daftar Akaun',
              style: TextStyle(
                fontFamily: "Montserrat",
                color: Color(0xfff79c4f),
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/EditUserPage1', ModalRoute.withName('/'),
                  arguments: "Register");
            },
          ),
        ],
      ),
    );
  }
}
