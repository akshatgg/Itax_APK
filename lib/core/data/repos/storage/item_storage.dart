import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/items/item_model.dart';

class ItemStorage {
  Future<Box<ItemModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.itemBox)) {
      return await Hive.openBox<ItemModel>(HiveConstants.itemBox);
    }
    return Hive.box<ItemModel>(HiveConstants.itemBox);
  }

  Future<List<ItemModel>> getAllItems(String companyId) async {
    try {
      final box = await _getBox();
      return box.values.where((item) => item.companyId == companyId).toList();
    } catch (e) {
      logger.d('Error getting all items: $e');
      return [];
    }
  }

  Future<ItemModel?> getItemById(String id) async {
    try {
      final box = await _getBox();
      final model = box.values.firstWhere(
        (item) => item.id == id,
      );
      return model;
    } catch (e) {
      logger.d('Error getting item by id: $e');
      return null;
    }
  }

  Future<bool> createItem(ItemModel item) async {
    try {
      final box = await _getBox();
      await box.put(item.id, item);
      return true;
    } catch (e) {
      logger.d('Error creating item: $e');
      return false;
    }
  }

  Future<bool> updateItem(ItemModel updatedItem) async {
    try {
      final box = await _getBox();
      if (box.containsKey(updatedItem.id)) {
        await box.put(updatedItem.id, updatedItem);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error updating item: $e');
      return false;
    }
  }

  Future<bool> deleteItem(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting item: $e');
      return false;
    }
  }

  Future<void> clearAllItems() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing items: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.itemBox)) {
      await Hive.close();
    }
  }
}
