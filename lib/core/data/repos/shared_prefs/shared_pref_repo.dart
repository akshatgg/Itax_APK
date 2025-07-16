import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../constants/shared_pref_keys.dart';
import '../../../utils/logger.dart';
import 'last_login.dart';

class SharedPrefRepository {
  LastLogin? lastLogin;

  void saveCurrentCompany(String companyId) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString(
      SharefPrefKeys.currentCompanyKey,
      companyId,
    );
    logger.i('saveCurrentCompany: $companyId');
  }

  Future<String> getCurrentCompany() async {
    var instance = await SharedPreferences.getInstance();
    final companyId = instance.getString(SharefPrefKeys.currentCompanyKey);
    logger.i('getCurrentCompany: $companyId');
    return companyId ?? '';
  }

  void saveLastLogin(LastLogin lastLogin) async {
    var instance = await SharedPreferences.getInstance();
    await instance.setString(
      SharefPrefKeys.lastLoginKey,
      json.encode(lastLogin.toJson()),
    );
    this.lastLogin = lastLogin;
  }

  Future<void> getLastLoginInfo() async {
    var instance = await SharedPreferences.getInstance();
    if (instance.containsKey(SharefPrefKeys.lastLoginKey)) {
      var data = instance.getString(SharefPrefKeys.lastLoginKey);
      if (data == null) {
        lastLogin = null;
        return;
      }
      lastLogin = LastLogin.fromJson(json.decode(data) as Map<String, dynamic>);
    } else {
      lastLogin = null;
    }
  }

  void clearAllData() async {
    var instance = await SharedPreferences.getInstance();
    await instance.clear();
  }
}
