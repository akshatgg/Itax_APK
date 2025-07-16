// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'party_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PartyTypeAdapter extends TypeAdapter<PartyType> {
  @override
  final int typeId = 5;

  @override
  PartyType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PartyType.customer;
      case 1:
        return PartyType.supplier;
      default:
        return PartyType.customer;
    }
  }

  @override
  void write(BinaryWriter writer, PartyType obj) {
    switch (obj) {
      case PartyType.customer:
        writer.writeByte(0);
        break;
      case PartyType.supplier:
        writer.writeByte(1);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PartyTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
