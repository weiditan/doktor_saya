Map diffDate(DateTime startDate, DateTime endDate) {
  int years = endDate.year - startDate.year;
  int months = endDate.month - startDate.month;
  int days = endDate.day - startDate.day;

  if (days < 0) {
    months -= 1;
    days = endDate
        .difference(DateTime(endDate.year, endDate.month - 1, startDate.day))
        .inDays;
  }

  if (months < 0) {
    years -= 1;
    months += 12;
  }

  Map diff = {'years': years, 'months': months, 'days': days};

  return diff;
}

Map totalExp(List list) {
  DateTime today = DateTime.now();
  int _totalYears = 0;
  int _totalMonths = 0;
  int _totalDays = 0;
  Map total;

  if (list != null) {
    list.forEach((item) {
      DateTime _startDate = DateTime.parse(item['startdate']);
      DateTime _endDate;

      if (item['enddate'] == '0000-00-00') {
        _endDate = today;
      } else {
        _endDate = DateTime.parse(item['enddate']);
      }

      Map _mapDiffDate = diffDate(_startDate, _endDate);

      _totalYears += _mapDiffDate['years'];
      _totalMonths += _mapDiffDate['months'];
      _totalDays += _mapDiffDate['days'];
    });

    if (_totalDays > 30) {
      _totalMonths += (_totalDays ~/ 30);
      _totalDays %= 30;
    }

    if (_totalMonths > 12) {
      _totalYears += (_totalMonths ~/ 12);
      _totalMonths %= 12;
    }

    total = {'years': _totalYears, 'months': _totalMonths, 'days': _totalDays};
  }
  return total;
}

String outputDiffDate(Map item) {
  String _outputYears = "";
  String _outputMonths = "";
  String _outputDays = "";
  int years = item['years'];
  int months = item['months'];
  int days = item['days'];

  if (years != 0) {
    if (months != 0 || days != 0) {
      _outputYears = years.toString() + " Tahun, ";
    } else {
      _outputYears = years.toString() + " Tahun";
    }
  }

  if (months != 0) {
    if (days != 0) {
      _outputMonths = months.toString() + " Bulan, ";
    } else {
      _outputMonths = months.toString() + " Bulan";
    }
  }

  if (days != 0) {
    _outputDays = days.toString() + " Hari";
  }

  return _outputYears + _outputMonths + _outputDays;
}
