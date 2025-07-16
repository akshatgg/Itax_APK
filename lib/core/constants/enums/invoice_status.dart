import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config/hive/hive_type_constants.dart';

part 'invoice_status.g.dart';

@HiveType(typeId: HiveTypeConstants.invoiceStatus)
enum InvoiceStatus {
  @HiveField(0)
  @JsonValue('unpaid')
  unpaid,
  @HiveField(1)
  @JsonValue('paid')
  paid,
  @HiveField(2)
  @JsonValue('overdue')
  overdue,
  @HiveField(3)
  @JsonValue('partially_paid')
  partiallyPaid,
}
