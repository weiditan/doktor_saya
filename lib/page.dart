import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:retry/retry.dart';

class Page0 extends StatefulWidget {
  @override
  _Page0State createState() => _Page0State();
}

class _Page0State extends State<Page0> {

  String output = 'ghjvhbkj';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  Future getData() async {
    var url = 'http://www.breakvoid.com/mydoktor/viewdoctor.php';
    http.Response response = await retry(
      // Make a GET request
            () => http.get(url).timeout(Duration(seconds: 5)),
        // Retry on SocketException or TimeoutException
        retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    var data = jsonDecode(response.body);

    setState(() {
      output = data['status'].toString();
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

