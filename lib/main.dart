import 'package:flutter/material.dart';

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
        brightness: Brightness.light,
        primarySwatch: Colors.orange,

      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        //primaryColor: Colors.black,
        accentColor: Colors.orange,

      ),
      home: WelcomePage(),
      routes: <String, WidgetBuilder>{
        //'/HomePage': (BuildContext context) => HomePage(),
        '/LoginPage': (BuildContext context) => LoginPage(),
      }
    );
  }
}
