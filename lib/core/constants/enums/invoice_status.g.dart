// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_status.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceStatusAdapter extends TypeAdapter<InvoiceStatus> {
  @override
  final int typeId = 10;

  @override
  InvoiceStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InvoiceStatus.unpaid;
      case 1:
        return InvoiceStatus.paid;
      case 2:
        return InvoiceStatus.overdue;
      case 3:
        return InvoiceStatus.partiallyPaid;
      default:
        return InvoiceStatus.unpaid;
    }
  }

  @override
  void write(BinaryWriter writer, InvoiceStatus obj) {
    switch (obj) {
      case InvoiceStatus.unpaid:
        writer.writeByte(0);
        break;
      case InvoiceStatus.paid:
        writer.writeByte(1);
        break;
      case InvoiceStatus.overdue:
        writer.writeByte(2);
        break;
      case InvoiceStatus.partiallyPaid:
        writer.writeByte(3);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceStatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
