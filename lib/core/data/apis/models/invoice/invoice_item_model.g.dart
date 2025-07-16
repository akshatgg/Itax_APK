// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceItemModelAdapter extends TypeAdapter<InvoiceItemModel> {
  @override
  final int typeId = 8;

  @override
  InvoiceItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceItemModel(
      id: fields[0] as String,
      itemId: fields[1] as String?,
      quantity: fields[2] as int,
      discount: fields[3] as double,
      taxPercent: fields[4] as double,
      rate: fields[5] as double,
      placeOfSupply: fields[6] as String,
      itemName: fields[7] as String,
      description: fields[8] as String,
      finalAmount: fields[9] as double,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceItemModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemId)
      ..writeByte(2)
      ..write(obj.quantity)
      ..writeByte(3)
      ..write(obj.discount)
      ..writeByte(4)
      ..write(obj.taxPercent)
      ..writeByte(5)
      ..write(obj.rate)
      ..writeByte(6)
      ..write(obj.placeOfSupply)
      ..writeByte(7)
      ..write(obj.itemName)
      ..writeByte(8)
      ..write(obj.description)
      ..writeByte(9)
      ..write(obj.finalAmount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceItemModel _$InvoiceItemModelFromJson(Map<String, dynamic> json) =>
    InvoiceItemModel(
      id: json['id'] as String? ?? '',
      itemId: json['itemId'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      discount: (json['discount'] as num?)?.toDouble() ?? 0.0,
      taxPercent: (json['taxPercent'] as num?)?.toDouble() ?? 0.0,
      rate: (json['rate'] as num?)?.toDouble() ?? 0.0,
      placeOfSupply: json['placeOfSupply'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      description: json['description'] as String? ?? '',
      finalAmount: (json['finalAmount'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$InvoiceItemModelToJson(InvoiceItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'itemId': instance.itemId,
      'quantity': instance.quantity,
      'discount': instance.discount,
      'taxPercent': instance.taxPercent,
      'rate': instance.rate,
      'placeOfSupply': instance.placeOfSupply,
      'itemName': instance.itemName,
      'description': instance.description,
      'finalAmount': instance.finalAmount,
    };
