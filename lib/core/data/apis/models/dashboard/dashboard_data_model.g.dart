// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_data_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DashboardDataModelAdapter extends TypeAdapter<DashboardDataModel> {
  @override
  final int typeId = 17;

  @override
  DashboardDataModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DashboardDataModel(
      currentYearSalesAmount: (fields[0] as Map).cast<int, double>(),
      currentYearPurchaseAmount: (fields[1] as Map).cast<int, double>(),
      previousYearSalesAmount: (fields[4] as Map).cast<int, double>(),
      previousYearPurchaseAmount: (fields[5] as Map).cast<int, double>(),
      currentMonthSalesAmount: (fields[8] as Map).cast<int, double>(),
      currentMonthPurchaseAmount: (fields[10] as Map).cast<int, double>(),
      currentWeekSalesAmount: (fields[12] as Map).cast<int, double>(),
      currentWeekPurchaseAmount: (fields[14] as Map).cast<int, double>(),
      id: fields[16] as String,
      currentYearSalesAmountTotal: fields[2] as double,
      currentYearPurchaseAmountTotal: fields[3] as double,
      previousYearSalesAmountTotal: fields[6] as double,
      previousYearPurchaseAmountTotal: fields[7] as double,
      currentMonthSalesAmountTotal: fields[9] as double,
      currentMonthPurchaseAmountTotal: fields[11] as double,
      currentWeekSalesAmountTotal: fields[13] as double,
      currentWeekPurchaseAmountTotal: fields[15] as double,
      currentYearVolume: (fields[17] as Map).cast<InvoiceType, double>(),
      previousYearVolume: (fields[18] as Map).cast<InvoiceType, double>(),
      currentMonthVolume: (fields[19] as Map).cast<InvoiceType, double>(),
      currentWeekVolume: (fields[20] as Map).cast<InvoiceType, double>(),
      companyId: fields[21] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DashboardDataModel obj) {
    writer
      ..writeByte(22)
      ..writeByte(0)
      ..write(obj.currentYearSalesAmount)
      ..writeByte(1)
      ..write(obj.currentYearPurchaseAmount)
      ..writeByte(2)
      ..write(obj.currentYearSalesAmountTotal)
      ..writeByte(3)
      ..write(obj.currentYearPurchaseAmountTotal)
      ..writeByte(4)
      ..write(obj.previousYearSalesAmount)
      ..writeByte(5)
      ..write(obj.previousYearPurchaseAmount)
      ..writeByte(6)
      ..write(obj.previousYearSalesAmountTotal)
      ..writeByte(7)
      ..write(obj.previousYearPurchaseAmountTotal)
      ..writeByte(8)
      ..write(obj.currentMonthSalesAmount)
      ..writeByte(9)
      ..write(obj.currentMonthSalesAmountTotal)
      ..writeByte(10)
      ..write(obj.currentMonthPurchaseAmount)
      ..writeByte(11)
      ..write(obj.currentMonthPurchaseAmountTotal)
      ..writeByte(12)
      ..write(obj.currentWeekSalesAmount)
      ..writeByte(13)
      ..write(obj.currentWeekSalesAmountTotal)
      ..writeByte(14)
      ..write(obj.currentWeekPurchaseAmount)
      ..writeByte(15)
      ..write(obj.currentWeekPurchaseAmountTotal)
      ..writeByte(16)
      ..write(obj.id)
      ..writeByte(17)
      ..write(obj.currentYearVolume)
      ..writeByte(18)
      ..write(obj.previousYearVolume)
      ..writeByte(19)
      ..write(obj.currentMonthVolume)
      ..writeByte(20)
      ..write(obj.currentWeekVolume)
      ..writeByte(21)
      ..write(obj.companyId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DashboardDataModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DashboardDataModel _$DashboardDataModelFromJson(Map<String, dynamic> json) =>
    DashboardDataModel(
      currentYearSalesAmount:
          (json['currentYearSalesAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      currentYearPurchaseAmount:
          (json['currentYearPurchaseAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      previousYearSalesAmount:
          (json['previousYearSalesAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      previousYearPurchaseAmount:
          (json['previousYearPurchaseAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      currentMonthSalesAmount:
          (json['currentMonthSalesAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      currentMonthPurchaseAmount:
          (json['currentMonthPurchaseAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      currentWeekSalesAmount:
          (json['currentWeekSalesAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      currentWeekPurchaseAmount:
          (json['currentWeekPurchaseAmount'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(int.parse(k), (e as num).toDouble()),
              ) ??
              const {},
      id: json['id'] as String? ?? '',
      currentYearSalesAmountTotal:
          (json['currentYearSalesAmountTotal'] as num?)?.toDouble() ?? 0,
      currentYearPurchaseAmountTotal:
          (json['currentYearPurchaseAmountTotal'] as num?)?.toDouble() ?? 0,
      previousYearSalesAmountTotal:
          (json['previousYearSalesAmountTotal'] as num?)?.toDouble() ?? 0,
      previousYearPurchaseAmountTotal:
          (json['previousYearPurchaseAmountTotal'] as num?)?.toDouble() ?? 0,
      currentMonthSalesAmountTotal:
          (json['currentMonthSalesAmountTotal'] as num?)?.toDouble() ?? 0,
      currentMonthPurchaseAmountTotal:
          (json['currentMonthPurchaseAmountTotal'] as num?)?.toDouble() ?? 0,
      currentWeekSalesAmountTotal:
          (json['currentWeekSalesAmountTotal'] as num?)?.toDouble() ?? 0,
      currentWeekPurchaseAmountTotal:
          (json['currentWeekPurchaseAmountTotal'] as num?)?.toDouble() ?? 0,
      currentYearVolume: (json['currentYearVolume'] as Map<String, dynamic>?)
              ?.map(
            (k, e) => MapEntry(
                $enumDecode(_$InvoiceTypeEnumMap, k), (e as num).toDouble()),
          ) ??
          const {},
      previousYearVolume: (json['previousYearVolume'] as Map<String, dynamic>?)
              ?.map(
            (k, e) => MapEntry(
                $enumDecode(_$InvoiceTypeEnumMap, k), (e as num).toDouble()),
          ) ??
          const {},
      currentMonthVolume: (json['currentMonthVolume'] as Map<String, dynamic>?)
              ?.map(
            (k, e) => MapEntry(
                $enumDecode(_$InvoiceTypeEnumMap, k), (e as num).toDouble()),
          ) ??
          const {},
      currentWeekVolume: (json['currentWeekVolume'] as Map<String, dynamic>?)
              ?.map(
            (k, e) => MapEntry(
                $enumDecode(_$InvoiceTypeEnumMap, k), (e as num).toDouble()),
          ) ??
          const {},
      companyId: json['companyId'] as String? ?? '',
    );

Map<String, dynamic> _$DashboardDataModelToJson(DashboardDataModel instance) =>
    <String, dynamic>{
      'currentYearSalesAmount': instance.currentYearSalesAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'currentYearPurchaseAmount': instance.currentYearPurchaseAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'currentYearSalesAmountTotal': instance.currentYearSalesAmountTotal,
      'currentYearPurchaseAmountTotal': instance.currentYearPurchaseAmountTotal,
      'previousYearSalesAmount': instance.previousYearSalesAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'previousYearPurchaseAmount': instance.previousYearPurchaseAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'previousYearSalesAmountTotal': instance.previousYearSalesAmountTotal,
      'previousYearPurchaseAmountTotal':
          instance.previousYearPurchaseAmountTotal,
      'currentMonthSalesAmount': instance.currentMonthSalesAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'currentMonthSalesAmountTotal': instance.currentMonthSalesAmountTotal,
      'currentMonthPurchaseAmount': instance.currentMonthPurchaseAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'currentMonthPurchaseAmountTotal':
          instance.currentMonthPurchaseAmountTotal,
      'currentWeekSalesAmount': instance.currentWeekSalesAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'currentWeekSalesAmountTotal': instance.currentWeekSalesAmountTotal,
      'currentWeekPurchaseAmount': instance.currentWeekPurchaseAmount
          .map((k, e) => MapEntry(k.toString(), e)),
      'currentWeekPurchaseAmountTotal': instance.currentWeekPurchaseAmountTotal,
      'id': instance.id,
      'currentYearVolume': instance.currentYearVolume
          .map((k, e) => MapEntry(_$InvoiceTypeEnumMap[k]!, e)),
      'previousYearVolume': instance.previousYearVolume
          .map((k, e) => MapEntry(_$InvoiceTypeEnumMap[k]!, e)),
      'currentMonthVolume': instance.currentMonthVolume
          .map((k, e) => MapEntry(_$InvoiceTypeEnumMap[k]!, e)),
      'currentWeekVolume': instance.currentWeekVolume
          .map((k, e) => MapEntry(_$InvoiceTypeEnumMap[k]!, e)),
      'companyId': instance.companyId,
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
