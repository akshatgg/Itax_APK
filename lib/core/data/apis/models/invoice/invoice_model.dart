// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../constants/enums/invoice_status.dart';
import '../../../../constants/enums/invoice_type.dart';
import '../../../../utils/date_time_parser.dart';
import 'invoice_item_model.dart';

part 'invoice_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeConstants.invoiceModel)
class InvoiceModel {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final int invoiceNumber;

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
  final List<InvoiceItemModel> invoiceItems;

  @HiveField(7)
  final Map<String, double> gstPercentage;

  @HiveField(8)
  final Map<String, double> otherCharges;

  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  @HiveField(9)
  final DateTime? dueDate;

  @HiveField(10)
  final String notes;

  @HiveField(11)
  final double totalAmount;

  @HiveField(12)
  final InvoiceStatus status;

  @HiveField(13)
  final double remainingBalance;

  @HiveField(14)
  final String companyId;

  @HiveField(15)
  final String finYear;

  InvoiceModel({
    this.id = '',
    this.invoiceNumber = 0,
    required this.type,
    required this.invoiceDate,
    this.partyId = '',
    this.partyName = '',
    this.invoiceItems = const [],
    this.gstPercentage = const {},
    this.otherCharges = const {},
    this.dueDate,
    this.notes = '',
    this.totalAmount = 0.0,
    required this.status,
    this.remainingBalance = 0.0,
    this.companyId = '',
    this.finYear = '',
  });

  factory InvoiceModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceModelToJson(this);

  InvoiceModel copyWith({
    String? id,
    int? invoiceNumber,
    InvoiceType? type,
    DateTime? invoiceDate,
    String? partyId,
    String? partyName,
    List<InvoiceItemModel>? invoiceItems,
    Map<String, double>? gstPercentage,
    Map<String, double>? otherCharges,
    DateTime? dueDate,
    String? notes,
    double? totalAmount,
    InvoiceStatus? status,
    double? remainingBalance,
    String? companyId,
    String? finYear,
  }) {
    return InvoiceModel(
      id: id ?? this.id,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
      type: type ?? this.type,
      invoiceDate: invoiceDate ?? this.invoiceDate,
      partyId: partyId ?? this.partyId,
      partyName: partyName ?? this.partyName,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      gstPercentage: gstPercentage ?? this.gstPercentage,
      otherCharges: otherCharges ?? this.otherCharges,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      companyId: companyId ?? this.companyId,
      finYear: finYear ?? this.finYear,
    );
  }

  @override
  String toString() {
    return 'InvoiceModel(id: $id, invoiceNumber: $invoiceNumber, type: $type, invoiceDate: $invoiceDate, partyId: $partyId, partyName: $partyName, invoiceItems: $invoiceItems, gstPercentage: $gstPercentage, otherCharges: $otherCharges, dueDate: $dueDate, notes: $notes, totalAmount: $totalAmount, status: $status, remainingBalance: $remainingBalance, companyId: $companyId)';
  }
}
