import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../constants/enums/invoice_type.dart';
import '../../../../utils/date_time_parser.dart';
import 'invoice_item_model.dart';

part 'notes_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeConstants.notesModel)
class NotesModel {
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
  final String returnReason;

  @HiveField(13)
  final String selectedInvoiceId;

  @HiveField(14)
  final String companyId;

  @HiveField(15)
  final String finYear;

  NotesModel({
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
    this.returnReason = '',
    this.selectedInvoiceId = '',
    this.companyId = '',
    this.finYear = '',
  });

  NotesModel copyWith({
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
    String? returnReason,
    String? selectedInvoiceId,
    String? companyId,
    String? finYear,
  }) {
    return NotesModel(
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
      returnReason: returnReason ?? this.returnReason,
      selectedInvoiceId: selectedInvoiceId ?? this.selectedInvoiceId,
      companyId: companyId ?? this.companyId,
      finYear: finYear ?? this.finYear,
    );
  }

  factory NotesModel.fromJson(Map<String, dynamic> json) =>
      _$NotesModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotesModelToJson(this);
}
