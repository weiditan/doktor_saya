import 'package:flutter/material.dart';

import '../function/Text.dart' as tx;

Widget showDoctorWorkplace(Map userData) {
  return (userData['workplace'] == "")
      ? Container()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            tx.heading1("TEMPAT KERJA"),
            tx.heading2(userData['workplace']),
            (userData['country'] == "")
                ? tx.heading3(userData['selected_state'] + ", Malaysia")
                : tx.heading3(userData['state'] + ", " + userData['country']),
            Divider(
              thickness: 1,
            ),
          ],
        );
}
