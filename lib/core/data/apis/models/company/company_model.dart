import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../shared/file_metadata.dart';

part 'company_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeConstants.companyModel)
class CompanyModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String companyName;
  @HiveField(2)
  final String companyEmail;
  @HiveField(3)
  final String companyPhone;
  @HiveField(4)
  final String companyAddress;
  @HiveField(5)
  final String companyState;
  @HiveField(6)
  final String companyPincode;
  @HiveField(7)
  final FileMetadata? companyImage;
  @HiveField(8)
  final String companyGstin;

  CompanyModel({
    this.id = '',
    this.companyName = '',
    this.companyEmail = '',
    this.companyPhone = '',
    this.companyAddress = '',
    this.companyState = '',
    this.companyPincode = '',
    this.companyImage,
    this.companyGstin = '',
  });

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);

  Map<String, dynamic> toJson() => _$CompanyModelToJson(this);

  CompanyModel copyWith({
    String? id,
    String? companyName,
    String? companyEmail,
    String? companyPhone,
    String? companyAddress,
    String? companyState,
    String? companyPincode,
    FileMetadata? companyImage,
    String? companyGstin,
  }) {
    return CompanyModel(
      id: id ?? this.id,
      companyName: companyName ?? this.companyName,
      companyEmail: companyEmail ?? this.companyEmail,
      companyPhone: companyPhone ?? this.companyPhone,
      companyAddress: companyAddress ?? this.companyAddress,
      companyState: companyState ?? this.companyState,
      companyPincode: companyPincode ?? this.companyPincode,
      companyImage: companyImage ?? this.companyImage,
      companyGstin: companyGstin ?? this.companyGstin,
    );
  }
}
