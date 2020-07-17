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
    var url = 'http://www.breakvoid.com/doktorsaya/viewdoctor.php';
    http.Response response = await retry(
      // Make a GET request
          () => http.get(url).timeout(Duration(seconds: 5)),
      // Retry on SocketException or TimeoutException
      retryIf: (e) => e is SocketException || e is TimeoutException,
    );

    setState(() {
      _data = jsonDecode(response.body);
      _loadingIconVisible = false;

      Timer(Duration(milliseconds: 1000), (){
        setState(() {
          _loadingVisible = false;
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedCrossFade(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).
          crossFadeState: _loadingVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
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
              if(_data!=null)
                for (int i = 0; i < _data.length; i++)
                  _row(
                      "http://www.breakvoid.com/maje/admin_area/product_images/jubahlaki3.jpg",
                      _data[i]["nickname"].toString(),
                      "specialist",
                      "2",
                      "location",
                      "online"
                  ),
            ],
          ),
      )
    );
  }

  Widget _loadingIcon(){
    return Padding(
      padding: const EdgeInsets.all(20),
      child: AnimatedOpacity(
        // If the widget is visible, animate to 0.0 (invisible).
        // If the widget is hidden, animate to 1.0 (fully visible).
        opacity: _loadingIconVisible ? 1.0 : 0.0,
        duration: Duration(milliseconds: 1000),
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _row(_image,_name,_specialist, _exp, _location, _online) {
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
                    fit: BoxFit.fill,
                    image: NetworkImage(
                        _image)),
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
            SizedBox(width: 10,),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(_name),
                Text(_specialist),
                Text(_exp+" Tahun Pengalaman"),
                Text(_location),
                Text(_online),
              ],
            ),
          ],
        ),
      ),
    );
  }


}