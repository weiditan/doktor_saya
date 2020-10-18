import 'package:doktorsaya/HomePage.dart';
import 'package:doktorsaya/RolePage.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'EditProfilePage.dart';
import 'RegisterPage1.dart';
import 'RegisterPatient.dart';
import 'WelcomePage.dart';
import 'LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        //brightness: Brightness.light,
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[200],

      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        //primaryColor: Colors.black,
        accentColor: Colors.orange,

      ),
      home: WelcomePage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {

          case '/LoginPage':
            return PageTransition(
              child: LoginPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/HomePage':
            return PageTransition(
              child: HomePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/EditProfilePage':
            return PageTransition(
              child: EditProfilePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          default:
            return null;
        }
      },
      routes: <String, WidgetBuilder>{
        '/WelcomePage': (BuildContext context) => WelcomePage(),
        //'/LoginPage': (BuildContext context) => LoginPage(),
        '/RegisterPage1': (BuildContext context) => RegisterPage1(),
        '/RolePage': (BuildContext context) => RolePage(),
        '/RegisterPatient': (BuildContext context) => RegisterPatient(),
        //'/RegisterDoctor': (BuildContext context) => RegisterDoctor(),
       // '/HomePage': (BuildContext context) => HomePage(),
      },





    );
  }
}
