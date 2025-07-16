import '../../utils/logger.dart';
import '../apis/models/shared/user_model.dart';
import 'storage/user_storage.dart';

class UserRepo {
  final UserStorage storageService;

  UserRepo({required this.storageService});

  String? errorMessage;

  Future<UserModel?> getUser() async {
    try {
      final user = await storageService.getUser();
      if (user != null) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<UserModel?> createUser(UserModel user) async {
    try {
      final response = await storageService.createUser(user);
      if (response) {
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// **Update User**
  Future<UserModel?> updateUser(UserModel user) async {
    try {
      final response = await storageService.updateUser(user);
      logger.d(response);
      if (response) {
        final updatedUser = await storageService.getUser();
        logger.d('in atuth repo${updatedUser?.businessName}');
        return updatedUser;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}
