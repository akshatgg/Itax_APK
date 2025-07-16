import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config/hive/hive_type_constants.dart';

part 'invoice_type.g.dart';

@HiveType(typeId: HiveTypeConstants.invoiceType)
enum InvoiceType {
  @JsonValue('sales')
  @HiveField(0)
  sales,
  @JsonValue('purchase')
  @HiveField(1)
  purchase,
  @JsonValue('sales_return')
  @HiveField(2)
  salesReturn,
  @JsonValue('purchase_return')
  @HiveField(3)
  purchaseReturn,
  @JsonValue('credit_note')
  @HiveField(4)
  creditNote,
  @JsonValue('debit_note')
  @HiveField(5)
  debitNote,
  @JsonValue('payment')
  @HiveField(6)
  payment,
  @JsonValue('receipt')
  @HiveField(7)
  receipt,
  @JsonValue('e_invoice')
  @HiveField(8)
  eInvoice,
  @JsonValue('e_way')
  @HiveField(9)
  eWay,
}
