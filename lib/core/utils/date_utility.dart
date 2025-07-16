import 'package:intl/intl.dart';

extension DateUtility on DateTime {
  // 2012-02-27
  String convertToStore() {
    var day = this.day >= 10 ? this.day : '0${this.day}';
    var month = this.month >= 10 ? this.month : '0${this.month}';
    return '$year-$month-$day';
  }

  // 27/02/2012
  String convertToDisplay() {
    var day = this.day >= 10 ? this.day : '0${this.day}';
    var month = this.month >= 10 ? this.month : '0${this.month}';
    return '$day/$month/$year';
  }

  String convertToDisplayDDMMYYY() {
    return DateFormat('dd MMM yy').format(this);
  }

  int getCenturyStartYear() {
    return (year ~/ 100) * 100;
  }

  int getCenturyEndYear() {
    return ((year ~/ 100) + 1) * 100;
  }
}
