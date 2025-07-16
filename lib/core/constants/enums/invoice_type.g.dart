// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_type.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceTypeAdapter extends TypeAdapter<InvoiceType> {
  @override
  final int typeId = 9;

  @override
  InvoiceType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return InvoiceType.sales;
      case 1:
        return InvoiceType.purchase;
      case 2:
        return InvoiceType.salesReturn;
      case 3:
        return InvoiceType.purchaseReturn;
      case 4:
        return InvoiceType.creditNote;
      case 5:
        return InvoiceType.debitNote;
      case 6:
        return InvoiceType.payment;
      case 7:
        return InvoiceType.receipt;
      case 8:
        return InvoiceType.eInvoice;
      case 9:
        return InvoiceType.eWay;
      default:
        return InvoiceType.sales;
    }
  }

  @override
  void write(BinaryWriter writer, InvoiceType obj) {
    switch (obj) {
      case InvoiceType.sales:
        writer.writeByte(0);
        break;
      case InvoiceType.purchase:
        writer.writeByte(1);
        break;
      case InvoiceType.salesReturn:
        writer.writeByte(2);
        break;
      case InvoiceType.purchaseReturn:
        writer.writeByte(3);
        break;
      case InvoiceType.creditNote:
        writer.writeByte(4);
        break;
      case InvoiceType.debitNote:
        writer.writeByte(5);
        break;
      case InvoiceType.payment:
        writer.writeByte(6);
        break;
      case InvoiceType.receipt:
        writer.writeByte(7);
        break;
      case InvoiceType.eInvoice:
        writer.writeByte(8);
        break;
      case InvoiceType.eWay:
        writer.writeByte(9);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
