import 'package:hive/hive.dart';

import '../../../config/hive/hive_constants.dart';
import '../../../utils/logger.dart';
import '../../apis/models/shared/user_model.dart';

class UserStorage {
  Future<Box<UserModel>> _getBox() async {
    if (!Hive.isBoxOpen(HiveConstants.userBox)) {
      return await Hive.openBox<UserModel>(HiveConstants.userBox);
    }
    return Hive.box<UserModel>(HiveConstants.userBox);
  }

  Future<List<UserModel>> getAllUser() async {
    try {
      final box = await _getBox();
      return box.values.toList();
    } catch (e) {
      logger.d('Error getting all users: $e');
      return [];
    }
  }

  Future<UserModel?> getUser() async {
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

  Future<bool> createUser(UserModel user) async {
    try {
      final box = await _getBox();

      // Check if the email already exists
      bool emailExists =
          box.values.any((existingUser) => existingUser.email == user.email);

      if (emailExists) {
        logger.d('User with email ${user.email} already exists.');
        return false;
      }

      // If email does not exist, add the user
      await box.put(user.id, user);
      return true;
    } catch (e) {
      logger.d('Error creating user: $e');
      return false;
    }
  }

  Future<bool> updateUser(UserModel updatedUser) async {
    try {
      final box = await _getBox();

      // Check if the user exists in the database
      if (!box.containsKey(updatedUser.id)) {
        logger.d('User with ID ${updatedUser.id} not found.');
        return false;
      }

      // Get existing user and update fields using copyWith
      final existingUser = box.get(updatedUser.id) as UserModel;
      final newUser = existingUser.copyWith(
          firstName: updatedUser.firstName,
          lastName: updatedUser.lastName,
          email: updatedUser.email,
          phone: updatedUser.phone,
          password: updatedUser.password,
          gender: updatedUser.gender,
          aadhaar: updatedUser.aadhaar,
          pan: updatedUser.pan,
          pin: updatedUser.pin,
          isBusinessProfile: updatedUser.isBusinessProfile,
          gst: updatedUser.gst,
          flatNo: updatedUser.flatNo,
          buildingNo: updatedUser.buildingNo,
          buildingName: updatedUser.buildingName,
          street: updatedUser.street,
          area: updatedUser.area,
          city: updatedUser.city,
          state: updatedUser.state,
          userImage: updatedUser.userImage,
          businessName: updatedUser.businessName,
          bStatus: updatedUser.bStatus,
          tan: updatedUser.tan,
          tradeName: updatedUser.tradeName,
          businessAddress: updatedUser.businessAddress,
          businessState: updatedUser.businessState);

      // Save updated user
      await box.put(updatedUser.id, newUser);
      logger.d('User updated successfully: ${newUser.userImage}');
      return true;
    } catch (e) {
      logger.d('Error updating user: $e');
      return false;
    }
  }

  Future<bool> deleteUser(String id) async {
    try {
      final box = await _getBox();
      if (box.containsKey(id)) {
        await box.delete(id);
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
    if (Hive.isBoxOpen(HiveConstants.userBox)) {
      await Hive.close();
    }
  }
}
