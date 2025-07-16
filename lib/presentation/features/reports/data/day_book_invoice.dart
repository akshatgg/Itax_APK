import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../core/config/hive/hive_type_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';

part 'day_book_invoice.g.dart';

@HiveType(typeId: HiveTypeConstants.dayBookInvoice)
@JsonSerializable(explicitToJson: true)
class DayBookInvoice {
  @HiveField(0)
  final String partyName;
  @HiveField(1)
  final DateTime date;
  @HiveField(2)
  final int invoiceNumber;
  @HiveField(3)
  final double totalAmount;
  @HiveField(4)
  final InvoiceType invoiceType;
  @HiveField(5)
  final String invoiceId;

  DayBookInvoice({
    this.partyName = '',
    required this.date,
    this.invoiceNumber = 0,
    this.totalAmount = 0,
    required this.invoiceType,
    this.invoiceId = '',
  });

  factory DayBookInvoice.fromJson(Map<String, dynamic> json) =>
      _$DayBookInvoiceFromJson(json);

  Map<String, dynamic> toJson() => _$DayBookInvoiceToJson(this);
}
