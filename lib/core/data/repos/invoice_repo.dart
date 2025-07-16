import 'dart:async';

import '../../constants/enums/invoice_status.dart';
import '../../constants/enums/invoice_type.dart';
import '../../utils/get_it_instance.dart';
import '../apis/models/invoice/invoice_model.dart';
import '../apis/models/invoice/notes_model.dart';
import '../apis/models/invoice/receipt_model.dart';
import 'company_repo.dart';
import 'storage/invoice_storage.dart';

class InvoiceRepo {
  final InvoiceStorage storageService;

  InvoiceRepo({
    required this.storageService,
  });

  String? errorMessage;
  final _invoiceStreamController = StreamController<void>.broadcast();

  Stream<void> get invoiceStream => _invoiceStreamController.stream;

  void notifyInvoiceUpdated() {
    _invoiceStreamController.add(null);
  }

  void dispose() {
    _invoiceStreamController.close();
  }

  final List<InvoiceModel> _invoices = List.empty(growable: true);
  final Map<String, InvoiceModel> _idWiseInvoices = {};
  final Map<String, List<InvoiceModel>> _partyWiseInvoices = {};
  final Map<InvoiceType, List<InvoiceModel>> _typeWiseInvoices = {};
  final Map<InvoiceType, double> _typeWiseAmounts = {};
  final Map<InvoiceStatus, List<InvoiceModel>> _statusWiseInvoices = {};
  int _lastInvoiceNumber = 0;
  final Map<int, List<InvoiceModel>> _monthWiseInvoice = {};

  List<InvoiceModel> get invoices => _invoices;

  Map<String, InvoiceModel> get idWiseInvoices => _idWiseInvoices;

  Map<String, List<InvoiceModel>> get partyWiseInvoices => _partyWiseInvoices;

  Map<InvoiceType, List<InvoiceModel>> get typeWiseInvoices =>
      _typeWiseInvoices;

  Map<InvoiceStatus, List<InvoiceModel>> get statusWiseInvoices =>
      _statusWiseInvoices;

  int get lastInvoiceNumber => _lastInvoiceNumber;

  Map<int, List<InvoiceModel>> get monthWiseInvoice => _monthWiseInvoice;

  Map<InvoiceType, double> get typeWiseAmounts => _typeWiseAmounts;

  Future<List<InvoiceModel>> getAllInvoices({bool notify = false}) async {
    try {
      final invoices = await storageService.getAllInvoices(
        getIt.get<CompanyRepo>().currentCompany!.id,
      );
      if (notify) notifyInvoiceUpdated();
      _biffercateInvoices(invoices);
      return invoices;
    } catch (e) {
      errorMessage = e.toString();
      return [];
    }
  }

  void _biffercateInvoices(List<InvoiceModel> invoices) {
    _invoices.clear();
    _idWiseInvoices.clear();
    _partyWiseInvoices.clear();
    _typeWiseInvoices.clear();
    _statusWiseInvoices.clear();
    _lastInvoiceNumber = 0;
    _monthWiseInvoice.clear();
    _typeWiseAmounts.clear();
    int max = 0;

    for (final invoice in invoices) {
      if (invoice.invoiceNumber > max) {
        max = invoice.invoiceNumber;
      }
      _invoices.add(invoice);
      _idWiseInvoices[invoice.id] = invoice;
      _partyWiseInvoices.putIfAbsent(invoice.partyId, () => []).add(invoice);
      _typeWiseInvoices.putIfAbsent(invoice.type, () => []).add(invoice);
      _statusWiseInvoices.putIfAbsent(invoice.status, () => []).add(invoice);
      _monthWiseInvoice
          .putIfAbsent(invoice.invoiceDate.month, () => [])
          .add(invoice);
      _typeWiseAmounts[invoice.type] =
          _typeWiseAmounts[invoice.type] ?? 0 + invoice.totalAmount;
    }
    _lastInvoiceNumber = max;
  }

