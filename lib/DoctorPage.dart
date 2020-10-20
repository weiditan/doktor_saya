import 'dart:async';

import 'package:flutter/material.dart';

import 'LoadingScreen.dart' as ls;

class DoctorPage extends StatefulWidget {
  @override
  _DoctorPageState createState() => _DoctorPageState();
}

class _DoctorPageState extends State<DoctorPage> {
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(Duration(milliseconds: 2000), () {
      _hideLoadingScreen();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCrossFade(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        crossFadeState: _loadingVisible
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        firstCurve: Curves.easeOut,
        secondCurve: Curves.easeIn,
        duration: Duration(milliseconds: 500),
        firstChild: ls.loading(_loadingIconVisible),
        secondChild: _secondScreen(),
      ),
    );
  }

  Future _hideLoadingScreen() async {
    setState(() {
      _loadingIconVisible = false;
    });
    await Future.delayed(Duration(milliseconds: 500));
    setState(() {
      _loadingVisible = false;
    });
  }

  Widget _secondScreen(){
    return Text("asdsdadhg");
  }
}
