// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../../config/hive/hive_type_constants.dart';
import '../../../../constants/enums/item_type.dart';
import '../../../../constants/enums/item_unit.dart';
import '../../../../utils/date_time_parser.dart';
import '../invoice/invoice_item_model.dart';
import '../shared/file_metadata.dart';

part 'item_model.g.dart';

@JsonSerializable(explicitToJson: true)
@HiveType(typeId: HiveTypeConstants.itemModel)
class ItemModel {
  @HiveField(0)
  final String id;
  @HiveField(1)
  final String itemName;
  @HiveField(2)
  final String? hsnCode;
  @HiveField(3)
  final ItemUnit unit;
  @HiveField(4)
  final ItemType itemType;
  @HiveField(5)
  final double price;
  @HiveField(6)
  final double purchasePrice;
  @HiveField(7)
  final double? gst;
  @HiveField(8)
  final double? openingStock;
  @HiveField(9)
  final bool taxExempted;
  @HiveField(10)
  final String? description;
  @HiveField(11)
  final double closingStock;
  @HiveField(12)
  final List<InvoiceItemModel> invoiceItems;
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  @HiveField(13)
  final DateTime createdAt;
  @JsonKey(
    fromJson: DateTimeParser.dateTimeFromJson,
    toJson: DateTimeParser.dateTimeToJson,
  )
  @HiveField(14)
  final DateTime updatedAt;
  @HiveField(15)
  final String companyId;
  @HiveField(16)
  final FileMetadata? fileMetadata;

  ItemModel({
    this.id = '',
    this.itemName = '',
    this.hsnCode,
    required this.unit,
    required this.itemType,
    this.price = 0.0,
    required this.purchasePrice,
    this.gst,
    this.openingStock,
    this.taxExempted = false,
    this.description,
    required this.closingStock,
    this.invoiceItems = const [],
    required this.createdAt,
    required this.updatedAt,
    this.companyId = '',
    this.fileMetadata,
  });

  factory ItemModel.fromJson(Map<String, dynamic> json) =>
      _$ItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ItemModelToJson(this);

  ItemModel copyWith({
    String? id,
    String? itemName,
    String? hsnCode,
    ItemUnit? unit,
    ItemType? itemType,
    double? price,
    double? purchasePrice,
    double? gst,
    double? openingStock,
    bool? taxExempted,
    String? description,
    double? closingStock,
    List<InvoiceItemModel>? invoiceItems,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? companyId,
    FileMetadata? fileMetadata,
  }) {
    return ItemModel(
      id: id ?? this.id,
      itemName: itemName ?? this.itemName,
      hsnCode: hsnCode ?? this.hsnCode,
      unit: unit ?? this.unit,
      itemType: itemType ?? this.itemType,
      price: price ?? this.price,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      gst: gst ?? this.gst,
      openingStock: openingStock ?? this.openingStock,
      taxExempted: taxExempted ?? this.taxExempted,
      description: description ?? this.description,
      closingStock: closingStock ?? this.closingStock,
      invoiceItems: invoiceItems ?? this.invoiceItems,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      companyId: companyId ?? this.companyId,
      fileMetadata: fileMetadata ?? this.fileMetadata,
    );
  }

  @override
  String toString() {
    return 'ItemModel(id: $id, itemName: $itemName, hsnCode: $hsnCode, unit: $unit, itemType: $itemType, price: $price, purchasePrice: $purchasePrice, gst: $gst, openingStock: $openingStock, taxExempted: $taxExempted, description: $description, closingStock: $closingStock, invoiceItems: $invoiceItems, createdAt: $createdAt, updatedAt: $updatedAt, companyId: $companyId, fileMetadata: ${fileMetadata.toString()})';
  }
}