  Future<bool> createInvoice(InvoiceModel invoice) async {
    try {
      await storageService.createInvoice(invoice);
      await getAllInvoices();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> updateInvoice(InvoiceModel invoice, {bool notify = true}) async {
    try {
      await storageService.updateInvoice(invoice);
      await getAllInvoices(notify: notify);
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> deleteInvoice(String invoiceId) async {
    try {
      await storageService.deleteInvoice(invoiceId);
      await getAllInvoices();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> clearAllInvoices() async {
    try {
      await storageService.clearAllInvoices();
      await getAllInvoices();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<void> onReceiptCreated(ReceiptModel receipt) async {
    final filterInvoices = invoices
        .where((element) => receipt.invoiceIds.containsKey(element.id))
        .toList();
    for (var invoice in filterInvoices) {
      final invoiceAmount = invoice.totalAmount;
      final receiptAmount = receipt.invoiceIds[invoice.id] ?? 0;
      final remainingBalance = receipt.type == InvoiceType.receipt
          ? invoiceAmount - receiptAmount
          : invoiceAmount + receiptAmount;
      final status = remainingBalance > 0
          ? InvoiceStatus.partiallyPaid
          : InvoiceStatus.paid;
      await updateInvoice(
        invoice.copyWith(
          status: status,
          remainingBalance: remainingBalance,
        ),
        notify: true,
      );
    }
  }

  Future<void> onNoteCreated(NotesModel note) async {
    var invoice = _idWiseInvoices[note.selectedInvoiceId];
    if (invoice == null) return;
    invoice = invoice.copyWith(
      status: note.totalAmount >= invoice.totalAmount
          ? InvoiceStatus.paid
          : note.totalAmount > 0
              ? InvoiceStatus.partiallyPaid
              : InvoiceStatus.unpaid,
    );
    await updateInvoice(invoice, notify: true);
  }

  Future<void> onReceiptUpdated(
    ReceiptModel previous,
    ReceiptModel current,
  ) async {
    final filterInvoices = invoices
        .where((element) => previous.invoiceIds.containsKey(element.id))
        .toList();
    for (var invoice in filterInvoices) {
      final invoiceAmount = invoice.totalAmount;
      final previousAmount = previous.invoiceIds[invoice.id] ?? 0;
      final currentAmount = current.invoiceIds[invoice.id] ?? 0;
      final remainingBalance = previous.type == InvoiceType.receipt
          ? invoiceAmount - previousAmount + currentAmount
          : invoiceAmount + previousAmount - currentAmount;
      final status = remainingBalance > 0
          ? InvoiceStatus.partiallyPaid
          : InvoiceStatus.paid;
      await updateInvoice(
        invoice.copyWith(
          status: status,
          remainingBalance: remainingBalance,
        ),
        notify: true,
      );
    }
  }

  Future<void> onReceiptDeleted(ReceiptModel receipt) async {
    final filterInvoices = invoices
        .where((element) => receipt.invoiceIds.containsKey(element.id))
        .toList();
    for (var invoice in filterInvoices) {
      final invoiceAmount = invoice.totalAmount;
      final receiptAmount = receipt.invoiceIds[invoice.id] ?? 0;
      final remainingBalance = invoiceAmount - receiptAmount;
      final status = remainingBalance > 0
          ? InvoiceStatus.partiallyPaid
          : InvoiceStatus.paid;
      await updateInvoice(
        invoice.copyWith(
          status: status,
          remainingBalance: remainingBalance,
        ),
        notify: true,
      );
    }
  }

  Future<void> onNoteDeleted(NotesModel note) async {
    var invoice = _idWiseInvoices[note.selectedInvoiceId];
    if (invoice == null) return;
    invoice = invoice.copyWith(
      status: note.totalAmount > 0
          ? InvoiceStatus.partiallyPaid
          : InvoiceStatus.unpaid,
    );
    await updateInvoice(invoice, notify: true);
  }

  Future<void> onNoteUpdated(
    NotesModel previous,
    NotesModel current,
  ) async {
    var invoice = _idWiseInvoices[previous.selectedInvoiceId];
    if (invoice == null) return;
    invoice = invoice.copyWith(
      status: previous.totalAmount > 0
          ? InvoiceStatus.partiallyPaid
          : InvoiceStatus.unpaid,
    );
    await updateInvoice(invoice, notify: true);
    onNoteCreated(current);
  }
}
