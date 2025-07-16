// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../constants/enums/party_type.dart';
import '../../../../utils/date_time_parser.dart';
import '../invoice/invoice_model.dart';

part 'party_model.g.dart';

@HiveType(typeId: HiveTypeConstants.partyModel)
@JsonSerializable()
class PartyModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String partyName;
  @HiveField(2)
  final PartyType type;
  @HiveField(3)
  final String? gstin;
  @HiveField(4)
  final String? pan;
  @HiveField(5)
  final String? pinCode;
  @HiveField(6)
  final String? state;
  @HiveField(7)
  final String? email;
  @HiveField(8)
  final String? phone;
  @HiveField(9)
  final String? businessAddress;
  @HiveField(10)
  final List<InvoiceModel> invoices;
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  @HiveField(11)
  final DateTime createdAt;
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  @HiveField(12)
  final DateTime updatedAt;
  @HiveField(13)
  final double totalDebit;
  @HiveField(14)
  final double totalCredit;
  @HiveField(15)
  final double outstandingBalance;
  @HiveField(16)
  final String? status;
  @HiveField(17)
  final String? city;
  @HiveField(18)
  final String? companyId;

  PartyModel({
    this.id = '',
    this.partyName = '',
    required this.type,
    this.gstin,
    this.pan,
    this.businessAddress,
    this.email,
    this.phone,
    this.city,
    this.pinCode,
    this.state,
    this.invoices = const [],
    required this.createdAt,
    required this.updatedAt,
    this.totalDebit = 0,
    this.totalCredit = 0,
    this.outstandingBalance = 0,
    this.status,
    this.companyId,
  });

  factory PartyModel.fromJson(Map<String, dynamic> json) =>
      _$PartyModelFromJson(json);

  Map<String, dynamic> toJson() => _$PartyModelToJson(this);

  PartyModel copyWith({
    String? id,
    String? partyName,
    PartyType? type,
    String? gstin,
    String? pan,
    String? state,
    String? city,
    String? email,
    String? phone,
    String? businessAddress,
    List<InvoiceModel>? invoices,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? totalDebit,
    double? totalCredit,
    double? outstandingBalance,
    String? status,
    String? pinCode,
    String? companyId,
  }) {
    return PartyModel(
      id: id ?? this.id,
      partyName: partyName ?? this.partyName,
      type: type ?? this.type,
      gstin: gstin ?? this.gstin,
      pan: pan ?? this.pan,
      state: state ?? this.state,
      city: city ?? this.city,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      businessAddress: businessAddress ?? this.businessAddress,
      invoices: invoices ?? this.invoices,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      totalDebit: totalDebit ?? this.totalDebit,
      totalCredit: totalCredit ?? this.totalCredit,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      status: status ?? this.status,
      pinCode: pinCode ?? this.pinCode,
      companyId: companyId ?? this.companyId,
    );
  }
}
