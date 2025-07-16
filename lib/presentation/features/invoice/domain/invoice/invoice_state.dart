part of 'invoice_bloc.dart';

sealed class InvoiceState extends Equatable {
  const InvoiceState(this.invoices);
  final List<InvoiceModel> invoices;

  @override
  List<Object> get props => [invoices];
}

final class InvoiceInitial extends InvoiceState {
  const InvoiceInitial(super.invoices);
}

final class InvoiceLoading extends InvoiceState {
  const InvoiceLoading(super.invoices);
}

final class InvoiceLoaded extends InvoiceState {
  const InvoiceLoaded(super.invoices);
}

final class InvoiceError extends InvoiceState {
  final String errorMessage;
  const InvoiceError(super.invoices, this.errorMessage);
}

