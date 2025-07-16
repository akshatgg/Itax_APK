import '../../constants/network_constants.dart';

class ApiRoutes {
  static const String signup = '$networkUrl/user/sign-up';
  static const String login = '$networkUrl/user/login';
  static const String verify = '$networkUrl/user/verify';
  static const String forgotPassword = '$networkUrl/user/forgot-password';
  static const String sendOtp = '$networkUrl/user/send-otp';
  static const String changePassword = '$networkUrl/user/change-password';
  static const String updateProfile = '$networkUrl/user/update';
  static const String resendOtp = '$networkUrl/user/resendotp';
  static const String getUserProfile = '$networkUrl/user/profile';
  static const String gettoken = '$networkUrl/user/gettoken';
  static const String changeusertype = '$networkUrl/user/changeusertype';
  static const String googlesignup = '$networkUrl/user/googlesignup';
  static const String googlelogin = '$networkUrl/user/googlelogin';

  static const String parties = '$networkUrl/invoice/parties/';
  static const String items = '$networkUrl/invoice/items/';
  static const String invoices = '$networkUrl/invoice/invoices/';
  static const String gstValidation =
      'http://sheet.gstincheck.co.in/check/i6ZdJHJ3X4kGufYlnAfcC11o58mI0Cpq/';
  static const String gstCredits =
      'http://sheet.gstincheck.co.in/balance/0223157c4ba7afaf34f59d6b98cec897/';
}
