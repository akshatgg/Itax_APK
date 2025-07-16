class DateTimeParser {
  static DateTime dateTimeFromJson(String? json) =>
      json == null ? DateTime.now() : DateTime.parse(json);

  static String? dateTimeToJson(DateTime? date) => date?.toIso8601String();
}
