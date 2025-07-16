part of 'invoice_bloc.dart';

sealed class InvoiceEvent extends Equatable {
  const InvoiceEvent();

  @override
  List<Object> get props => [];
}

class OnInvoiceLoaded extends InvoiceEvent {
  const OnInvoiceLoaded();
}

class GetAllInvoices extends InvoiceEvent {
  const GetAllInvoices();
}

class CreateInvoice extends InvoiceEvent {
  const CreateInvoice(this.invoice);
  final InvoiceModel invoice;

  @override
  List<Object> get props => [invoice];
}

class UpdateInvoice extends InvoiceEvent {
  const UpdateInvoice(this.invoice);
  final InvoiceModel invoice;

  @override
  List<Object> get props => [invoice];
}

class DeleteInvoice extends InvoiceEvent {
  const DeleteInvoice(this.invoiceId);
  final String invoiceId;

  @override
  List<Object> get props => [invoiceId];
}
