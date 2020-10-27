import 'package:flutter/material.dart';

import 'function/DatabaseConnect.dart' as db;
import 'function/SharedPreferences.dart' as sp;
import 'widget/LoadingScreen.dart';

class Page123 extends StatefulWidget {
  final Map data;
  Page123(this.data);

  @override
  _Page123State createState() => _Page123State();
}

class _Page123State extends State<Page123> {
  String _roleId;
  bool _loadingIconVisible = true;
  bool _loadingVisible = true;
  bool _loop = true;
  List _arrayDoctor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData().then((_) {
      setState(() {
        _hideLoadingScreen();
      });
    });
  }

  Future getData() async {
    _roleId = await sp.getRoleId();
    _arrayDoctor = await db.getMessageList(_roleId);

    print(_arrayDoctor);
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
        firstChild: loadingScreen(_loadingIconVisible),
        secondChild: _secondScreen(),
      ),
    );
  }

  Widget _secondScreen() {
    return (_arrayDoctor == null)
        ? Container()
        : SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(height: 10,),
                for (int i = 0; i < _arrayDoctor.length; i++)
                  _messageRow(_arrayDoctor[i]['nickname'],_arrayDoctor[i]['image'],_arrayDoctor[i]['message'])
              ],
            ),
          );
  }

  Widget _messageRow(String name, String image, String message) {
    return Padding(
      padding: EdgeInsets.only(left: 10, right: 10,top: 5),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: 65,
                    height: 65,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.fill,
                          image: NetworkImage(
                              "http://www.breakvoid.com/DoktorSaya/Images/Profiles/" + image)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 3,
                          blurRadius: 10,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 15,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        message,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "Montserrat",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 80),
            child:  Divider(
              thickness: 1,
            ),
          )
        ],
      ),
    );
  }
}
