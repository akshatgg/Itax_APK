import 'dart:async';

import '../../constants/enums/invoice_type.dart';
import '../../utils/get_it_instance.dart';
import '../apis/models/invoice/receipt_model.dart';
import 'company_repo.dart';
import 'storage/receipt_storage.dart';

class ReceiptRepo {
  final ReceiptStorage storageService;

  ReceiptRepo({
    required this.storageService,
  });

  final _receiptStreamController = StreamController<void>.broadcast();

  Stream<void> get receiptStream => _receiptStreamController.stream;

  void notifyReceiptUpdated() {
    _receiptStreamController.add(null);
  }

  void dispose() {
    _receiptStreamController.close();
  }

  String? errorMessage;
  final List<ReceiptModel> _receipts = List.empty(growable: true);
  final Map<String, ReceiptModel> _idWiseReceipts = {};
  final Map<String, List<ReceiptModel>> _partyWiseReceipts = {};
  final Map<InvoiceType, List<ReceiptModel>> _typeWiseReceipts = {};
  int _lastReceiptNumber = 0;
  final Map<InvoiceType, double> _typeWiseAmounts = {};

  List<ReceiptModel> get receipts => _receipts;

  Map<String, ReceiptModel> get idWiseReceipts => _idWiseReceipts;

  Map<String, List<ReceiptModel>> get partyWiseReceipts => _partyWiseReceipts;

  Map<InvoiceType, List<ReceiptModel>> get typeWiseReceipts =>
      _typeWiseReceipts;

  int get lastReceiptNumber => _lastReceiptNumber;

  Map<InvoiceType, double> get typeWiseAmounts => _typeWiseAmounts;

  Future<List<ReceiptModel>> getAllReceipts({bool notify = false}) async {
    try {
      final receipts = await storageService.getAllReceipts(
        getIt.get<CompanyRepo>().currentCompany!.id,
      );
      _biffercateReceipts(receipts);
      if (notify) notifyReceiptUpdated();
      return receipts;
    } catch (e) {
      errorMessage = e.toString();
      return [];
    }
  }

  void _biffercateReceipts(List<ReceiptModel> receipts) {
    _receipts.clear();
    _idWiseReceipts.clear();
    _partyWiseReceipts.clear();
    _typeWiseReceipts.clear();
    _lastReceiptNumber = 0;
    _typeWiseAmounts.clear();
    int max = 0;

    for (final receipt in receipts) {
      if (receipt.receiptNumber > max) {
        max = receipt.receiptNumber;
      }
      _receipts.add(receipt);
      _idWiseReceipts[receipt.id] = receipt;
      _partyWiseReceipts.putIfAbsent(receipt.partyId, () => []).add(receipt);
      _typeWiseReceipts.putIfAbsent(receipt.type, () => []).add(receipt);
      _typeWiseAmounts[receipt.type] =
          _typeWiseAmounts[receipt.type] ?? 0 + receipt.totalAmount;
    }
    _lastReceiptNumber = max;
  }

  Future<bool> createReceipt(ReceiptModel receipt) async {
    try {
      await storageService.createReceipt(receipt);
      await getAllReceipts();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> updateReceipt(ReceiptModel receipt) async {
    try {
      await storageService.updateReceipt(receipt);
      await getAllReceipts();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> deleteReceipt(String receiptId) async {
    try {
      await storageService.deleteReceipt(receiptId);
      await getAllReceipts();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }

  Future<bool> clearAllReceipts() async {
    try {
      await storageService.clearAllReceipts();
      await getAllReceipts();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      return false;
    }
  }
}
