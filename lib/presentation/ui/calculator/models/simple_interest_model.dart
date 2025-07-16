class BaseCalculatorModel {
  final double principal;
  final double rate;
  final double time;
  final String timeType;

  BaseCalculatorModel({
    required this.principal,
    required this.rate,
    required this.time,
    required this.timeType,
  });

  double get interest {
    final years = timeType == 'Yearly' ? time : time / 12;
    return (principal * rate * years) / 100;
  }

  double get total => principal + interest;

  Map<String, dynamic> toJson() => {
        'principal': principal,
        'rate': rate,
        'time': time,
        'timeType': timeType,
      };

  factory BaseCalculatorModel.fromJson(Map<String, dynamic> json) {
    return BaseCalculatorModel(
      principal: _toDouble(json['principal']) ?? 0.0,
      rate: _toDouble(json['rate']) ?? 0.0,
      time: _toDouble(json['time']) ?? 0.0,
      timeType: json['timeType'] as String? ?? '',
    );
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}
