// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CompanyModelAdapter extends TypeAdapter<CompanyModel> {
  @override
  final int typeId = 15;

  @override
  CompanyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CompanyModel(
      id: fields[0] as String,
      companyName: fields[1] as String,
      companyEmail: fields[2] as String,
      companyPhone: fields[3] as String,
      companyAddress: fields[4] as String,
      companyState: fields[5] as String,
      companyPincode: fields[6] as String,
      companyImage: fields[7] as FileMetadata?,
      companyGstin: fields[8] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CompanyModel obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.companyName)
      ..writeByte(2)
      ..write(obj.companyEmail)
      ..writeByte(3)
      ..write(obj.companyPhone)
      ..writeByte(4)
      ..write(obj.companyAddress)
      ..writeByte(5)
      ..write(obj.companyState)
      ..writeByte(6)
      ..write(obj.companyPincode)
      ..writeByte(7)
      ..write(obj.companyImage)
      ..writeByte(8)
      ..write(obj.companyGstin);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CompanyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CompanyModel _$CompanyModelFromJson(Map<String, dynamic> json) => CompanyModel(
      id: json['id'] as String? ?? '',
      companyName: json['companyName'] as String? ?? '',
      companyEmail: json['companyEmail'] as String? ?? '',
      companyPhone: json['companyPhone'] as String? ?? '',
      companyAddress: json['companyAddress'] as String? ?? '',
      companyState: json['companyState'] as String? ?? '',
      companyPincode: json['companyPincode'] as String? ?? '',
      companyImage: json['companyImage'] == null
          ? null
          : FileMetadata.fromJson(json['companyImage'] as Map<String, dynamic>),
      companyGstin: json['companyGstin'] as String? ?? '',
    );

Map<String, dynamic> _$CompanyModelToJson(CompanyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'companyName': instance.companyName,
      'companyEmail': instance.companyEmail,
      'companyPhone': instance.companyPhone,
      'companyAddress': instance.companyAddress,
      'companyState': instance.companyState,
      'companyPincode': instance.companyPincode,
      'companyImage': instance.companyImage?.toJson(),
      'companyGstin': instance.companyGstin,
    };
