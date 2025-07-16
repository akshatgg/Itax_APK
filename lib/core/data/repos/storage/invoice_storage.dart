import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/invoice/invoice_model.dart';

class InvoiceStorage {
  Future<Box<InvoiceModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.invoiceBox)) {
      return await Hive.openBox<InvoiceModel>(HiveConstants.invoiceBox);
    }
    return Hive.box<InvoiceModel>(HiveConstants.invoiceBox);
  }

  Future<List<InvoiceModel>> getAllInvoices(String companyId) async {
    try {
      final box = await _getBox();
      return box.values
          .where((invoice) => invoice.companyId == companyId)
          .toList();
    } catch (e) {
      logger.d('DEBUG Error getting all Invoices: $e');
      return [];
    }
  }

  Future<InvoiceModel?> getInvoiceById(String id) async {
    try {
      final box = await _getBox();
      final model = box.values.firstWhere(
        (invoice) => invoice.id == id,
      );
      return model;
    } catch (e) {
      logger.d('Error getting invoice by id: $e');
      return null;
    }
  }

  Future<bool> createInvoice(InvoiceModel invoice) async {
    try {
      final box = await _getBox();
      await box.put(invoice.id, invoice);
      return true;
    } catch (e) {
      logger.d('Error creating invoice: $e');
      return false;
    }
  }

  Future<bool> updateInvoice(InvoiceModel updatedInvoice) async {
    try {
      final box = await _getBox();
      if (box.containsKey(updatedInvoice.id)) {
        await box.put(updatedInvoice.id, updatedInvoice);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error updating invoice: $e');
      return false;
    }
  }

  Future<bool> deleteInvoice(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting invoice: $e');
      return false;
    }
  }

  Future<void> clearAllInvoices() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing Invoices: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.invoiceBox)) {
      await Hive.close();
    }
  }
}
