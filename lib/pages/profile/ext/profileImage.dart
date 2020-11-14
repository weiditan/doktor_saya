import 'package:flutter/material.dart';

Widget showSmallIconProfileImage(String profileImage, String online) {
  return Stack(
    children: [
      (profileImage == "")
          ? _noCircleProfileImage(50)
          : _circleProfileImage(50, profileImage),
      if(online=="1")
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 13,
          height: 13,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              border: Border.all(width: 0.5, color: Colors.white)),
        ),
      ),
    ],
  );
}

Widget showIconProfileImage(String profileImage, double width, String online) {
  return Stack(
    children: [
      (profileImage == "")
      ? _noCircleProfileImage(width)
      : _circleProfileImage(width, profileImage),
      if(online=="1")
      Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
              border: Border.all(width: 0.5, color: Colors.white)),
        ),
      ),
    ],
  );
}

Widget showProfileImage(String profileImage, double maxWidth) {
  return
      (profileImage == "")
          ? _noProfileImage(maxWidth)
          : _profileImage(maxWidth, profileImage);
}

Widget _noProfileImage(double width) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Icon(
          Icons.account_circle,
          size: width * 0.7,
          color: Colors.grey,
        ),
      ),
      Divider(
        thickness: 1,
      ),
    ],
  );
}

Widget _profileImage(double width, String image) {
  return Container(
    width: width,
    height: width,
    decoration: BoxDecoration(
      shape: BoxShape.rectangle,
      image: DecorationImage(
        fit: BoxFit.fill,
        image: NetworkImage(
            "http://www.breakvoid.com/DoktorSaya/Images/Profiles/" + image),
      ),
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

Widget _noCircleProfileImage(double width) {
  return Container(
    width: width,
    height: width,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(
          fit: BoxFit.fill,
          image: AssetImage("assets/account_circle_grey.png")),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
  );
}

Widget _circleProfileImage(double width, String image) {
  return Container(
    width: width,
    height: width,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
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
  );
}
