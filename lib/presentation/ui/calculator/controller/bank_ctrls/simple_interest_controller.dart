import '../../../../../core/data/repos/services/base_shared_preference.dart';
import '../../models/base_calculator_model.dart';

class SimpleInterestCtrl {
  static const String _key = 'simple_interest_result';

  /// Perform simple interest calculation
  static BaseCalculatorModel calculate({
    required double amount,
    required double rate,
    required double time,
    required String timeType,
  }) {
    final double years = _convertToYears(time, timeType);
    final double interest = (amount * rate * years) / 100;
    final double total = amount + interest;

    return BaseCalculatorModel(
      amount: amount,
      rate: rate,
      time: time,
      timeType: timeType,
      result1: interest,
      result2: total,
      result3: null,
      result4: null,
      table: <Map<String, dynamic>>[], // Provide a default empty list
    );
  }

  /// Convert time to years based on timeType
  static double _convertToYears(double time, String timeType) {
    switch (timeType.toLowerCase()) {
      case 'monthly':
        return time / 12;
      case 'quarterly':
        return time / 4;
      case 'yearly':
      default:
        return time;
    }
  }

  /// Save result to SharedPreferences
  static Future<void> save(BaseCalculatorModel model) async {
    await BaseSharedPreference.save(_key, model);
  }

  /// Load result from SharedPreferences
  static Future<BaseCalculatorModel?> load() async {
    return BaseSharedPreference.load(_key);
  }

  /// Clear saved result from SharedPreferences
  static Future<void> clear() async {
    await BaseSharedPreference.clear(_key);
  }
}
