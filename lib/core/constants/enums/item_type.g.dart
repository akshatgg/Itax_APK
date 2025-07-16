// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemTypeAdapter extends TypeAdapter<ItemType> {
  @override
  final int typeId = 4;

  @override
  ItemType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemType.item;
      case 1:
        return ItemType.service;
      default:
        return ItemType.item;
    }
  }

  @override
  void write(BinaryWriter writer, ItemType obj) {
    switch (obj) {
      case ItemType.item:
        writer.writeByte(0);
        break;
      case ItemType.service:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
