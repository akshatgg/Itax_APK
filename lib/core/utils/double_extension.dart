extension NumberToWords on double {
  static final List<String> _ones = [
    '',
    'one',
    'two',
    'three',
    'four',
    'five',
    'six',
    'seven',
    'eight',
    'nine',
    'ten',
    'eleven',
    'twelve',
    'thirteen',
    'fourteen',
    'fifteen',
    'sixteen',
    'seventeen',
    'eighteen',
    'nineteen'
  ];

  static final List<String> _tens = [
    '',
    '',
    'twenty',
    'thirty',
    'forty',
    'fifty',
    'sixty',
    'seventy',
    'eighty',
    'ninety'
  ];

  String toWords() {
    if (this == 0) return 'zero';

    int wholeNumber = toInt();
    int decimalPart = ((this - wholeNumber) * 100).round();

    String words = _convert(wholeNumber);
    if (decimalPart > 0) {
      words += ' and ${_convert(decimalPart)} cents';
    }
    return words.trim();
  }

  static String _convert(int number) {
    if (number == 0) return '';
    if (number < 20) return _ones[number];
    if (number < 100) {
      return _tens[number ~/ 10] +
          (number % 10 != 0 ? ' ${_ones[number % 10]}' : '');
    }
    if (number < 1000) {
      return "${_ones[number ~/ 100]} hundred${number % 100 != 0 ? " ${_convert(number % 100)}" : ""}";
    }
    if (number < 1000000) {
      return "${_convert(number ~/ 1000)} thousand${number % 1000 != 0 ? " ${_convert(number % 1000)}" : ""}";
    }
    if (number < 1000000000) {
      return "${_convert(number ~/ 1000000)} million${number % 1000000 != 0 ? " ${_convert(number % 1000000)}" : ""}";
    }
    return "${_convert(number ~/ 1000000000)} billion${number % 1000000000 != 0 ? " ${_convert(number % 1000000000)}" : ""}";
  }
}
