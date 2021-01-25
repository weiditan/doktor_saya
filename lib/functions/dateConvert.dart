import 'package:intl/intl.dart';

Duration _timeZone = DateTime.now().timeZoneOffset;

String toLocalDateTime(String dateTime) {
  DateTime _localDateTime = DateTime.parse(dateTime).add(_timeZone);
  return DateFormat('MMM d, yyyy').add_jm().format(_localDateTime);
}