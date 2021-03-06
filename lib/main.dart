import 'package:doktorsaya/pages/account/ChangePasswordPage.dart';
import 'package:doktorsaya/pages/admin/ManageDoctorPage.dart';
import 'package:doktorsaya/pages/call/ConfirmCallPage.dart';
import 'package:doktorsaya/pages/message/Message.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import 'pages/profile/EditDoctorPage.dart';
import 'pages/profile/EditProfilePage.dart';
import 'pages/HomePage.dart';
import 'pages/account/EditUserPage1.dart';
import 'pages/account/EditUserPage2.dart';
import 'pages/RolePage.dart';
import 'pages/WelcomePage.dart';
import 'pages/account/LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Doktor Saya',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: Colors.grey[200],
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
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

          case '/EditUserPage1':
            return PageTransition(
              child: EditUserPage1(settings.arguments),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/EditUserPage2':
            return PageTransition(
              child: EditUserPage2(settings.arguments),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/ChangePasswordPage':
            return PageTransition(
              child: ChangePasswordPage(),
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

          case '/ManageDoctorPage':
            return PageTransition(
              child: ManageDoctorPage(),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/EditProfilePage':
            final EditProfilePage args = settings.arguments;
            return PageTransition(
              child: EditProfilePage(role: args.role,type: args.type),
              type: PageTransitionType.fade,
              settings: settings,
            );
            break;

          case '/EditDoctorPage':
            final EditDoctorPage args = settings.arguments;
            return PageTransition(
              child: EditDoctorPage(roleId: args.roleId,type: args.type ),
              type: PageTransitionType.fade,
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
