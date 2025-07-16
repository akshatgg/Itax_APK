import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config/hive/hive_type_constants.dart';

part 'party_type.g.dart';

@HiveType(typeId: HiveTypeConstants.partyType)
enum PartyType {
  @JsonValue('customer')
  @HiveField(0)
  customer,
  @JsonValue('supplier')
  @HiveField(1)
  supplier
}
