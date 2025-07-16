// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartyModelAdapter extends TypeAdapter<PartyModel> {
  @override
  final int typeId = 2;

  @override
  PartyModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PartyModel(
      id: fields[0] as String,
      partyName: fields[1] as String,
      type: fields[2] as PartyType,
      gstin: fields[3] as String?,
      pan: fields[4] as String?,
      businessAddress: fields[9] as String?,
      email: fields[7] as String?,
      phone: fields[8] as String?,
      city: fields[17] as String?,
      pinCode: fields[5] as String?,
      state: fields[6] as String?,
      invoices: (fields[10] as List).cast<InvoiceModel>(),
      createdAt: fields[11] as DateTime,
      updatedAt: fields[12] as DateTime,
      totalDebit: fields[13] as double,
      totalCredit: fields[14] as double,
      outstandingBalance: fields[15] as double,
      status: fields[16] as String?,
      companyId: fields[18] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, PartyModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.partyName)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.gstin)
      ..writeByte(4)
      ..write(obj.pan)
      ..writeByte(5)
      ..write(obj.pinCode)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.phone)
      ..writeByte(9)
      ..write(obj.businessAddress)
      ..writeByte(10)
      ..write(obj.invoices)
      ..writeByte(11)
      ..write(obj.createdAt)
      ..writeByte(12)
      ..write(obj.updatedAt)
      ..writeByte(13)
      ..write(obj.totalDebit)
      ..writeByte(14)
      ..write(obj.totalCredit)
      ..writeByte(15)
      ..write(obj.outstandingBalance)
      ..writeByte(16)
      ..write(obj.status)
      ..writeByte(17)
      ..write(obj.city)
      ..writeByte(18)
      ..write(obj.companyId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PartyModel _$PartyModelFromJson(Map<String, dynamic> json) => PartyModel(
      id: json['id'] as String? ?? '',
      partyName: json['partyName'] as String? ?? '',
      type: $enumDecode(_$PartyTypeEnumMap, json['type']),
      gstin: json['gstin'] as String?,
      pan: json['pan'] as String?,
      businessAddress: json['businessAddress'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      city: json['city'] as String?,
      pinCode: json['pinCode'] as String?,
      state: json['state'] as String?,
      invoices: (json['invoices'] as List<dynamic>?)
              ?.map((e) => InvoiceModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTimeParser.dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: DateTimeParser.dateTimeFromJson(json['updatedAt'] as String?),
      totalDebit: (json['totalDebit'] as num?)?.toDouble() ?? 0,
      totalCredit: (json['totalCredit'] as num?)?.toDouble() ?? 0,
      outstandingBalance: (json['outstandingBalance'] as num?)?.toDouble() ?? 0,
      status: json['status'] as String?,
      companyId: json['companyId'] as String?,
    );

Map<String, dynamic> _$PartyModelToJson(PartyModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'partyName': instance.partyName,
      'type': _$PartyTypeEnumMap[instance.type]!,
      'gstin': instance.gstin,
      'pan': instance.pan,
      'pinCode': instance.pinCode,
      'state': instance.state,
      'email': instance.email,
      'phone': instance.phone,
      'businessAddress': instance.businessAddress,
      'invoices': instance.invoices,
      'createdAt': DateTimeParser.dateTimeToJson(instance.createdAt),
      'updatedAt': DateTimeParser.dateTimeToJson(instance.updatedAt),
      'totalDebit': instance.totalDebit,
      'totalCredit': instance.totalCredit,
      'outstandingBalance': instance.outstandingBalance,
      'status': instance.status,
      'city': instance.city,
      'companyId': instance.companyId,
    };

const _$PartyTypeEnumMap = {
  PartyType.customer: 'customer',
  PartyType.supplier: 'supplier',
};
