String getFinYear() {
  final now = DateTime.now();
  if (now.month >= 4) {
    return '${now.year}-${now.year + 1}';
  } else {
    return '${now.year - 1}-${now.year}';
  }
}

String getFinYearFromDate(DateTime date) {
  if (date.month >= 4) {
    return '${date.year}-${date.year + 1}';
  } else {
    return '${date.year - 1}-${date.year}';
  }
}

bool isDateInThisWeek(DateTime date) {
  final now = DateTime.now();

  final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
  final endOfWeek = startOfWeek.add(const Duration(days: 6));

  final dateToCheck = DateTime(date.year, date.month, date.day);
  final start = DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
  final end = DateTime(endOfWeek.year, endOfWeek.month, endOfWeek.day);

  return dateToCheck.isAtSameMomentAs(start) ||
      dateToCheck.isAtSameMomentAs(end) ||
      (dateToCheck.isAfter(start) && dateToCheck.isBefore(end));
}

bool isDateInThisFinYear(DateTime date) {
  final finYear = getFinYear();
  final start =
      DateTime(int.tryParse(finYear.split('-')[0]) ?? DateTime.now().year);
  final end =
      DateTime(int.tryParse(finYear.split('-')[1]) ?? DateTime.now().year);
  return date.isAtSameMomentAs(start) ||
      date.isAtSameMomentAs(end) ||
      (date.isAfter(start) && date.isBefore(end));
}

bool isDateInPreviousFinYear(DateTime date) {
  final finYear = getFinYear(); // 2024-2025
  final start = DateTime(
      int.tryParse(finYear.split('-')[0]) ?? DateTime.now().year); // 2024
  final end = DateTime(
      (int.tryParse(finYear.split('-')[1]) ?? DateTime.now().year) - 2); // 2023
  // 2023-2024
  return date.isBefore(start) && date.isAfter(end);
}

bool isDateInThisMonth(DateTime date) {
  final now = DateTime.now();
  return date.month == now.month && date.year == now.year;
}
