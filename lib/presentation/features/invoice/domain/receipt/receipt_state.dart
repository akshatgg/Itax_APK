part of 'receipt_bloc.dart';

sealed class ReceiptState extends Equatable {
  const ReceiptState({required this.receipts});
  final List<ReceiptModel> receipts;
  @override
  List<Object> get props => [receipts];
}

final class ReceiptInitial extends ReceiptState {
  const ReceiptInitial({required super.receipts});
}

class SelectedInvoiceDataState extends ReceiptState {
  final List<SelectedInvoiceData> selectedInvoiceData;
  const SelectedInvoiceDataState({
    required super.receipts,
    required this.selectedInvoiceData,
  });

  @override
  List<Object> get props => [selectedInvoiceData];
}

final class ReceiptLoading extends ReceiptState {
  const ReceiptLoading({required super.receipts});
}

final class ReceiptLoaded extends ReceiptState {
  const ReceiptLoaded({required super.receipts});
}

final class ReceiptError extends ReceiptState {
  final String errorMessage;
  const ReceiptError({
    required super.receipts,
    required this.errorMessage,
  });

  @override
  List<Object> get props => [errorMessage];
}
