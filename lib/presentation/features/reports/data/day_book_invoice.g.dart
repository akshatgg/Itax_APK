// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_book_invoice.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayBookInvoiceAdapter extends TypeAdapter<DayBookInvoice> {
  @override
  final int typeId = 12;

  @override
  DayBookInvoice read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayBookInvoice(
      partyName: fields[0] as String,
      date: fields[1] as DateTime,
      invoiceNumber: fields[2] as int,
      totalAmount: fields[3] as double,
      invoiceType: fields[4] as InvoiceType,
      invoiceId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DayBookInvoice obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.partyName)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.invoiceNumber)
      ..writeByte(3)
      ..write(obj.totalAmount)
      ..writeByte(4)
      ..write(obj.invoiceType)
      ..writeByte(5)
      ..write(obj.invoiceId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayBookInvoiceAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayBookInvoice _$DayBookInvoiceFromJson(Map<String, dynamic> json) =>
    DayBookInvoice(
      partyName: json['partyName'] as String? ?? '',
      date: DateTime.parse(json['date'] as String),
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt() ?? 0,
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
      invoiceType: $enumDecode(_$InvoiceTypeEnumMap, json['invoiceType']),
      invoiceId: json['invoiceId'] as String? ?? '',
    );

Map<String, dynamic> _$DayBookInvoiceToJson(DayBookInvoice instance) =>
    <String, dynamic>{
      'partyName': instance.partyName,
      'date': instance.date.toIso8601String(),
      'invoiceNumber': instance.invoiceNumber,
      'totalAmount': instance.totalAmount,
      'invoiceType': _$InvoiceTypeEnumMap[instance.invoiceType]!,
      'invoiceId': instance.invoiceId,
    };

const _$InvoiceTypeEnumMap = {
  InvoiceType.sales: 'sales',
  InvoiceType.purchase: 'purchase',
  InvoiceType.salesReturn: 'sales_return',
  InvoiceType.purchaseReturn: 'purchase_return',
  InvoiceType.creditNote: 'credit_note',
  InvoiceType.debitNote: 'debit_note',
  InvoiceType.payment: 'payment',
  InvoiceType.receipt: 'receipt',
  InvoiceType.eInvoice: 'e_invoice',
  InvoiceType.eWay: 'e_way',
};
