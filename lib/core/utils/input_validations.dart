class InputValidator {
  static String? hasValue<T>(String? value,
      {String errorMessage = 'Input is required'}) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }
    if (T == int) {
      if (int.tryParse(value) == null) {
        return '$value is not a valid integer';
      }
    } else if (T == double) {
      if (double.tryParse(value) == null) {
        return '$value is not a valid decimal number';
      }
    }

    return null;
  }

  static String? maxDoubleValue(String? value, double maxValue,
      {String errorMessage = 'Input is required'}) {
    var checkHas = hasValue<double>(value);
    if (checkHas == null && double.parse(value!) > maxValue) {
      errorMessage = '${maxValue.toStringAsFixed(3)} is max value';
      return errorMessage;
    }
    return null;
  }

  static String? maxIntValue(String? value, int maxValue,
      {String errorMessage = 'Input is required'}) {
    var checkHas = hasValue<int>(value);
    if (checkHas == null && int.parse(value!) > maxValue) {
      errorMessage = 'Number should less than $maxValue';
      return errorMessage;
    }
    return null;
  }
}
