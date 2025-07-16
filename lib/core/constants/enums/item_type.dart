import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config/hive/hive_type_constants.dart';

part 'item_type.g.dart';

@HiveType(typeId: HiveTypeConstants.itemType)
enum ItemType {
  @JsonValue('item')
  @HiveField(0)
  item('Item'),
  @JsonValue('service')
  @HiveField(1)
  service('Service');

  const ItemType(this.name);

  final String name;

  static ItemType fromName(String name) {
    return ItemType.values.firstWhere((t) => t.name == name);
  }
}
