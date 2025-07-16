import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../constants/enums/invoice_type.dart';
import '../../../../utils/date_time_parser.dart';

part 'receipt_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeConstants.receiptModel)
class ReceiptModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int receiptNumber;

  @HiveField(2)
  final InvoiceType type;

  @JsonKey(
      fromJson: DateTimeParser.dateTimeFromJson,
      toJson: DateTimeParser.dateTimeToJson)
  @HiveField(3)
  final DateTime invoiceDate;

  @HiveField(4)
  final String partyId;

  @HiveField(5)
  final String partyName;

  @HiveField(6)
  final Map<String, double> invoiceIds;

  @HiveField(7)
  final String notes;

  @HiveField(8)
  final double totalAmount;

  @HiveField(9)
  final String bankName;
  @HiveField(10)
  final String accountNumber;
  @HiveField(11)
  final String ifscCode;
  @HiveField(12)
  final String paymentMethod;
  @HiveField(13)
  final String? selectDate;
  @HiveField(14)
  final String checkNumber;
  @HiveField(15)
  final String upiId;
  @HiveField(16)
  final String companyId;
  @HiveField(17)
  final String finYear;

  ReceiptModel({
    this.id = '',
    this.receiptNumber = 0,
    required this.type,
    required this.invoiceDate,
    this.partyId = '',
    this.partyName = '',
    this.invoiceIds = const {},
    this.notes = '',
    this.totalAmount = 0.0,
    this.bankName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    this.selectDate = '',
    this.checkNumber = '',
    this.paymentMethod = '',
    this.upiId = '',
    this.companyId = '',
    this.finYear = '',
  });

  factory ReceiptModel.fromJson(Map<String, dynamic> json) =>
      _$ReceiptModelFromJson(json);

  Map<String, dynamic> toJson() => _$ReceiptModelToJson(this);

  ReceiptModel copyWith({
    String? id,
    int? invoiceNumber,
    InvoiceType? type,
    DateTime? invoiceDate,
    String? partyId,
    String? partyName,
    Map<String, double>? invoiceIds,
    String? notes,
    double? totalAmount,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    String? paymentMethod,
    String? selectDate,
    String? checkNumber,
    String? upiId,
    String? companyId,
    String? finYear,
  }) {
    return ReceiptModel(
      id: id ?? this.id,
      receiptNumber: invoiceNumber ?? receiptNumber,
      type: type ?? this.type,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      invoiceIds: invoiceIds ?? this.invoiceIds,
      notes: notes ?? this.notes,
      totalAmount: totalAmount ?? this.totalAmount,
      accountNumber: accountNumber ?? this.accountNumber,
      bankName: bankName ?? this.bankName,
      checkNumber: checkNumber ?? this.checkNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      selectDate: selectDate ?? this.selectDate,
      upiId: upiId ?? this.upiId,
      companyId: companyId ?? this.companyId,
      finYear: finYear ?? this.finYear,
    );
  }
}
