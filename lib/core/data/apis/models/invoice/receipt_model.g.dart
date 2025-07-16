// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReceiptModelAdapter extends TypeAdapter<ReceiptModel> {
  @override
  final int typeId = 13;

  @override
  ReceiptModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReceiptModel(
      id: fields[0] as String,
      receiptNumber: fields[1] as int,
      type: fields[2] as InvoiceType,
      invoiceDate: fields[3] as DateTime,
      partyId: fields[4] as String,
      partyName: fields[5] as String,
      invoiceIds: (fields[6] as Map).cast<String, double>(),
      notes: fields[7] as String,
      totalAmount: fields[8] as double,
      bankName: fields[9] as String,
      accountNumber: fields[10] as String,
      ifscCode: fields[11] as String,
      selectDate: fields[13] as String?,
      checkNumber: fields[14] as String,
      paymentMethod: fields[12] as String,
      upiId: fields[15] as String,
      companyId: fields[16] as String,
      finYear: fields[17] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ReceiptModel obj) {
    writer
      ..writeByte(18)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.receiptNumber)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.invoiceDate)
      ..writeByte(4)
      ..write(obj.partyId)
      ..writeByte(5)
      ..write(obj.partyName)
      ..writeByte(6)
      ..write(obj.invoiceIds)
      ..writeByte(7)
      ..write(obj.notes)
      ..writeByte(8)
      ..write(obj.totalAmount)
      ..writeByte(9)
      ..write(obj.bankName)
      ..writeByte(10)
      ..write(obj.accountNumber)
      ..writeByte(11)
      ..write(obj.ifscCode)
      ..writeByte(12)
      ..write(obj.paymentMethod)
      ..writeByte(13)
      ..write(obj.selectDate)
      ..writeByte(14)
      ..write(obj.checkNumber)
      ..writeByte(15)
      ..write(obj.upiId)
      ..writeByte(16)
      ..write(obj.companyId)
      ..writeByte(17)
      ..write(obj.finYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReceiptModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceiptModel _$ReceiptModelFromJson(Map<String, dynamic> json) => ReceiptModel(
      id: json['id'] as String? ?? '',
      receiptNumber: (json['receiptNumber'] as num?)?.toInt() ?? 0,
      type: $enumDecode(_$InvoiceTypeEnumMap, json['type']),
      invoiceDate:
          DateTimeParser.dateTimeFromJson(json['invoiceDate'] as String?),
      partyId: json['partyId'] as String? ?? '',
      partyName: json['partyName'] as String? ?? '',
      invoiceIds: (json['invoiceIds'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      notes: json['notes'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      bankName: json['bankName'] as String? ?? '',
      accountNumber: json['accountNumber'] as String? ?? '',
      ifscCode: json['ifscCode'] as String? ?? '',
      selectDate: json['selectDate'] as String? ?? '',
      checkNumber: json['checkNumber'] as String? ?? '',
      paymentMethod: json['paymentMethod'] as String? ?? '',
      upiId: json['upiId'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      finYear: json['finYear'] as String? ?? '',
    );

Map<String, dynamic> _$ReceiptModelToJson(ReceiptModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'receiptNumber': instance.receiptNumber,
      'type': _$InvoiceTypeEnumMap[instance.type]!,
      'invoiceDate': DateTimeParser.dateTimeToJson(instance.invoiceDate),
      'partyId': instance.partyId,
      'partyName': instance.partyName,
      'invoiceIds': instance.invoiceIds,
      'notes': instance.notes,
      'totalAmount': instance.totalAmount,
      'bankName': instance.bankName,
      'accountNumber': instance.accountNumber,
      'ifscCode': instance.ifscCode,
      'paymentMethod': instance.paymentMethod,
      'selectDate': instance.selectDate,
      'checkNumber': instance.checkNumber,
      'upiId': instance.upiId,
      'companyId': instance.companyId,
      'finYear': instance.finYear,
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
