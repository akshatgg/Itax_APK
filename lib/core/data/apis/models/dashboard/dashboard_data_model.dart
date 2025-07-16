import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../constants/enums/invoice_type.dart';

part 'dashboard_data_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeConstants.dashboardDataModel)
class DashboardDataModel {
  @HiveField(0)
  final Map<int, double> currentYearSalesAmount;
  @HiveField(1)
  final Map<int, double> currentYearPurchaseAmount;
  @HiveField(2)
  final double currentYearSalesAmountTotal;
  @HiveField(3)
  final double currentYearPurchaseAmountTotal;

  @HiveField(4)
  final Map<int, double> previousYearSalesAmount;
  @HiveField(5)
  final Map<int, double> previousYearPurchaseAmount;
  @HiveField(6)
  final double previousYearSalesAmountTotal;
  @HiveField(7)
  final double previousYearPurchaseAmountTotal;

  @HiveField(8)
  final Map<int, double> currentMonthSalesAmount;
  @HiveField(9)
  final double currentMonthSalesAmountTotal;
  @HiveField(10)
  final Map<int, double> currentMonthPurchaseAmount;
  @HiveField(11)
  final double currentMonthPurchaseAmountTotal;

  @HiveField(12)
  final Map<int, double> currentWeekSalesAmount;
  @HiveField(13)
  final double currentWeekSalesAmountTotal;
  @HiveField(14)
  final Map<int, double> currentWeekPurchaseAmount;
  @HiveField(15)
  final double currentWeekPurchaseAmountTotal;
  @HiveField(16)
  final String id;
  @HiveField(17)
  final Map<InvoiceType, double> currentYearVolume;
  @HiveField(18)
  final Map<InvoiceType, double> previousYearVolume;
  @HiveField(19)
  final Map<InvoiceType, double> currentMonthVolume;
  @HiveField(20)
  final Map<InvoiceType, double> currentWeekVolume;

  @HiveField(21)
  final String companyId;

  DashboardDataModel({
    this.currentYearSalesAmount = const {},
    this.currentYearPurchaseAmount = const {},
    this.previousYearSalesAmount = const {},
    this.previousYearPurchaseAmount = const {},
    this.currentMonthSalesAmount = const {},
    this.currentMonthPurchaseAmount = const {},
    this.currentWeekSalesAmount = const {},
    this.currentWeekPurchaseAmount = const {},
    this.id = '',
    this.currentYearSalesAmountTotal = 0,
    this.currentYearPurchaseAmountTotal = 0,
    this.previousYearSalesAmountTotal = 0,
    this.previousYearPurchaseAmountTotal = 0,
    this.currentMonthSalesAmountTotal = 0,
    this.currentMonthPurchaseAmountTotal = 0,
    this.currentWeekSalesAmountTotal = 0,
    this.currentWeekPurchaseAmountTotal = 0,
    this.currentYearVolume = const {},
    this.previousYearVolume = const {},
    this.currentMonthVolume = const {},
    this.currentWeekVolume = const {},
    this.companyId = '',
  });

  @override
  String toString() {
    return 'DashboardDataModel(currentYearSalesAmount: $currentYearSalesAmount, currentYearPurchaseAmount: $currentYearPurchaseAmount, previousYearSalesAmount: $previousYearSalesAmount, previousYearPurchaseAmount: $previousYearPurchaseAmount, currentMonthSalesAmount: $currentMonthSalesAmount, currentMonthPurchaseAmount: $currentMonthPurchaseAmount, currentWeekSalesAmount: $currentWeekSalesAmount, currentWeekPurchaseAmount: $currentWeekPurchaseAmount)';
  }

  DashboardDataModel copyWith({
    Map<int, double>? currentYearSalesAmount,
    Map<int, double>? currentYearPurchaseAmount,
    Map<int, double>? previousYearSalesAmount,
    Map<int, double>? previousYearPurchaseAmount,
    Map<int, double>? currentMonthSalesAmount,
    Map<int, double>? currentMonthPurchaseAmount,
    Map<int, double>? currentWeekSalesAmount,
    Map<int, double>? currentWeekPurchaseAmount,
    double? currentYearSalesAmountTotal,
    double? currentYearPurchaseAmountTotal,
    double? previousYearSalesAmountTotal,
    double? previousYearPurchaseAmountTotal,
    double? currentMonthSalesAmountTotal,
    double? currentMonthPurchaseAmountTotal,
    double? currentWeekSalesAmountTotal,
    double? currentWeekPurchaseAmountTotal,
    String? id,
    Map<InvoiceType, double>? currentYearVolume,
    Map<InvoiceType, double>? previousYearVolume,
    Map<InvoiceType, double>? currentMonthVolume,
    Map<InvoiceType, double>? currentWeekVolume,
    String? companyId,
  }) {
    return DashboardDataModel(
      currentYearSalesAmount:
          currentYearSalesAmount ?? this.currentYearSalesAmount,
      currentYearPurchaseAmount:
          currentYearPurchaseAmount ?? this.currentYearPurchaseAmount,
      previousYearSalesAmount:
          previousYearSalesAmount ?? this.previousYearSalesAmount,
      previousYearPurchaseAmount:
          previousYearPurchaseAmount ?? this.previousYearPurchaseAmount,
      currentMonthSalesAmount:
          currentMonthSalesAmount ?? this.currentMonthSalesAmount,
      currentMonthPurchaseAmount:
          currentMonthPurchaseAmount ?? this.currentMonthPurchaseAmount,
      currentWeekSalesAmount:
          currentWeekSalesAmount ?? this.currentWeekSalesAmount,
      currentWeekPurchaseAmount:
          currentWeekPurchaseAmount ?? this.currentWeekPurchaseAmount,
      id: id ?? this.id,
      currentYearSalesAmountTotal:
          currentYearSalesAmountTotal ?? this.currentYearSalesAmountTotal,
      currentYearPurchaseAmountTotal:
          currentYearPurchaseAmountTotal ?? this.currentYearPurchaseAmountTotal,
      previousYearSalesAmountTotal:
          previousYearSalesAmountTotal ?? this.previousYearSalesAmountTotal,
      previousYearPurchaseAmountTotal: previousYearPurchaseAmountTotal ??
          this.previousYearPurchaseAmountTotal,
      currentMonthSalesAmountTotal:
          currentMonthSalesAmountTotal ?? this.currentMonthSalesAmountTotal,
      currentMonthPurchaseAmountTotal: currentMonthPurchaseAmountTotal ??
          this.currentMonthPurchaseAmountTotal,
      currentWeekSalesAmountTotal:
          currentWeekSalesAmountTotal ?? this.currentWeekSalesAmountTotal,
      currentWeekPurchaseAmountTotal:
          currentWeekPurchaseAmountTotal ?? this.currentWeekPurchaseAmountTotal,
      currentYearVolume: currentYearVolume ?? this.currentYearVolume,
      previousYearVolume: previousYearVolume ?? this.previousYearVolume,
      currentMonthVolume: currentMonthVolume ?? this.currentMonthVolume,
      currentWeekVolume: currentWeekVolume ?? this.currentWeekVolume,
      companyId: companyId ?? this.companyId,
    );
  }

  factory DashboardDataModel.fromJson(Map<String, dynamic> json) =>
      _$DashboardDataModelFromJson(json);

  Map<String, dynamic> toJson() => _$DashboardDataModelToJson(this);
}
