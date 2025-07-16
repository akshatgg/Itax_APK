class BankDetails {
  final String checkNumber;
  final String bankName;
  final String accountNumber;
  final String ifscCode;
  final DateTime date;
  final String upiId;

  BankDetails({
    this.checkNumber = '',
    this.bankName = '',
    this.accountNumber = '',
    this.ifscCode = '',
    required this.date,
    this.upiId = '',
  });

  BankDetails copyWith({
    String? checkNumber,
    String? bankName,
    String? accountNumber,
    String? ifscCode,
    DateTime? date,
    String? upiId,
  }) {
    return BankDetails(
      checkNumber: checkNumber ?? this.checkNumber,
      bankName: bankName ?? this.bankName,
      accountNumber: accountNumber ?? this.accountNumber,
      ifscCode: ifscCode ?? this.ifscCode,
      date: date ?? this.date,
      upiId: upiId ?? this.upiId,
    );
  }
}
