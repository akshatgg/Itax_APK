import 'package:flutter/material.dart';

Future<void> pickDateRange(
  BuildContext context,
  void Function(DateTimeRange) onDateSelected,
) async {
  DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: DateTime(2000),
    lastDate: DateTime(2100),
    initialDateRange: getCurrentFinancialYearRange(),
  );

  if (picked != null) {
    onDateSelected(picked); // Pass the selected range back
  }
}

DateTimeRange getCurrentFinancialYearRange() {
  DateTime now = DateTime.now();
  int year = now.year;
  int startYear = now.month >= 4 ? year : year - 1;
  DateTime startDate = DateTime(startYear, 4, 1); // April 1st
  DateTime endDate = DateTime(startYear + 1, 3, 31); // March 31st next year
  return DateTimeRange(start: startDate, end: endDate);
}
