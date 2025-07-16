part of 'receipt_bloc.dart';

sealed class ReceiptEvent extends Equatable {
  const ReceiptEvent();

  @override
  List<Object> get props => [];
}

class SelectedInvoiceData {
  final InvoiceModel invoiceModel;
  final bool isFullPayment;
  final double amount;
  const SelectedInvoiceData({
    required this.invoiceModel,
    required this.isFullPayment,
    required this.amount,
  });
}

class OnSelectInvoice extends ReceiptEvent {
  final List<SelectedInvoiceData> selectedInvoiceData;
  const OnSelectInvoice({
    required this.selectedInvoiceData,
  });

  @override
  List<Object> get props => [selectedInvoiceData];
}

class CreateReceipt extends ReceiptEvent {
  final ReceiptModel receipt;
  const CreateReceipt({required this.receipt});
}

class UpdateReceipt extends ReceiptEvent {
  final ReceiptModel receipt;
  const UpdateReceipt({required this.receipt});
}

class OnGetReceipt extends ReceiptEvent {
  const OnGetReceipt();
}

class OnReceiptUpdated extends ReceiptEvent {
  const OnReceiptUpdated();
}

class DeleteReceipt extends ReceiptEvent {
  final String receiptId;
  const DeleteReceipt({required this.receiptId});
}
