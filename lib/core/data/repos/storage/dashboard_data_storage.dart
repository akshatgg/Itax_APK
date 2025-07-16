import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/dashboard/dashboard_data_model.dart';

class DashboardDataStorage {
  Future<Box<DashboardDataModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.dashboardDataBox)) {
      return await Hive.openBox<DashboardDataModel>(
          HiveConstants.dashboardDataBox);
    }
    return Hive.box<DashboardDataModel>(HiveConstants.dashboardDataBox);
  }

  Future<List<DashboardDataModel>> getAllDashboardData() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      logger.d('Error getting all dashboard data: $e');
      return [];
    }
  }

  Future<DashboardDataModel?> getDashboardData() async {
    try {
      final box = await _getBox();
      final dashboardData = box.isNotEmpty ? box.values.first : null;

      if (dashboardData != null) {
        return dashboardData;
      } else {
        return null;
      }
    } catch (e) {
      logger.d('Error getting dashboard data: $e');
      return null;
    }
  }

  Future<bool> createDashboardData(DashboardDataModel dashboardData) async {
    try {
      final box = await _getBox();

      await box.put(dashboardData.id, dashboardData);
      return true;
    } catch (e) {
      logger.d('Error creating dashboard data: $e');
      return false;
    }
  }

  Future<bool> updateDashboardData(
      DashboardDataModel updatedDashboardData) async {
    try {
      final box = await _getBox();

      await box.put(updatedDashboardData.id, updatedDashboardData);
      logger
          .d('Dashboard data updated successfully: ${updatedDashboardData.id}');
      return true;
    } catch (e) {
      logger.d('Error updating dashboard data: $e');
      return false;
    }
  }

  Future<bool> deleteDashboardData(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting dashboard data: $e');
      return false;
    }
  }

  Future<void> clearAllDashboardData() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing dashboard data: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.dashboardDataBox)) {
      await Hive.close();
    }
  }
}
