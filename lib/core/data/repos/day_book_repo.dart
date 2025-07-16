import 'dart:async';

import '../../../presentation/features/reports/data/day_book.dart';
import '../../../presentation/features/reports/data/day_book_invoice.dart';
import '../../constants/enums/invoice_type.dart';
import '../../utils/get_it_instance.dart';
import '../../utils/id_generator.dart';
import '../apis/models/invoice/invoice_model.dart';
import '../apis/models/invoice/notes_model.dart';
import '../apis/models/invoice/receipt_model.dart';
import 'company_repo.dart';
import 'storage/day_book_storage.dart';

class DayBookRepo {
  final DayBookStorage storageService;
  final CompanyRepo companyRepo;

  DayBookRepo({
    required this.storageService,
    required this.companyRepo,
  });

  final _dayBookStreamController = StreamController<void>.broadcast();

  Stream<void> get dayBookStream => _dayBookStreamController.stream;

  void notifyDayBookUpdated() {
    _dayBookStreamController.add(null);
  }

  void dispose() {
    _dayBookStreamController.close();
  }

  String? errorMessage;
  final List<DayBook> _dayBooks = [];
  final Map<String, DayBook> _idWiseDayBooks = {};
  final Map<InvoiceType, List<DayBook>> _typeWiseDayBooks = {};
  final Map<DateTime, DayBook> _dateWiseDayBooks = {};

  List<DayBook> get dayBooks => _dayBooks;

  Map<String, DayBook> get idWiseDayBooks => _idWiseDayBooks;

  Map<InvoiceType, List<DayBook>> get typeWiseDayBooks => _typeWiseDayBooks;

  Map<DateTime, DayBook> get dateWiseDayBooks => _dateWiseDayBooks;

  Future<List<DayBook>> getAllDayBooks({bool notify = false}) async {
    try {
      final dayBooks = await storageService.getAllDayBooks(
        getIt.get<CompanyRepo>().currentCompany!.id,
      );
      _biffercateDayBooks(dayBooks);
      if (notify) notifyDayBookUpdated();
      return dayBooks;
    } catch (e) {
      errorMessage = e.toString();
      return [];
    }
  }

  Future<bool> createDayBook(DayBook dayBook) async {
    try {
      await storageService.createDayBook(dayBook);
      getAllDayBooks();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> updateDayBook(DayBook dayBook) async {
    try {
      await storageService.updateDayBook(dayBook);
      getAllDayBooks();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> deleteDayBook(String id) async {
    try {
      await storageService.deleteDayBook(id);
      getAllDayBooks();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  void _biffercateDayBooks(List<DayBook> dayBooks) {
    _dayBooks.clear();
    _idWiseDayBooks.clear();
    _typeWiseDayBooks.clear();
    _dateWiseDayBooks.clear();
    // int max = 0;

    for (final dayBook in dayBooks) {
      // if (dayBook.invoiceType.index > max) {
      //   max = dayBook.invoiceType.index;
      // }
      _dayBooks.add(dayBook);
      _idWiseDayBooks[dayBook.id] = dayBook;
      // _typeWiseDayBooks.putIfAbsent().add(dayBook);
      _dateWiseDayBooks[dayBook.date] = dayBook;
    }
  }

  Future<void> onInvoiceCreated(InvoiceModel invoice) async {
    final dayBook = _dateWiseDayBooks[invoice.invoiceDate];
    if (dayBook == null) {
      final newDayBook = DayBook(
        id: generateId(),
        date: invoice.invoiceDate,
        companyId: companyRepo.currentCompany!.id,
        invoices: [
          DayBookInvoice(
            invoiceId: invoice.id,
            invoiceType: invoice.type,
            date: invoice.invoiceDate,
            totalAmount: invoice.totalAmount,
            invoiceNumber: invoice.invoiceNumber,
            partyName: invoice.partyName,
          ),
        ],
      );
      await createDayBook(newDayBook);
    } else {
      dayBook.invoices.add(
        DayBookInvoice(
          invoiceId: invoice.id,
          invoiceType: invoice.type,
          date: invoice.invoiceDate,
          totalAmount: invoice.totalAmount,
          invoiceNumber: invoice.invoiceNumber,
          partyName: invoice.partyName,
        ),
      );
      await updateDayBook(dayBook);
    }
  }

  Future<void> onReceiptCreated(ReceiptModel receipt) async {
    final dayBook = _dateWiseDayBooks[receipt.invoiceDate];
    if (dayBook == null) {
      final newDayBook = DayBook(
        id: generateId(),
        date: receipt.invoiceDate,
        companyId: companyRepo.currentCompany!.id,
        invoices: [
          DayBookInvoice(
            invoiceId: receipt.id,
            invoiceType: receipt.type,
            date: receipt.invoiceDate,
            totalAmount: receipt.totalAmount,
            invoiceNumber: receipt.receiptNumber,
            partyName: receipt.partyName,
          ),
        ],
      );
      await createDayBook(newDayBook);
    } else {
      dayBook.invoices.add(
        DayBookInvoice(
          invoiceId: receipt.id,
          invoiceType: receipt.type,
          date: receipt.invoiceDate,
          totalAmount: receipt.totalAmount,
          invoiceNumber: receipt.receiptNumber,
          partyName: receipt.partyName,
        ),
      );
      await updateDayBook(dayBook);
    }
  }

  Future<void> onNoteCreated(NotesModel note) async {
    final dayBook = _dateWiseDayBooks[note.invoiceDate];
    if (dayBook == null) {
      final newDayBook = DayBook(
        id: generateId(),
        date: note.invoiceDate,
        companyId: companyRepo.currentCompany!.id,
        invoices: [
          DayBookInvoice(
            invoiceId: note.id,
            invoiceType: note.type,
            date: note.invoiceDate,
            totalAmount: note.totalAmount,
            invoiceNumber: note.invoiceNumber,
            partyName: note.partyName,
          ),
        ],
      );
      await createDayBook(newDayBook);
    } else {
      dayBook.invoices.add(
        DayBookInvoice(
          invoiceId: note.id,
          invoiceType: note.type,
          date: note.invoiceDate,
          totalAmount: note.totalAmount,
          invoiceNumber: note.invoiceNumber,
          partyName: note.partyName,
        ),
      );
      await updateDayBook(dayBook);
    }
  }
}
