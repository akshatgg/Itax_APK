import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../config/hive/hive_type_constants.dart';

part 'item_unit.g.dart';

@HiveType(typeId: HiveTypeConstants.itemUnit)
enum ItemUnit {
  @HiveField(0)
  @JsonValue('pieces')
  pieces('PIECES', 'PCS'),
  @JsonValue('grams')
  @HiveField(1)
  grams('GRAMS', 'GMS'),
  @JsonValue('kilograms')
  @HiveField(2)
  kilograms('KILOGRAMS', 'KG'),
  @JsonValue('liters')
  @HiveField(3)
  liters('LITERS', 'LT'),
  @JsonValue('milliliters')
  @HiveField(4)
  milliliters('MILLILITERS', 'ML'),
  @JsonValue('meters')
  @HiveField(5)
  meters('METERS', 'MT'),
  @JsonValue('centimeters')
  @HiveField(6)
  centimeters('CENTIMETERS', 'CM'),
  @JsonValue('inches')
  @HiveField(7)
  inches('INCHES', 'IN'),
  @JsonValue('feet')
  @HiveField(8)
  feet('FEET', 'FT'),
  @JsonValue('squareMeter')
  @HiveField(9)
  squareMeters('SQUAREMETERS', 'SQMT'),
  @JsonValue('squareFeet')
  @HiveField(10)
  squareFeet('SQUAREFEET', 'SQFT'),
  @JsonValue('cubicMeters')
  @HiveField(11)
  cubicMeters('CUBICMETERS', 'CMT'),
  @JsonValue('cubicFeet')
  @HiveField(12)
  cubicFeet('CUBICFEET', 'CUFT'),
  @JsonValue('dozen')
  @HiveField(13)
  dozen('DOZEN', 'DOZ'),
  @JsonValue('pack')
  @HiveField(14)
  pack('PACK', 'PCK'),
  @JsonValue('carton')
  @HiveField(15)
  carton('CARTON', 'CART'),
  @JsonValue('box')
  @HiveField(16)
  box('BOX', 'BOX'),
  @JsonValue('roll')
  @HiveField(17)
  roll('ROLL', 'ROLL'),
  @JsonValue('bundle')
  @HiveField(18)
  bundle('BUNDLE', 'BNDL'),
  @JsonValue('pair')
  @HiveField(19)
  pair('PAIR', 'PAIR'),
  @JsonValue('set')
  @HiveField(20)
  set('SET', 'SET'),
  @JsonValue('number')
  @HiveField(21)
  number('NUMBER', 'NOS'),
  @JsonValue('kiloLiters')
  @HiveField(22)
  kiloLiters('KILO LITER', 'KLR'),
  @JsonValue('usGallons')
  @HiveField(23)
  usGallons('US GALLONS', 'USG'),
  ;

  const ItemUnit(this.name, this.code);

  final String name;
  final String code;
}
