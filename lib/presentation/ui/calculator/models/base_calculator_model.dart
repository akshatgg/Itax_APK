class BaseCalculatorModel {
  final double amount;
  final double rate;
  final double time;
  final String? timeType;
  final double? result1;
  final double? result2;
  final double? result3;
  final double? result4;
  final List<dynamic>? table; // Explicitly typed List

  BaseCalculatorModel({
    required this.amount,
    required this.rate,
    required this.time,
    this.timeType,
    this.result1,
    this.result2,
    this.result3,
    this.result4,
    this.table,
  });

  Map<String, dynamic> toMap() {
    return {
      'amount': amount,
      'rate': rate,
      'time': time,
      'timeType': timeType,
      'result1': result1,
      'result2': result2,
      'result3': result3,
      'result4': result4,
      'table': table,
    };
  }

  factory BaseCalculatorModel.fromMap(Map<String, dynamic> map) {
    return BaseCalculatorModel(
      amount: _toDouble(map['amount']) ?? 0.0,
      rate: _toDouble(map['rate']) ?? 0.0,
      time: _toDouble(map['time']) ?? 0.0,
      timeType: map['timeType'] as String?,
      result1: _toDouble(map['result1']),
      result2: _toDouble(map['result2']),
      result3: _toDouble(map['result3']),
      result4: _toDouble(map['result4']),
      table: (map['table'] as List?)?.cast<dynamic>(), // Proper casting
    );
  }

  // Helper method to safely convert dynamic to double
  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
