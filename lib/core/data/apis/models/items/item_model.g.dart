// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 0;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      id: fields[0] as String,
      itemName: fields[1] as String,
      hsnCode: fields[2] as String?,
      unit: fields[3] as ItemUnit,
      itemType: fields[4] as ItemType,
      price: fields[5] as double,
      purchasePrice: fields[6] as double,
      gst: fields[7] as double?,
      openingStock: fields[8] as double?,
      taxExempted: fields[9] as bool,
      description: fields[10] as String?,
      closingStock: fields[11] as double,
      invoiceItems: (fields[12] as List).cast<InvoiceItemModel>(),
      createdAt: fields[13] as DateTime,
      updatedAt: fields[14] as DateTime,
      companyId: fields[15] as String,
      fileMetadata: fields[16] as FileMetadata?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.hsnCode)
      ..writeByte(3)
      ..write(obj.unit)
      ..writeByte(4)
      ..write(obj.itemType)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.purchasePrice)
      ..writeByte(7)
      ..write(obj.gst)
      ..writeByte(8)
      ..write(obj.openingStock)
      ..writeByte(9)
      ..write(obj.taxExempted)
      ..writeByte(10)
      ..write(obj.description)
      ..writeByte(11)
      ..write(obj.closingStock)
      ..writeByte(12)
      ..write(obj.invoiceItems)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.companyId)
      ..writeByte(16)
      ..write(obj.fileMetadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemModel _$ItemModelFromJson(Map<String, dynamic> json) => ItemModel(
      id: json['id'] as String? ?? '',
      itemName: json['itemName'] as String? ?? '',
      hsnCode: json['hsnCode'] as String?,
      unit: $enumDecode(_$ItemUnitEnumMap, json['unit']),
      itemType: $enumDecode(_$ItemTypeEnumMap, json['itemType']),
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      purchasePrice: (json['purchasePrice'] as num).toDouble(),
      gst: (json['gst'] as num?)?.toDouble(),
      openingStock: (json['openingStock'] as num?)?.toDouble(),
      taxExempted: json['taxExempted'] as bool? ?? false,
      description: json['description'] as String?,
      closingStock: (json['closingStock'] as num).toDouble(),
      invoiceItems: (json['invoiceItems'] as List<dynamic>?)
              ?.map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: DateTimeParser.dateTimeFromJson(json['createdAt'] as String?),
      updatedAt: DateTimeParser.dateTimeFromJson(json['updatedAt'] as String?),
      companyId: json['companyId'] as String? ?? '',
      fileMetadata: json['fileMetadata'] == null
          ? null
          : FileMetadata.fromJson(json['fileMetadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$ItemModelToJson(ItemModel instance) => <String, dynamic>{
      'id': instance.id,
      'itemName': instance.itemName,
      'hsnCode': instance.hsnCode,
      'unit': _$ItemUnitEnumMap[instance.unit]!,
      'itemType': _$ItemTypeEnumMap[instance.itemType]!,
      'price': instance.price,
      'purchasePrice': instance.purchasePrice,
      'gst': instance.gst,
      'openingStock': instance.openingStock,
      'taxExempted': instance.taxExempted,
      'description': instance.description,
      'closingStock': instance.closingStock,
      'invoiceItems': instance.invoiceItems.map((e) => e.toJson()).toList(),
      'createdAt': DateTimeParser.dateTimeToJson(instance.createdAt),
      'updatedAt': DateTimeParser.dateTimeToJson(instance.updatedAt),
      'companyId': instance.companyId,
      'fileMetadata': instance.fileMetadata?.toJson(),
    };

const _$ItemUnitEnumMap = {
  ItemUnit.pieces: 'pieces',
  ItemUnit.grams: 'grams',
  ItemUnit.kilograms: 'kilograms',
  ItemUnit.liters: 'liters',
  ItemUnit.milliliters: 'milliliters',
  ItemUnit.meters: 'meters',
  ItemUnit.centimeters: 'centimeters',
  ItemUnit.inches: 'inches',
  ItemUnit.feet: 'feet',
  ItemUnit.squareMeters: 'squareMeter',
  ItemUnit.squareFeet: 'squareFeet',
  ItemUnit.cubicMeters: 'cubicMeters',
  ItemUnit.cubicFeet: 'cubicFeet',
  ItemUnit.dozen: 'dozen',
  ItemUnit.pack: 'pack',
  ItemUnit.carton: 'carton',
  ItemUnit.box: 'box',
  ItemUnit.roll: 'roll',
  ItemUnit.bundle: 'bundle',
  ItemUnit.pair: 'pair',
  ItemUnit.set: 'set',
  ItemUnit.number: 'number',
  ItemUnit.kiloLiters: 'kiloLiters',
  ItemUnit.usGallons: 'usGallons',
};

const _$ItemTypeEnumMap = {
  ItemType.item: 'item',
  ItemType.service: 'service',
};
