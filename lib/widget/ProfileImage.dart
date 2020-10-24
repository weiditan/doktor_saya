import 'package:flutter/material.dart';

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
