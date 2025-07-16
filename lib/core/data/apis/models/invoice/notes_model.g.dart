// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notes_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NotesModelAdapter extends TypeAdapter<NotesModel> {
  @override
  final int typeId = 14;

  @override
  NotesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotesModel(
      id: fields[0] as String,
      invoiceNumber: fields[1] as int,
      type: fields[2] as InvoiceType,
      invoiceDate: fields[3] as DateTime,
      partyId: fields[4] as String,
      partyName: fields[5] as String,
      invoiceItems: (fields[6] as List).cast<InvoiceItemModel>(),
      gstPercentage: (fields[7] as Map).cast<String, double>(),
      otherCharges: (fields[8] as Map).cast<String, double>(),
      dueDate: fields[9] as DateTime?,
      notes: fields[10] as String,
      totalAmount: fields[11] as double,
      returnReason: fields[12] as String,
      selectedInvoiceId: fields[13] as String,
      companyId: fields[14] as String,
      finYear: fields[15] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NotesModel obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.invoiceNumber)
      ..writeByte(2)
      ..write(obj.type)
      ..writeByte(3)
      ..write(obj.invoiceDate)
      ..writeByte(4)
      ..write(obj.partyId)
      ..writeByte(5)
      ..write(obj.partyName)
      ..writeByte(6)
      ..write(obj.invoiceItems)
      ..writeByte(7)
      ..write(obj.gstPercentage)
      ..writeByte(8)
      ..write(obj.otherCharges)
      ..writeByte(9)
      ..write(obj.dueDate)
      ..writeByte(10)
      ..write(obj.notes)
      ..writeByte(11)
      ..write(obj.totalAmount)
      ..writeByte(12)
      ..write(obj.returnReason)
      ..writeByte(13)
      ..write(obj.selectedInvoiceId)
      ..writeByte(14)
      ..write(obj.companyId)
      ..writeByte(15)
      ..write(obj.finYear);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NotesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotesModel _$NotesModelFromJson(Map<String, dynamic> json) => NotesModel(
      id: json['id'] as String? ?? '',
      invoiceNumber: (json['invoiceNumber'] as num?)?.toInt() ?? 0,
      type: $enumDecode(_$InvoiceTypeEnumMap, json['type']),
      invoiceDate:
          DateTimeParser.dateTimeFromJson(json['invoiceDate'] as String?),
      partyId: json['partyId'] as String? ?? '',
      partyName: json['partyName'] as String? ?? '',
      invoiceItems: (json['invoiceItems'] as List<dynamic>?)
              ?.map((e) => InvoiceItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      gstPercentage: (json['gstPercentage'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      otherCharges: (json['otherCharges'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toDouble()),
          ) ??
          const {},
      dueDate: DateTimeParser.dateTimeFromJson(json['dueDate'] as String?),
      notes: json['notes'] as String? ?? '',
      totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0.0,
      returnReason: json['returnReason'] as String? ?? '',
      selectedInvoiceId: json['selectedInvoiceId'] as String? ?? '',
      companyId: json['companyId'] as String? ?? '',
      finYear: json['finYear'] as String? ?? '',
    );

Map<String, dynamic> _$NotesModelToJson(NotesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'invoiceNumber': instance.invoiceNumber,
      'type': _$InvoiceTypeEnumMap[instance.type]!,
      'invoiceDate': DateTimeParser.dateTimeToJson(instance.invoiceDate),
      'partyId': instance.partyId,
      'partyName': instance.partyName,
      'invoiceItems': instance.invoiceItems.map((e) => e.toJson()).toList(),
      'gstPercentage': instance.gstPercentage,
      'otherCharges': instance.otherCharges,
      'dueDate': DateTimeParser.dateTimeToJson(instance.dueDate),
      'notes': instance.notes,
      'totalAmount': instance.totalAmount,
      'returnReason': instance.returnReason,
      'selectedInvoiceId': instance.selectedInvoiceId,
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
