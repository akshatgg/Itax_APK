import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';

part 'invoice_item_model.g.dart';

@JsonSerializable()
@HiveType(typeId: HiveTypeConstants.invoiceItemModel)
class InvoiceItemModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String? itemId;
  @HiveField(2)
  final int quantity;
  @HiveField(3)
  final double discount;
  @HiveField(4)
  final double taxPercent;
  @HiveField(5)
  final double rate;
  @HiveField(6)
  final String placeOfSupply;
  @HiveField(7)
  final String itemName;
  @HiveField(8)
  final String description;
  @HiveField(9)
  final double finalAmount;

  InvoiceItemModel({
    this.id = '',
    this.itemId,
    this.quantity = 0,
    this.discount = 0.0,
    this.taxPercent = 0.0,
    this.rate = 0.0,
    this.placeOfSupply = '',
    this.itemName = '',
    this.description = '',
    this.finalAmount = 0.0,
  });

  factory InvoiceItemModel.fromJson(Map<String, dynamic> json) =>
      _$InvoiceItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$InvoiceItemModelToJson(this);

  InvoiceItemModel copyWith({
    String? id,
    String? itemId,
    int? quantity,
    double? discount,
    double? taxPercent,
    double? rate,
    String? placeOfSupply,
    String? itemName,
    String? description,
    double? finalAmount,
  }) {
    return InvoiceItemModel(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      quantity: quantity ?? this.quantity,
      discount: discount ?? this.discount,
      taxPercent: taxPercent ?? this.taxPercent,
      rate: rate ?? this.rate,
      placeOfSupply: placeOfSupply ?? this.placeOfSupply,
      itemName: itemName ?? this.itemName,
      description: description ?? this.description,
      finalAmount: finalAmount ?? this.finalAmount,
    );
  }

  @override
  String toString() {
    return 'InvoiceItemModel(id: $id, itemId: $itemId, quantity: $quantity, discount: $discount, taxPercent: $taxPercent, rate: $rate, placeOfSupply: $placeOfSupply, itemName: $itemName, description: $description)';
  }
}
