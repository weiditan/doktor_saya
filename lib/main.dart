import 'package:doktorsaya/pages/call/ConfirmCallPage.dart';
import 'package:doktorsaya/pages/message/Message.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'EditDoctorPage.dart';
import 'EditProfilePage.dart';
import 'HomePage.dart';
import 'RegisterPage1.dart';
import 'RegisterPage2.dart';
import 'RolePage.dart';
import 'ViewDoctorDetail.dart';
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
          case '/WelcomePage':
            return PageTransition(
              child: WelcomePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/LoginPage':
            return PageTransition(
              child: LoginPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/RolePage':
            return PageTransition(
              child: RolePage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/RegisterPage1':
            return PageTransition(
              child: RegisterPage1(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/RegisterPage2':
            return PageTransition(
              child: RegisterPage2(),
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

          case '/EditDoctorPage':
            return PageTransition(
              child: EditDoctorPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/ViewDoctorDetail':
            return PageTransition(
              child: ViewDoctorDetail(settings.arguments),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
            break;

          case '/Message':
            return PageTransition(
              child: Message(settings.arguments),
              type: PageTransitionType.rightToLeft,
              settings: settings,
            );
            break;

          case '/ConfirmCallPage':
            return PageTransition(
              child: ConfirmCallPage(settings.arguments),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          default:
            return null;
        }
      },
    );
  }
}
