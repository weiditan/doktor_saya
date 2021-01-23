import 'package:flutter/material.dart';

class ViewDoctorDetail2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double _screenHeight = MediaQuery.of(context).size.height;
    double _screenWidth = MediaQuery.of(context).size.width;
    double _maxWidth;

    if (_screenWidth > _screenHeight) {
      _maxWidth = _screenHeight;
    } else {
      _maxWidth = _screenWidth;
    }

    return Scaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: _maxWidth,
          ),
          child: ListView(
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      _profileImage(_maxWidth),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          _callButton(context),
                          SizedBox(width: 10),
                          _messageButton(context),
                          SizedBox(width: 10),
                        ],
                      )
                    ],
                  ),
                  Positioned(top: 0, left: 0, child: _backButton(context)),
                ],
              ),
              SizedBox(height: 10),
              _heading1("DR. AZHAR"),
              _heading2("Nama Penuh"),
              _heading3("Azhar Bin Zainub"),
              _heading2("Jantina"),
              _heading3("Lelaki"),
              _heading2("Umur"),
              _heading3("42"),
              Divider(
                thickness: 1,
              ),
              _heading1("HUBUNGAN"),
              _heading2("Email"),
              _heading3("azhar@email.com"),
              _heading2("No Telefon"),
              _heading3("012-345 6789"),
              Divider(
                thickness: 1,
              ),
              _heading1("PAKAR DOKTOR"),
              _heading2("Pakar Bedah"),
              _heading3("Pakar Oftalmologi"),
              Divider(
                thickness: 1,
              ),
              _heading1("TEMPAT KERJA"),
              _heading2("Hospital Melaka Eye Specialist Clinic"),
              _heading3("Melaka, Malaysia"),
              Divider(
                thickness: 1,
              ),
              _heading1("PENGALAMAN"),
              _heading2("Hospital Melaka Eye Specialist Clinic"),
              _heading3("2 tahun"),
              _heading2("The Tun Hussein Onn National Eye Hospital"),
              _heading3("3 tahun 8 bulan"),
              Divider(
                thickness: 1,
              ),
              _heading1("SIJIL"),
              SizedBox(
                height: 90,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    SizedBox(width: 15),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate1.jpg"),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate2.jpg"),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate3.jpg"),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate1.jpg"),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate2.jpg"),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate3.jpg"),
                    _certificateImage(
                        "http://www.breakvoid.com/doktorsaya/images/certificates/certificate1.jpg"),
                    SizedBox(width: 15),
                  ],
                ),
              ),
              Divider(
                thickness: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _backButton(context) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black))
          ],
        ),
      ),
    );
  }

  Widget _profileImage(_maxWidth) {
    return Container(
      width: _maxWidth,
      height: _maxWidth,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
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
      ), //_logo(_maxWidth),
    );
  }

  Widget _heading1(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 10, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 22,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _heading2(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 20, top: 5),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 18,
          fontFamily: "Montserrat",
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _heading3(_text) {
    return Padding(
      padding: EdgeInsets.only(left: 30, top: 3),
      child: Text(
        _text,
        style: TextStyle(
          fontSize: 16,
          fontFamily: "Montserrat",
        ),
      ),
    );
  }

  Widget _callButton(context) {
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
        onPressed: () {},
      ),
    );
  }

  Widget _messageButton(context) {
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
        onPressed: () {},
      ),
    );
  }

  Widget _certificateImage(_imageUrl) {
    return Padding(
      padding: EdgeInsets.all(5),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          image:
              DecorationImage(fit: BoxFit.fill, image: NetworkImage(_imageUrl)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 1,
              blurRadius: 3,
            ),
          ],
        ), //_logo(_maxWidth),
      ),
    );
  }
}
