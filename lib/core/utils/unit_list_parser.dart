import 'package:flutter/foundation.dart';
import 'dart:typed_data';

class UnitListParser {
  static Uint8List? fromJson(String? json) {
    if (json == null) return null;
    return Uint8List.fromList(json.codeUnits);
  }

  static String? toJson(Uint8List? data) {
    return data != null ? String.fromCharCodes(data) : null;
  }
}
