import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/invoice/receipt_model.dart';

class ReceiptStorage {
  Future<Box<ReceiptModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.receiptBox)) {
      return await Hive.openBox<ReceiptModel>(HiveConstants.receiptBox);
    }
    return Hive.box<ReceiptModel>(HiveConstants.receiptBox);
  }

  Future<List<ReceiptModel>> getAllReceipts(String companyId) async {
    try {
      final box = await _getBox();
      return box.values
          .where((receipt) => receipt.companyId == companyId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<ReceiptModel?> getReceiptById(String id) async {
    try {
      final box = await _getBox();
      final model = box.values.firstWhere(
        (receipt) => receipt.id == id,
      );
      return model;
    } catch (e) {
      logger.d('Error getting receipt by id: $e');
      return null;
    }
  }

  Future<bool> createReceipt(ReceiptModel receipt) async {
    try {
      final box = await _getBox();
      await box.put(receipt.id, receipt);
      return true;
    } catch (e) {
      logger.d('Error creating receipt: $e');
      return false;
    }
  }

  Future<bool> updateReceipt(ReceiptModel updatedReceipt) async {
    try {
      final box = await _getBox();
      if (box.containsKey(updatedReceipt.id)) {
        await box.put(updatedReceipt.id, updatedReceipt);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error updating receipt: $e');
      return false;
    }
  }

  Future<bool> deleteReceipt(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting receipt: $e');
      return false;
    }
  }

  Future<void> clearAllReceipts() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing Receipts: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.receiptBox)) {
      await Hive.close();
    }
  }
}
