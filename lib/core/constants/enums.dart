import 'package:json_annotation/json_annotation.dart';


enum ModeOfPayment {
  @JsonValue('cash')
  cash,
  @JsonValue('bank')
  bank,
  @JsonValue('upi')
  upi,
  @JsonValue('credit')
  credit,
}

enum LedgerType {
  @JsonValue('bank')
  bank,
  @JsonValue('cash')
  cash,
  @JsonValue('purchase')
  purchase,
  @JsonValue('sales')
  sales,
  @JsonValue('directExpen')
  directExpense,
  @JsonValue('indirectExp')
  indirectExpense,
  @JsonValue('directIncom')
  directIncome,
  @JsonValue('indirectInc')
  indirectIncome,
  @JsonValue('fixedAssets')
  fixedAssets,
  @JsonValue('currentAsse')
  currentAssets,
  @JsonValue('loansAndLia')
  loansAndLiabilitieslw,
  @JsonValue('accountsRec')
  accountsReceivable,
  @JsonValue('accountsPay')
  accountsPayable,
}

enum TransactionType {
  @JsonValue('credit')
  credit,
  @JsonValue('debit')
  debit,
}
