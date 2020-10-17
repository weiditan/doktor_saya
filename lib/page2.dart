import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:doktorsaya/ViewDoctorDetail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

import 'Call.dart';
import 'ConfirmCall.dart';
import 'Message.dart';

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  var _data;
  bool _loadingVisible = true;
  bool _loadingIconVisible = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getData();
  }

  Future _getData() async {
    var url = 'http://www.breakvoid.com/DoktorSaya/viewdoctor.php';
    http.Response response = await retry(
      // Make a GET request
      () => http.get(url).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    setState(() {
      _data = jsonDecode(response.body);
      _loadingIconVisible = false;
    });
    Timer(Duration(milliseconds: 500), () {
      setState(() {
        _loadingVisible = false;
      });
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
      firstChild: Center(
        child: _loadingIcon(),
      ),

      secondChild: ListView(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        children: <Widget>[
          if (_data != null)
            for (int i = 0; i < _data.length; i++)
              InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ViewDoctorDetail()),
                  );
                },
                child: _row(
                    "http://www.breakvoid.com/DoktorSaya/Images/profiles/profile" +
                        (i + 1).toString() +
                        ".jpg",
                    "Dr " + _data[i]["nickname"].toString(),
                    "specialist",
                    "2"),
              ),
          Container(
            //color: Colors.grey,
            child: Padding(
              padding:
                  EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      image: DecorationImage(
                          fit: BoxFit.fill, image: NetworkImage("http://www.breakvoid.com/doktorsaya/images/profiles/profile1.jpg",)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "name",
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: "Montserrat",
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("specialist"),
                      Text("5 Tahun Pengalaman"),
                      Row(
                        children: <Widget>[
                          SizedBox(
                            width: 120,
                            child: RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(Icons.call),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Panggil",
                                    style: TextStyle(
                                      fontFamily: "Montserrat",
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => ConfirmCall()),
                                );
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          _messageButton()
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }

  Widget _loadingIcon() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _loadingIconVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 500),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _row(_image, _name, _specialist, _exp) {
    return Container(
      //color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Row(
          children: <Widget>[
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                image: DecorationImage(
                    fit: BoxFit.fill, image: NetworkImage(_image)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  _name,
                  style: TextStyle(
                    fontSize: 18,
                    fontFamily: "Montserrat",
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(_specialist),
                Text(_exp + " Tahun Pengalaman"),
                Row(
                  children: <Widget>[
                    _callButton(),
                    SizedBox(
                      width: 5,
                    ),
                    _messageButton()
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _callButton() {
    return SizedBox(
      width: 120,
      child: RaisedButton(
        color: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.call),
            SizedBox(
              width: 5,
            ),
            Text(
              "Panggil",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Call()),
          );
        },
      ),
    );
  }

  Widget _messageButton() {
    return SizedBox(
      width: 120,
      child: RaisedButton(
        color: Colors.orange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5)),
        ),
        child: Row(
          children: <Widget>[
            Icon(Icons.message),
            SizedBox(
              width: 5,
            ),
            Text(
              "Mesej",
              style: TextStyle(
                fontFamily: "Montserrat",
                fontSize: 14,
              ),
            ),
          ],
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Message()),
          );
        },
      ),
    );
  }
}
