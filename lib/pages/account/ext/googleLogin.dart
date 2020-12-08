import 'package:doktorsaya/functions/progressDialog.dart' as pr;
import 'package:doktorsaya/functions/sharedPreferences.dart' as sp;
import 'package:doktorsaya/pages/account/ext/accountDatabase.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['profile', 'email']);

Widget googleButton() {
  return SizedBox(
    width: double.infinity,
    child: RaisedButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      color: Colors.white,
      splashColor: Colors.grey,
      highlightColor: Colors.grey[300],
      child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image(
                image: AssetImage("assets/google.jpg"),
                width: 25,
                height: 25,
              ),
              Text(
                "Log masuk dengan Google",
                style: TextStyle(
                  fontFamily: "Montserrat",
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
            ],
          )),
      onPressed: _handleSignIn,
    ),
  );
}

Future<void> checkGoogleLogin(context) async {
  _googleSignIn.onCurrentUserChanged
      .listen((GoogleSignInAccount account) async {
    if (account != null) {
      await pr.show(context, "Log Masuk");

      googleLogin(account.email)
          .timeout(new Duration(seconds: 15))
          .then((s) async {
        if (s["status"]) {
          sp.saveUserId(int.parse(s["data"]));
          sp.saveEmail(account.email);
          await pr.hide();
          Navigator.pushNamedAndRemoveUntil(
              context, '/RolePage', (Route<dynamic> route) => false);
        } else {
          googleSignOut();
          await pr.warning("Sila cuba lagi !");
        }
      }).catchError((e) async {
        googleSignOut();
        await pr.warning("Sila cuba lagi !");
        print(e);
      });
    }
  });

  _googleSignIn.signInSilently();
}

Future<void> _handleSignIn() async {
  try {
    await _googleSignIn.signIn();
  } catch (error) {
    print(error);
  }
}

Future<void> googleSignOut() async {
  _googleSignIn.disconnect();
}
