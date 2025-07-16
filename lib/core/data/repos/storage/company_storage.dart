import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/company/company_model.dart';

class CompanyStorage {
  Future<Box<CompanyModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.companyBox)) {
      return await Hive.openBox<CompanyModel>(HiveConstants.companyBox);
    }
    return Hive.box<CompanyModel>(HiveConstants.companyBox);
  }

  Future<List<CompanyModel>> getAllCompany() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      logger.d('Error getting all users: $e');
      return [];
    }
  }

  Future<CompanyModel?> getCompany() async {
    try {
      final box = await _getBox();
      final user = box.isNotEmpty ? box.values.first : null;

      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      logger.d('Error getting user: $e');
      return null;
    }
  }

  Future<bool> createCompany(CompanyModel company) async {
    try {
      final box = await _getBox();
      await box.put(company.id, company);
      return true;
    } catch (e) {
      logger.d('Error creating user: $e');
      return false;
    }
  }

  Future<bool> updateCompany(CompanyModel updatedCompany) async {
    try {
      final box = await _getBox();

      // Check if the user exists in the database
      if (!box.containsKey(updatedCompany.id)) {
        logger.d('User with ID ${updatedCompany.id} not found.');
        return false;
      }

      // Get existing user and update fields using copyWith
      final existingUser = box.get(updatedCompany.id) as CompanyModel;
      final newUser = existingUser.copyWith(
        companyName: updatedCompany.companyName,
        companyPhone: updatedCompany.companyPhone,
        companyEmail: updatedCompany.companyEmail,
        companyAddress: updatedCompany.companyAddress,
        companyState: updatedCompany.companyState,
        companyPincode: updatedCompany.companyPincode,
        companyImage: updatedCompany.companyImage,
      );

      // Save updated user
      await box.put(updatedCompany.id, newUser);
      logger.d('User updated successfully: ${newUser.companyImage}');
      return true;
    } catch (e) {
      logger.d('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteCompany(String id) async {
    try {
      final box = await _getBox();
      var containsKey = box.containsKey(id);
      logger.d('deleteCompany: $id $containsKey');
      if (containsKey) {
        await box.delete(id);
        var containsKey2 = box.containsKey(id);
        logger.d('after deleteCompany: $id $containsKey2');
        return true;
      }
      return false;
    } catch (e) {
      logger.d('Error deleting user: $e');
      return false;
    }
  }

  Future<void> clearAllUser() async {
    try {
      final box = await _getBox();
      await box.clear();
    } catch (e) {
      logger.d('Error clearing users: $e');
    }
  }

  Future<void> close() async {
    if (Hive.isBoxOpen(HiveConstants.companyBox)) {
      await Hive.close();
    }
  }
}
