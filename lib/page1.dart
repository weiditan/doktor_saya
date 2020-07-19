import 'package:doktorsaya/Prescription.dart';
import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          _row(context),
          _row(context),
          _row(context),
        ],
      ),
    );
  }

  Widget _row(context) {
    return Container(
      //color: Colors.grey,
      child: Padding(
        padding: EdgeInsets.only(top: 10, bottom: 10, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
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
                            "http://www.breakvoid.com/maje/admin_area/product_images/jubahlaki3.jpg")),
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
                    Text(
                      "Dr. Azhar",
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("10 July 2020 3:15 P.M."),
                  ],
                ),
              ],
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.call_made,
                  color: Colors.green,
                ),
                _prescriptionButton(context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _prescriptionButton(context) {
    return SizedBox(
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
              "Preskripsi\nPerubatan",
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
            MaterialPageRoute(builder: (context) => Prescription()),
          );
        },
      ),
    );
  }
}
