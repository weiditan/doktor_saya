import 'package:doktorsaya/RegisterPage2.dart';
import 'package:flutter/material.dart';

import 'RegisterPage1.dart';
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
      routes: <String, WidgetBuilder>{
        '/WelcomePage': (BuildContext context) => WelcomePage(),
        '/LoginPage': (BuildContext context) => LoginPage(),
        '/RegisterPage1': (BuildContext context) => RegisterPage1(),
      }
    );
  }
}
