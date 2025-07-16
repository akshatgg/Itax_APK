import 'package:hive/hive.dart';

import '../../../../presentation/features/reports/data/day_book.dart';
import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';

class DayBookStorage {
  Future<Box<DayBook>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.dayBookBox)) {
      return await Hive.openBox<DayBook>(HiveConstants.dayBookBox);
    }
    return Hive.box<DayBook>(HiveConstants.dayBookBox);
  }

  Future<List<DayBook>> getAllDayBooks(String companyId) async {
    try {
      final box = await _getBox();
      return box.values
          .where((dayBook) => dayBook.companyId == companyId)
          .toList();
    } catch (e) {
      logger.d('Error getting all DayBooks: $e');
      return [];
    }
  }

  Future<DayBook?> getDayBookById(String id) async {
    try {
      final box = await _getBox();
      final model = box.values.firstWhere(
        (dayBook) => dayBook.id == id,
      );
      return model;
    } catch (e) {
      logger.d('Error getting dayBook by id: $e');
      return null;
    }
  }

  Future<bool> createDayBook(DayBook dayBook) async {
    try {
      final box = await _getBox();
      await box.put(dayBook.id, dayBook);
      return true;
    } catch (e) {
      logger.d('Error creating dayBook: $e');
      return false;
    }
  }

  Future<bool> updateDayBook(DayBook updatedDayBook) async {
    try {
      final box = await _getBox();
      if (box.containsKey(updatedDayBook.id)) {
        await box.put(updatedDayBook.id, updatedDayBook);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error updating dayBook: $e');
      return false;
    }
  }

  Future<bool> deleteDayBook(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting dayBook: $e');
      return false;
    }
  }

  Future<void> clearAllDayBooks() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing DayBooks: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.dayBookBox)) {
      await Hive.close();
    }
  }
}
