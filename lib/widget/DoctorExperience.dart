import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../functions/DiffDate.dart' as dd;
import '../functions/Text.dart' as tx;

Widget showDoctorExperience(List arrayDoctorExperience) {
  return (arrayDoctorExperience == null)
      ? Container()
      : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            tx.heading1("PENGALAMAN"),
            tx.heading1(" (" +
                dd.outputDiffDate(dd.totalExp(arrayDoctorExperience)) +
                ")"),
            for (int i = 0; i < arrayDoctorExperience.length; i++)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  tx.heading2(arrayDoctorExperience[i]['location']),
                  (arrayDoctorExperience[i]['enddate'] != '0000-00-00')
                      ? tx.heading3(dd.outputDiffDate(dd.diffDate(
                          DateTime.parse(arrayDoctorExperience[i]['startdate']),
                          DateTime.parse(arrayDoctorExperience[i]['enddate']))))
                      : tx.heading3(DateFormat('MMM d, yyyy').format(
                              DateTime.parse(
                                  arrayDoctorExperience[i]['startdate'])) +
                          " \nSampai Sekarang"),
                ],
              ),
            Divider(
              thickness: 1,
            ),
          ],
        );
}
