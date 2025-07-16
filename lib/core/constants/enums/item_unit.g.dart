// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_unit.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemUnitAdapter extends TypeAdapter<ItemUnit> {
  @override
  final int typeId = 1;

  @override
  ItemUnit read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return ItemUnit.pieces;
      case 1:
        return ItemUnit.grams;
      case 2:
        return ItemUnit.kilograms;
      case 3:
        return ItemUnit.liters;
      case 4:
        return ItemUnit.milliliters;
      case 5:
        return ItemUnit.meters;
      case 6:
        return ItemUnit.centimeters;
      case 7:
        return ItemUnit.inches;
      case 8:
        return ItemUnit.feet;
      case 9:
        return ItemUnit.squareMeters;
      case 10:
        return ItemUnit.squareFeet;
      case 11:
        return ItemUnit.cubicMeters;
      case 12:
        return ItemUnit.cubicFeet;
      case 13:
        return ItemUnit.dozen;
      case 14:
        return ItemUnit.pack;
      case 15:
        return ItemUnit.carton;
      case 16:
        return ItemUnit.box;
      case 17:
        return ItemUnit.roll;
      case 18:
        return ItemUnit.bundle;
      case 19:
        return ItemUnit.pair;
      case 20:
        return ItemUnit.set;
      case 21:
        return ItemUnit.number;
      case 22:
        return ItemUnit.kiloLiters;
      case 23:
        return ItemUnit.usGallons;
      default:
        return ItemUnit.pieces;
    }
  }

  @override
  void write(BinaryWriter writer, ItemUnit obj) {
    switch (obj) {
      case ItemUnit.pieces:
        writer.writeByte(0);
        break;
      case ItemUnit.grams:
        writer.writeByte(1);
        break;
      case ItemUnit.kilograms:
        writer.writeByte(2);
        break;
      case ItemUnit.liters:
        writer.writeByte(3);
        break;
      case ItemUnit.milliliters:
        writer.writeByte(4);
        break;
      case ItemUnit.meters:
        writer.writeByte(5);
        break;
      case ItemUnit.centimeters:
        writer.writeByte(6);
        break;
      case ItemUnit.inches:
        writer.writeByte(7);
        break;
      case ItemUnit.feet:
        writer.writeByte(8);
        break;
      case ItemUnit.squareMeters:
        writer.writeByte(9);
        break;
      case ItemUnit.squareFeet:
        writer.writeByte(10);
        break;
      case ItemUnit.cubicMeters:
        writer.writeByte(11);
        break;
      case ItemUnit.cubicFeet:
        writer.writeByte(12);
        break;
      case ItemUnit.dozen:
        writer.writeByte(13);
        break;
      case ItemUnit.pack:
        writer.writeByte(14);
        break;
      case ItemUnit.carton:
        writer.writeByte(15);
        break;
      case ItemUnit.box:
        writer.writeByte(16);
        break;
      case ItemUnit.roll:
        writer.writeByte(17);
        break;
      case ItemUnit.bundle:
        writer.writeByte(18);
        break;
      case ItemUnit.pair:
        writer.writeByte(19);
        break;
      case ItemUnit.set:
        writer.writeByte(20);
        break;
      case ItemUnit.number:
        writer.writeByte(21);
        break;
      case ItemUnit.kiloLiters:
        writer.writeByte(22);
        break;
      case ItemUnit.usGallons:
        writer.writeByte(23);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemUnitAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
