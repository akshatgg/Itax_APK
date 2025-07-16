import 'package:flutter/material.dart';

import '../../constants/enums/invoice_type.dart';
import '../../utils/get_fin_year.dart';
import '../../utils/id_generator.dart';
import '../apis/models/dashboard/dashboard_data_model.dart';
import '../apis/models/invoice/invoice_model.dart';
import '../apis/models/invoice/notes_model.dart';
import '../apis/models/invoice/receipt_model.dart';
import 'storage/dashboard_data_storage.dart';

class DashboardDataRepo extends ChangeNotifier {
  final DashboardDataStorage storageService;

  DashboardDataRepo({required this.storageService});

  DashboardDataModel? _dashboardData;

  DashboardDataModel? get dashboardData => _dashboardData;

  Future<DashboardDataModel?> getDashboardData() async {
    _dashboardData = await storageService.getDashboardData();
    return _dashboardData;
  }

  Future<void> onInvoiceAdded(InvoiceModel invoice) async {
    var dashboardData = await getDashboardData();
    if (dashboardData == null) {
      final newDashboardData = DashboardDataModel(
        companyId: invoice.companyId,
        id: generateId(),
      );
      await storageService.createDashboardData(newDashboardData);
      _dashboardData = newDashboardData;
      dashboardData = _dashboardData;
      notifyListeners();
      onInvoiceAdded(invoice);
      return;
    }

    if (isDateInPreviousFinYear(invoice.invoiceDate)) {
      final previousYearSalesAmount =
          Map<int, double>.from(dashboardData.previousYearSalesAmount);
      final previousYearVolume =
          Map<InvoiceType, double>.from(dashboardData.previousYearVolume);
      var previousYearSalesAmountTotal =
          dashboardData.previousYearSalesAmountTotal;

      final previousYearPurchaseAmount =
          Map<int, double>.from(dashboardData.previousYearPurchaseAmount);
      var previousYearPurchaseAmountTotal =
          dashboardData.previousYearPurchaseAmountTotal;

      if (invoice.type == InvoiceType.sales) {
        previousYearSalesAmount[invoice.invoiceDate.month] =
            (previousYearSalesAmount[invoice.invoiceDate.month] ?? 0) +
                invoice.totalAmount;
        previousYearSalesAmountTotal += invoice.totalAmount;
      }
      if (invoice.type == InvoiceType.purchase) {
        previousYearPurchaseAmount[invoice.invoiceDate.month] =
            (previousYearPurchaseAmount[invoice.invoiceDate.month] ?? 0) +
                invoice.totalAmount;
        previousYearPurchaseAmountTotal += invoice.totalAmount;
      }

      previousYearVolume[invoice.type] =
          (previousYearVolume[invoice.type] ?? 0) + invoice.totalAmount;

      final updatedDashboardData = dashboardData.copyWith(
        previousYearSalesAmount: previousYearSalesAmount,
        previousYearSalesAmountTotal: previousYearSalesAmountTotal,
        previousYearVolume: previousYearVolume,
        previousYearPurchaseAmount: previousYearPurchaseAmount,
        previousYearPurchaseAmountTotal: previousYearPurchaseAmountTotal,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }

    if (isDateInThisFinYear(invoice.invoiceDate)) {
      final currentYearSalesAmount =
          Map<int, double>.from(dashboardData.currentYearSalesAmount);
      var currentYearSalesAmountTotal =
          dashboardData.currentYearSalesAmountTotal;
      final currentYearVolume =
          Map<InvoiceType, double>.from(dashboardData.currentYearVolume);

      final currentYearPurchaseAmount =
          Map<int, double>.from(dashboardData.currentYearPurchaseAmount);
      var currentYearPurchaseAmountTotal =
          dashboardData.currentYearPurchaseAmountTotal;
      if (invoice.type == InvoiceType.sales) {
        currentYearSalesAmount[invoice.invoiceDate.month] =
            (currentYearSalesAmount[invoice.invoiceDate.month] ?? 0) +
                invoice.totalAmount;
        currentYearSalesAmountTotal += invoice.totalAmount;
      }
      if (invoice.type == InvoiceType.purchase) {
        currentYearPurchaseAmount[invoice.invoiceDate.month] =
            (currentYearPurchaseAmount[invoice.invoiceDate.month] ?? 0) +
                invoice.totalAmount;
        currentYearPurchaseAmountTotal += invoice.totalAmount;
      }

      currentYearVolume[invoice.type] =
          (currentYearVolume[invoice.type] ?? 0) + invoice.totalAmount;

      final currentMonthSalesAmount =
          Map<int, double>.from(dashboardData.currentMonthSalesAmount);
      var currentMonthSalesAmountTotal =
          dashboardData.currentMonthSalesAmountTotal;
      final currentMonthVolume =
          Map<InvoiceType, double>.from(dashboardData.currentMonthVolume);
      final currentMonthPurchaseAmount =
          Map<int, double>.from(dashboardData.currentMonthPurchaseAmount);
      var currentMonthPurchaseAmountTotal =
          dashboardData.currentMonthPurchaseAmountTotal;

      if (isDateInThisMonth(invoice.invoiceDate)) {
        if (invoice.type == InvoiceType.sales) {
          currentMonthSalesAmount[invoice.invoiceDate.month] =
              (currentMonthSalesAmount[invoice.invoiceDate.month] ?? 0) +
                  invoice.totalAmount;
          currentMonthSalesAmountTotal += invoice.totalAmount;
        }
        if (invoice.type == InvoiceType.purchase) {
          currentMonthPurchaseAmount[invoice.invoiceDate.month] =
              (currentMonthPurchaseAmount[invoice.invoiceDate.month] ?? 0) +
                  invoice.totalAmount;
          currentMonthPurchaseAmountTotal += invoice.totalAmount;
        }
        currentMonthVolume[invoice.type] =
            (currentMonthVolume[invoice.type] ?? 0) + invoice.totalAmount;
      }

      final currentWeekSalesAmount =
          Map<int, double>.from(dashboardData.currentWeekSalesAmount);
      var currentWeekSalesAmountTotal =
          dashboardData.currentWeekSalesAmountTotal;
      final currentWeekVolume =
          Map<InvoiceType, double>.from(dashboardData.currentWeekVolume);
      final currentWeekPurchaseAmount =
          Map<int, double>.from(dashboardData.currentWeekPurchaseAmount);
      var currentWeekPurchaseAmountTotal =
          dashboardData.currentWeekPurchaseAmountTotal;

      if (isDateInThisWeek(invoice.invoiceDate)) {
        if (invoice.type == InvoiceType.sales) {
          currentWeekSalesAmount[invoice.invoiceDate.weekday] =
              (currentWeekSalesAmount[invoice.invoiceDate.weekday] ?? 0) +
                  invoice.totalAmount;
          currentWeekSalesAmountTotal += invoice.totalAmount;
        }
        if (invoice.type == InvoiceType.purchase) {
          currentWeekPurchaseAmount[invoice.invoiceDate.weekday] =
              (currentWeekPurchaseAmount[invoice.invoiceDate.weekday] ?? 0) +
                  invoice.totalAmount;
          currentWeekPurchaseAmountTotal += invoice.totalAmount;
        }
      }

      final updatedDashboardData = dashboardData.copyWith(
        currentYearSalesAmount: currentYearSalesAmount,
        currentYearSalesAmountTotal: currentYearSalesAmountTotal,
        currentYearVolume: currentYearVolume,
        currentYearPurchaseAmount: currentYearPurchaseAmount,
        currentYearPurchaseAmountTotal: currentYearPurchaseAmountTotal,
        currentMonthSalesAmount: currentMonthSalesAmount,
        currentMonthSalesAmountTotal: currentMonthSalesAmountTotal,
        currentMonthVolume: currentMonthVolume,
        currentMonthPurchaseAmount: currentMonthPurchaseAmount,
        currentMonthPurchaseAmountTotal: currentMonthPurchaseAmountTotal,
        currentWeekSalesAmount: currentWeekSalesAmount,
        currentWeekSalesAmountTotal: currentWeekSalesAmountTotal,
        currentWeekVolume: currentWeekVolume,
        currentWeekPurchaseAmount: currentWeekPurchaseAmount,
        currentWeekPurchaseAmountTotal: currentWeekPurchaseAmountTotal,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
    }
  }

  Future<void> onInvoiceDeleted(InvoiceModel deletedInvoice) async {
    final dashboardData = await getDashboardData();
    if (dashboardData == null) {
      return;
    }

    if (isDateInPreviousFinYear(deletedInvoice.invoiceDate)) {
      final previousYearSalesAmount =
          Map<int, double>.from(dashboardData.previousYearSalesAmount);
      final previousYearVolume =
          Map<InvoiceType, double>.from(dashboardData.previousYearVolume);
      var previousYearSalesAmountTotal =
          dashboardData.previousYearSalesAmountTotal;

      final previousYearPurchaseAmount =
          Map<int, double>.from(dashboardData.previousYearPurchaseAmount);
      var previousYearPurchaseAmountTotal =
          dashboardData.previousYearPurchaseAmountTotal;

      if (deletedInvoice.type == InvoiceType.sales) {
        previousYearSalesAmount[deletedInvoice.invoiceDate.month] =
            (previousYearSalesAmount[deletedInvoice.invoiceDate.month] ?? 0) -
                deletedInvoice.totalAmount;
        previousYearSalesAmountTotal -= deletedInvoice.totalAmount;
      }
      if (deletedInvoice.type == InvoiceType.purchase) {
        previousYearPurchaseAmount[deletedInvoice.invoiceDate.month] =
            (previousYearPurchaseAmount[deletedInvoice.invoiceDate.month] ??
                    0) -
                deletedInvoice.totalAmount;
        previousYearPurchaseAmountTotal -= deletedInvoice.totalAmount;
      }

      final updatedDashboardData = dashboardData.copyWith(
        previousYearSalesAmount: previousYearSalesAmount,
        previousYearSalesAmountTotal: previousYearSalesAmountTotal,
        previousYearVolume: previousYearVolume,
        previousYearPurchaseAmount: previousYearPurchaseAmount,
        previousYearPurchaseAmountTotal: previousYearPurchaseAmountTotal,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }

    if (isDateInThisFinYear(deletedInvoice.invoiceDate)) {
      final currentYearSalesAmount =
          Map<int, double>.from(dashboardData.currentYearSalesAmount);
      var currentYearSalesAmountTotal =
          dashboardData.currentYearSalesAmountTotal;
      final currentYearVolume =
          Map<InvoiceType, double>.from(dashboardData.currentYearVolume);

      final currentYearPurchaseAmount =
          Map<int, double>.from(dashboardData.currentYearPurchaseAmount);
      var currentYearPurchaseAmountTotal =
          dashboardData.currentYearPurchaseAmountTotal;

      if (deletedInvoice.type == InvoiceType.sales) {
        currentYearSalesAmount[deletedInvoice.invoiceDate.month] =
            (currentYearSalesAmount[deletedInvoice.invoiceDate.month] ?? 0) -
                deletedInvoice.totalAmount;
        currentYearSalesAmountTotal -= deletedInvoice.totalAmount;
      }
      if (deletedInvoice.type == InvoiceType.purchase) {
        currentYearPurchaseAmount[deletedInvoice.invoiceDate.month] =
            (currentYearPurchaseAmount[deletedInvoice.invoiceDate.month] ?? 0) -
                deletedInvoice.totalAmount;
        currentYearPurchaseAmountTotal -= deletedInvoice.totalAmount;
      }

      final currentMonthSalesAmount =
          Map<int, double>.from(dashboardData.currentMonthSalesAmount);
      var currentMonthSalesAmountTotal =
          dashboardData.currentMonthSalesAmountTotal;
      final currentMonthVolume =
          Map<InvoiceType, double>.from(dashboardData.currentMonthVolume);
      final currentMonthPurchaseAmount =
          Map<int, double>.from(dashboardData.currentMonthPurchaseAmount);
      var currentMonthPurchaseAmountTotal =
          dashboardData.currentMonthPurchaseAmountTotal;

      if (isDateInThisMonth(deletedInvoice.invoiceDate)) {
        if (deletedInvoice.type == InvoiceType.sales) {
          currentMonthSalesAmount[deletedInvoice.invoiceDate.month] =
              (currentMonthSalesAmount[deletedInvoice.invoiceDate.month] ?? 0) -
                  deletedInvoice.totalAmount;
          currentMonthSalesAmountTotal -= deletedInvoice.totalAmount;
        }
        if (deletedInvoice.type == InvoiceType.purchase) {
          currentMonthPurchaseAmount[deletedInvoice.invoiceDate.month] =
              (currentMonthPurchaseAmount[deletedInvoice.invoiceDate.month] ??
                      0) -
                  deletedInvoice.totalAmount;
          currentMonthPurchaseAmountTotal -= deletedInvoice.totalAmount;
        }
        currentMonthVolume[deletedInvoice.type] =
            (currentMonthVolume[deletedInvoice.type] ?? 0) -
                deletedInvoice.totalAmount;
      }

      final currentWeekSalesAmount =
          Map<int, double>.from(dashboardData.currentWeekSalesAmount);
      var currentWeekSalesAmountTotal =
          dashboardData.currentWeekSalesAmountTotal;
      final currentWeekVolume =
          Map<InvoiceType, double>.from(dashboardData.currentWeekVolume);
      final currentWeekPurchaseAmount =
          Map<int, double>.from(dashboardData.currentWeekPurchaseAmount);
      var currentWeekPurchaseAmountTotal =
          dashboardData.currentWeekPurchaseAmountTotal;

      if (isDateInThisWeek(deletedInvoice.invoiceDate)) {
        if (deletedInvoice.type == InvoiceType.sales) {
          currentWeekSalesAmount[deletedInvoice.invoiceDate.weekday] =
              (currentWeekSalesAmount[deletedInvoice.invoiceDate.weekday] ??
                      0) -
                  deletedInvoice.totalAmount;
          currentWeekSalesAmountTotal -= deletedInvoice.totalAmount;
        }
        if (deletedInvoice.type == InvoiceType.purchase) {
          currentWeekPurchaseAmount[deletedInvoice.invoiceDate.weekday] =
              (currentWeekPurchaseAmount[deletedInvoice.invoiceDate.weekday] ??
                      0) -
                  deletedInvoice.totalAmount;
          currentWeekPurchaseAmountTotal -= deletedInvoice.totalAmount;
        }
        currentWeekVolume[deletedInvoice.type] =
            (currentWeekVolume[deletedInvoice.type] ?? 0) -
                deletedInvoice.totalAmount;
      }

      final updatedDashboardData = dashboardData.copyWith(
        currentYearSalesAmount: currentYearSalesAmount,
        currentYearSalesAmountTotal: currentYearSalesAmountTotal,
        currentYearVolume: currentYearVolume,
        currentYearPurchaseAmount: currentYearPurchaseAmount,
        currentYearPurchaseAmountTotal: currentYearPurchaseAmountTotal,
        currentMonthSalesAmount: currentMonthSalesAmount,
        currentMonthSalesAmountTotal: currentMonthSalesAmountTotal,
        currentMonthVolume: currentMonthVolume,
        currentMonthPurchaseAmount: currentMonthPurchaseAmount,
        currentMonthPurchaseAmountTotal: currentMonthPurchaseAmountTotal,
        currentWeekSalesAmount: currentWeekSalesAmount,
        currentWeekSalesAmountTotal: currentWeekSalesAmountTotal,
        currentWeekVolume: currentWeekVolume,
        currentWeekPurchaseAmount: currentWeekPurchaseAmount,
        currentWeekPurchaseAmountTotal: currentWeekPurchaseAmountTotal,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }
  }

  Future<void> onInvoiceUpdated(
      InvoiceModel oldInvoice, InvoiceModel newInvoice) async {
    await onInvoiceDeleted(oldInvoice);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await onInvoiceAdded(newInvoice);
  }

  Future<void> onReceiptAdded(ReceiptModel receipt) async {
    final dashboardData = await getDashboardData();
    if (dashboardData == null) {
      return;
    }

    if (isDateInPreviousFinYear(receipt.invoiceDate)) {
      final previousYearVolume =
          Map<InvoiceType, double>.from(dashboardData.previousYearVolume);
      previousYearVolume[receipt.type] =
          (previousYearVolume[receipt.type] ?? 0) + receipt.totalAmount;

      final updatedDashboardData = dashboardData.copyWith(
        previousYearVolume: previousYearVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }

    if (isDateInThisFinYear(receipt.invoiceDate)) {
      final currentYearVolume =
          Map<InvoiceType, double>.from(dashboardData.currentYearVolume);
      currentYearVolume[receipt.type] =
          (currentYearVolume[receipt.type] ?? 0) + receipt.totalAmount;

      final currentMonthVolume =
          Map<InvoiceType, double>.from(dashboardData.currentMonthVolume);
      if (isDateInThisMonth(receipt.invoiceDate)) {
        currentMonthVolume[receipt.type] =
            (currentMonthVolume[receipt.type] ?? 0) + receipt.totalAmount;
      }

      final currentWeekVolume =
          Map<InvoiceType, double>.from(dashboardData.currentWeekVolume);
      if (isDateInThisWeek(receipt.invoiceDate)) {
        currentWeekVolume[receipt.type] =
            (currentWeekVolume[receipt.type] ?? 0) + receipt.totalAmount;
      }

      final updatedDashboardData = dashboardData.copyWith(
        currentYearVolume: currentYearVolume,
        currentMonthVolume: currentMonthVolume,
        currentWeekVolume: currentWeekVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }
  }

  Future<void> onReceiptDeleted(ReceiptModel receipt) async {
    final dashboardData = await getDashboardData();
    if (dashboardData == null) {
      return;
    }

    if (isDateInPreviousFinYear(receipt.invoiceDate)) {
      final previousYearVolume =
          Map<InvoiceType, double>.from(dashboardData.previousYearVolume);
      previousYearVolume[receipt.type] =
          (previousYearVolume[receipt.type] ?? 0) - receipt.totalAmount;

      final updatedDashboardData = dashboardData.copyWith(
        previousYearVolume: previousYearVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }

    if (isDateInThisFinYear(receipt.invoiceDate)) {
      final currentYearVolume =
          Map<InvoiceType, double>.from(dashboardData.currentYearVolume);
      currentYearVolume[receipt.type] =
          (currentYearVolume[receipt.type] ?? 0) - receipt.totalAmount;

      final currentMonthVolume =
          Map<InvoiceType, double>.from(dashboardData.currentMonthVolume);
      if (isDateInThisMonth(receipt.invoiceDate)) {
        currentMonthVolume[receipt.type] =
            (currentMonthVolume[receipt.type] ?? 0) - receipt.totalAmount;
      }

      final currentWeekVolume =
          Map<InvoiceType, double>.from(dashboardData.currentWeekVolume);
      if (isDateInThisWeek(receipt.invoiceDate)) {
        currentWeekVolume[receipt.type] =
            (currentWeekVolume[receipt.type] ?? 0) - receipt.totalAmount;
      }

      final updatedDashboardData = dashboardData.copyWith(
        currentYearVolume: currentYearVolume,
        currentMonthVolume: currentMonthVolume,
        currentWeekVolume: currentWeekVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      return;
    }
  }

  Future<void> onReceiptUpdated(
      ReceiptModel oldReceipt, ReceiptModel newReceipt) async {
    await onReceiptDeleted(oldReceipt);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await onReceiptAdded(newReceipt);
  }

  Future<void> onNoteAdded(NotesModel note) async {
    final dashboardData = await getDashboardData();
    if (dashboardData == null) {
      return;
    }

    if (isDateInPreviousFinYear(note.invoiceDate)) {
      final previousYearVolume =
          Map<InvoiceType, double>.from(dashboardData.previousYearVolume);
      previousYearVolume[note.type] =
          (previousYearVolume[note.type] ?? 0) + note.totalAmount;

      final updatedDashboardData = dashboardData.copyWith(
        previousYearVolume: previousYearVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }

    if (isDateInThisFinYear(note.invoiceDate)) {
      final currentYearVolume =
          Map<InvoiceType, double>.from(dashboardData.currentYearVolume);
      currentYearVolume[note.type] =
          (currentYearVolume[note.type] ?? 0) + note.totalAmount;

      final currentMonthVolume =
          Map<InvoiceType, double>.from(dashboardData.currentMonthVolume);
      if (isDateInThisMonth(note.invoiceDate)) {
        currentMonthVolume[note.type] =
            (currentMonthVolume[note.type] ?? 0) + note.totalAmount;
      }

      final currentWeekVolume =
          Map<InvoiceType, double>.from(dashboardData.currentWeekVolume);
      if (isDateInThisWeek(note.invoiceDate)) {
        currentWeekVolume[note.type] =
            (currentWeekVolume[note.type] ?? 0) + note.totalAmount;
      }

      final updatedDashboardData = dashboardData.copyWith(
        currentYearVolume: currentYearVolume,
        currentMonthVolume: currentMonthVolume,
        currentWeekVolume: currentWeekVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }
  }

  Future<void> onNoteDeleted(NotesModel note) async {
    final dashboardData = await getDashboardData();
    if (dashboardData == null) {
      return;
    }

    if (isDateInPreviousFinYear(note.invoiceDate)) {
      final previousYearVolume =
          Map<InvoiceType, double>.from(dashboardData.previousYearVolume);
      previousYearVolume[note.type] =
          (previousYearVolume[note.type] ?? 0) - note.totalAmount;

      final updatedDashboardData = dashboardData.copyWith(
        previousYearVolume: previousYearVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }

    if (isDateInThisFinYear(note.invoiceDate)) {
      final currentYearVolume =
          Map<InvoiceType, double>.from(dashboardData.currentYearVolume);
      currentYearVolume[note.type] =
          (currentYearVolume[note.type] ?? 0) - note.totalAmount;

      final currentMonthVolume =
          Map<InvoiceType, double>.from(dashboardData.currentMonthVolume);
      if (isDateInThisMonth(note.invoiceDate)) {
        currentMonthVolume[note.type] =
            (currentMonthVolume[note.type] ?? 0) - note.totalAmount;
      }

      final currentWeekVolume =
          Map<InvoiceType, double>.from(dashboardData.currentWeekVolume);
      if (isDateInThisWeek(note.invoiceDate)) {
        currentWeekVolume[note.type] =
            (currentWeekVolume[note.type] ?? 0) - note.totalAmount;
      }

      final updatedDashboardData = dashboardData.copyWith(
        currentYearVolume: currentYearVolume,
        currentMonthVolume: currentMonthVolume,
        currentWeekVolume: currentWeekVolume,
      );
      await storageService.updateDashboardData(updatedDashboardData);
      _dashboardData = updatedDashboardData;
      notifyListeners();
      return;
    }
  }

  Future<void> onNoteUpdated(NotesModel oldNote, NotesModel newNote) async {
    await onNoteDeleted(oldNote);
    await Future<void>.delayed(const Duration(milliseconds: 100));
    await onNoteAdded(newNote);
  }
}
