import 'package:flutter/material.dart';

import '../function/Text.dart' as tx;

Widget showDoctorSpecialist(List arrayDoctorSpecialist) {
  return (arrayDoctorSpecialist == null)
      ? Container()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            tx.heading1("PAKAR DOKTOR"),
            for (int i = 0; i < arrayDoctorSpecialist.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  tx.heading2(arrayDoctorSpecialist[i]['malay']),
                  tx.heading3(arrayDoctorSpecialist[i]['sub_specialist']),
                ],
              ),
            Divider(
              thickness: 1,
            ),
          ],
        );
}
