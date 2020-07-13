import 'package:doktorsaya/welcomePage.dart';
import 'package:flutter/material.dart';

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
        backgroundColor: Colors.orange,,
        //primarySwatch: Colors.orange,
        bottomAppBarColor: Colors.red,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        //primaryColor: Colors.black,
        accentColor: Colors.orange,

      ),
      home: WelcomePage(),
    );
  }
}
