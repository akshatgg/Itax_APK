import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/config/hive/hive_type_constants.dart';
import '../../../../core/utils/date_time_parser.dart';
import 'day_book_invoice.dart';

part 'day_book.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeConstants.dayBook)
class DayBook {
  @HiveField(0)
  final String id;
  @HiveField(1)
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  final DateTime date;
  @HiveField(2)
  final List<DayBookInvoice> invoices;
  @HiveField(3)
  final String companyId;

  DayBook({
    required this.id,
    required this.date,
    required this.invoices,
    required this.companyId,
  });

  factory DayBook.fromJson(Map<String, dynamic> json) =>
      _$DayBookFromJson(json);

  Map<String, dynamic> toJson() => _$DayBookToJson(this);

  DayBook copyWith({
    String? id,
    DateTime? date,
    List<DayBookInvoice>? invoices,
    String? companyId,
  }) {
    return DayBook(
      id: id ?? this.id,
      date: date ?? this.date,
      invoices: invoices ?? this.invoices,
      companyId: companyId ?? this.companyId,
    );
  }

  @override
  String toString() {
    return 'DayBook(id: $id,date: $date, invoices: $invoices)';
  }
}
