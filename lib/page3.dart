import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class Page3 extends StatefulWidget {
  @override
  _Page3State createState() => _Page3State();
}

class _Page3State extends State<Page3> {

  String output;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    var url = 'http://www.breakvoid.com/mydoctor/viewdoctor.php';
    http.Response response = await retry(
      // Make a GET request
          () => http.get(url).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    print(response.toString());
    var data = jsonDecode(response.body);

    setState(() {
      output = data[2]["fullname"].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Center(
        child: new Text(output),
      ),
    );
  }
}

