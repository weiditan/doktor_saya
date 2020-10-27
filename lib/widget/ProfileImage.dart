import 'package:flutter/material.dart';

Widget showSmallIconProfileImage(String profileImage) {
  return (profileImage == "")
      ? _noCircleProfileImage(50)
      : _circleProfileImage(50, profileImage);
}

Widget showIconProfileImage(String profileImage) {
  return (profileImage == "")
      ? _noCircleProfileImage(80)
      : _circleProfileImage(80, profileImage);
}

Widget showProfileImage(String profileImage, double maxWidth) {
  return (profileImage == "")
      ? _noProfileImage(maxWidth)
      : _profileImage(maxWidth, profileImage);
}

Widget _noProfileImage(double maxWidth) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 20, bottom: 20),
        child: Icon(
          Icons.account_circle,
          size: maxWidth * 0.7,
          color: Colors.grey,
        ),
      ),
      Divider(
        thickness: 1,
      ),
    ],
  );
}

Widget _profileImage(double maxWidth, String image) {
  return Container(
    width: maxWidth,
    height: maxWidth,
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
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.5),
          spreadRadius: 3,
          blurRadius: 10,
          offset: Offset(0, 3), // changes position of shadow
        ),
      ],
    ),
    child: Icon(
      Icons.account_circle,
      size: width,
      color: Colors.grey,
    ),
  );
}

Widget _circleProfileImage(double width, String image) {
  return Container(
    width: width,
    height: width,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      image: DecorationImage(fit: BoxFit.fill, image: NetworkImage("http://www.breakvoid.com/DoktorSaya/Images/Profiles/" + image)),
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
