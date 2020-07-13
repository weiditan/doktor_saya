import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Page4 extends StatefulWidget {
  @override
  _Page4State createState() => _Page4State();
}

class _Page4State extends State<Page4> {
  Color color1 = Colors.white;

  @override
  Widget build(BuildContext context) {
    double _screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: Center(
        child: Container(
            width: _screenWidth,
            constraints: BoxConstraints(maxWidth: 100),
            color: Theme.of(context).cardColor,
            child: ListView(
              children: <Widget>[
                Image(
                  image: NetworkImage(
                      'http://www.breakvoid.com/maje/admin_area/product_images/jubahlaki3.jpg'),
                  fit: BoxFit.cover,
                ),

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    for (var i = 0; i < 20; i++)
                      Text(
                          'San Jose, CAasdasdasdas zjhaskdj jasda sjkdn kasj dna kj dh ak sd asd hjgjhj ghfgh'),
                  ],
                )


              ],
            )),
      ),

      /*ListView(
        children: <Widget>[


           /*Container(
              width: _screenWidth,
              height: _screenWidth,
              constraints: BoxConstraints(maxWidth: 300),
              color: Colors.blue,
              child: SizedBox(
              )
            ),*/

          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20),
              ),
              Row(children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20),
                ),
                Container(
                    height: 125.0,
                    width: 125.0,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                              'http://www.breakvoid.com/maje/admin_area/product_images/jubahlaki2.jpg'),
                        ))),
                SizedBox(
                  width: _screenWidth - 145,
                  child: Padding(
                      padding: EdgeInsets.only(left: 20, right: 20),
                      child: Column(children: <Widget>[
                        Text(
                          'Mark Stewart asdas asdasd adadsad asdasd fdfdgd',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'San Jose, CAasdasdasdas zjhaskdj jasdasjkdn kasjdnakjdh aksdasd',
                          style: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        ),
                      ])),
                ),
              ]),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  GestureDetector(
                      onTap: () {
                        print("Container clicked1");
                        setState(() {
                          color1 = Colors.amber[800];
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Ableitungen",
                          style: TextStyle(
                              color: color1,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )),
                  GestureDetector(
                      onTap: () {
                        print("Container clicked2");
                      },
                      child: new Container(
                        width: 100.0,
                        padding:
                            new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                        child: new Column(children: [
                          new Text("Ableitungen"),
                        ]),
                      )),
                  GestureDetector(
                      onTap: () {
                        print("Container clicked3");
                      },
                      child: new Container(
                        width: 100.0,
                        padding:
                            new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 40.0),
                        child: new Column(children: [
                          new Text("Ableitungen"),
                        ]),
                      )),
                ],
              ),
              Padding(
                padding: EdgeInsets.all(30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '24K',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 5),
                        ),
                        Text(
                          'FOLLOWERS',
                          style: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '31',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'TRIPS',
                          style: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '21',
                          style: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5.0),
                        Text(
                          'BUCKET LIST',
                          style: TextStyle(
                              fontFamily: 'Montserrat', color: Colors.grey),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton(icon: Icon(Icons.table_chart)),
                    IconButton(
                      icon: Icon(Icons.menu),
                      onPressed: () {},
                    )
                  ],
                ),
              ),
            ],
          )
        ],
      ),*/
    );
  }
}
