// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_book.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DayBookAdapter extends TypeAdapter<DayBook> {
  @override
  final int typeId = 11;

  @override
  DayBook read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DayBook(
      id: fields[0] as String,
      date: fields[1] as DateTime,
      invoices: (fields[2] as List).cast<DayBookInvoice>(),
      companyId: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DayBook obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.invoices)
      ..writeByte(3)
      ..write(obj.companyId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DayBookAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DayBook _$DayBookFromJson(Map<String, dynamic> json) => DayBook(
      id: json['id'] as String,
      date: DateTimeParser.dateTimeFromJson(json['date'] as String?),
      invoices: (json['invoices'] as List<dynamic>)
          .map((e) => DayBookInvoice.fromJson(e as Map<String, dynamic>))
          .toList(),
      companyId: json['companyId'] as String,
    );

Map<String, dynamic> _$DayBookToJson(DayBook instance) => <String, dynamic>{
      'id': instance.id,
      'date': DateTimeParser.dateTimeToJson(instance.date),
      'invoices': instance.invoices.map((e) => e.toJson()).toList(),
      'companyId': instance.companyId,
    };
