part of 'day_book_bloc.dart';

sealed class DayBookEvent extends Equatable {
  const DayBookEvent();

  @override
  List<Object> get props => [];
}

class OnLoadDayBooks extends DayBookEvent {
  const OnLoadDayBooks();
}

class OnInvoiceAdded extends DayBookEvent {
  final InvoiceModel invoice;
  const OnInvoiceAdded(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class OnInvoiceRemoved extends DayBookEvent {
  final InvoiceModel invoice;
  const OnInvoiceRemoved(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class OnInvoiceUpdated extends DayBookEvent {
  final InvoiceModel invoice;
  const OnInvoiceUpdated(this.invoice);

  @override
  List<Object> get props => [invoice];
}

class OnDayBookUpdated extends DayBookEvent {
  const OnDayBookUpdated();
}
