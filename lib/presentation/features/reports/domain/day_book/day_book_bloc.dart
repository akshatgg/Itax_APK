import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/enums/invoice_type.dart';
import '../../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../../core/data/repos/company_repo.dart';
import '../../../../../core/data/repos/day_book_repo.dart';
import '../../../../../core/utils/id_generator.dart';
import '../../data/day_book.dart';
import '../../data/day_book_invoice.dart';

part 'day_book_event.dart';
part 'day_book_state.dart';

class DayBookBloc extends Bloc<DayBookEvent, DayBookState> {
  final DayBookRepo dayBookRepo;
  final CompanyRepo companyRepo;

  List<DayBook> get dayBooks => dayBookRepo.dayBooks;

  Map<String, DayBook> get idWiseDayBooks => dayBookRepo.idWiseDayBooks;

  Map<InvoiceType, List<DayBook>> get typeWiseDayBooks =>
      dayBookRepo.typeWiseDayBooks;

  Map<DateTime, DayBook> get dateWiseDayBooks => dayBookRepo.dateWiseDayBooks;

  DayBookBloc({
    required this.dayBookRepo,
    required this.companyRepo,
  }) : super(const DayBookInitial([])) {
    on<OnLoadDayBooks>(_onLoadDayBooks);
    on<OnInvoiceAdded>(_onInvoiceAdded);
    on<OnInvoiceRemoved>(_onInvoiceRemoved);
    on<OnInvoiceUpdated>(_onInvoiceUpdated);
    on<OnDayBookUpdated>(_onDayBookUpdated);

    _subscription = dayBookRepo.dayBookStream.listen((_) {
      add(const OnDayBookUpdated());
    });
  }

  late StreamSubscription<void> _subscription;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }

  void _onDayBookUpdated(
    OnDayBookUpdated event,
    Emitter<DayBookState> emit,
  ) {
    emit(DayBookLoaded(dayBookRepo.dayBooks));
  }

  Future<void> _onLoadDayBooks(
      OnLoadDayBooks event, Emitter<DayBookState> emit) async {
    emit(DayBookLoading(state.dayBooks));
    try {
      final dayBooks = await dayBookRepo.getAllDayBooks();

      emit(DayBookLoaded(dayBooks));
    } catch (e) {
      emit(DayBookError(state.dayBooks, e.toString()));
    }
  }

  Future<void> _onInvoiceAdded(
      OnInvoiceAdded event, Emitter<DayBookState> emit) async {
    emit(DayBookLoading(state.dayBooks));
    try {
      final hasDayBook = dayBookRepo.dateWiseDayBooks.containsKey(
        event.invoice.invoiceDate,
      );
      if (hasDayBook) {
        final dayBook =
            dayBookRepo.dateWiseDayBooks[event.invoice.invoiceDate]!;
        dayBook.invoices.add(DayBookInvoice(
          date: event.invoice.invoiceDate,
          invoiceType: event.invoice.type,
          invoiceId: event.invoice.id,
          invoiceNumber: event.invoice.invoiceNumber,
          totalAmount: event.invoice.totalAmount,
          partyName: event.invoice.partyName,
        ));
        emit(DayBookLoaded(dayBookRepo.dayBooks));
        return;
      }
      final dayBook = DayBook(
        date: event.invoice.invoiceDate,
        id: generateId(),
        companyId: companyRepo.currentCompany!.id,
        invoices: [
          DayBookInvoice(
            date: event.invoice.invoiceDate,
            invoiceType: event.invoice.type,
            invoiceId: event.invoice.id,
            invoiceNumber: event.invoice.invoiceNumber,
            totalAmount: event.invoice.totalAmount,
            partyName: event.invoice.partyName,
          ),
        ],
      );
      await dayBookRepo.createDayBook(dayBook);
      emit(DayBookLoaded(dayBookRepo.dayBooks));
    } catch (e) {
      emit(DayBookError(state.dayBooks, e.toString()));
    }
  }

  Future<void> _onInvoiceRemoved(
      OnInvoiceRemoved event, Emitter<DayBookState> emit) async {
    emit(DayBookLoading(state.dayBooks));
    try {
      final dayBook = dayBookRepo.dateWiseDayBooks[event.invoice.invoiceDate];
      if (dayBook != null) {
        dayBook.invoices.removeWhere(
          (invoice) => invoice.invoiceId == event.invoice.id,
        );
        await dayBookRepo.updateDayBook(dayBook);
        emit(DayBookLoaded(dayBookRepo.dayBooks));
      }
    } catch (e) {
      emit(DayBookError(state.dayBooks, e.toString()));
    }
  }

  Future<void> _onInvoiceUpdated(
      OnInvoiceUpdated event, Emitter<DayBookState> emit) async {
    emit(DayBookLoading(state.dayBooks));
    try {
      final dayBook = dayBookRepo.dateWiseDayBooks[event.invoice.invoiceDate];
      if (dayBook != null) {
        dayBook.invoices.removeWhere(
          (invoice) => invoice.invoiceId == event.invoice.id,
        );
        dayBook.invoices.add(DayBookInvoice(
          date: event.invoice.invoiceDate,
          invoiceType: event.invoice.type,
          invoiceId: event.invoice.id,
          invoiceNumber: event.invoice.invoiceNumber,
          totalAmount: event.invoice.totalAmount,
          partyName: event.invoice.partyName,
        ));
        await dayBookRepo.updateDayBook(dayBook);
        emit(DayBookLoaded(dayBookRepo.dayBooks));
      }
    } catch (e) {
      emit(DayBookError(state.dayBooks, e.toString()));
    }
  }
}
