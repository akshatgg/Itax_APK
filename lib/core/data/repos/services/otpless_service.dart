import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:otpless_flutter/otpless_flutter.dart';

import '../../../config/otpless/otpless_creds.dart';
import '../../../utils/logger.dart';

class OtplessService {
  final Otpless otpless = Otpless();

  String? otp;

  final _otplessStreamController = StreamController<String>.broadcast();

  Stream<String> get otplessStream => _otplessStreamController.stream;

  void notifyOtpReceived(String otp) {
    _otplessStreamController.add(otp);
  }

  void dispose() {
    _otplessStreamController.close();
  }

  void init() {
    otpless.initHeadless(OtplessCreds.appId);
    otpless.setHeadlessCallback(onHeadlessResult);
  }

  void onHeadlessResult(dynamic result) {
    logger.d('onHeadlessResult $result');
    otpless.commitHeadlessResponse(result);

    log('Full response: ${result.toString()}');

    final responseType = result['responseType'];
    logger.d('Response type: $responseType');

    if (responseType == 'VERIFY') {
      notifyOtpReceived(
        result['response']['verification'] as String? ?? 'FAILED',
      );
    }

    if (responseType == 'OTP_AUTO_READ') {
      otp = result['response']['otp'] as String;
      logger.d('Auto-read OTP: $otp');
      notifyOtpReceived(result['response']['status'] as String? ?? 'SUCCESS');
    } else if (responseType == 'INITIATE') {
      logger.d('OTP request initiated. Waiting for user input.');
    } else if (responseType == 'ONETAP') {
      logger.d('responseType: $responseType');
      notifyOtpReceived(result['response']['status'] as String? ?? 'SUCCESS');
    }
  }

  void sendOtp(String email) {
    logger.d('cdcdc');
    Map<String, dynamic> arg = {};
    arg['email'] = email;
    arg['otpLength'] = 4;
    arg['deliveryChannel'] = 'EMAIL';
    logger.d('sendOtp $arg');
    final jsonData = json.encode(arg);
    logger.d('jsonData $jsonData');
    otpless.startHeadless(onHeadlessResult, arg);
  }

  void verifyOtp(String email, String otp) {
    logger.d('verify');
    Map<String, dynamic> arg = {};
    arg['email'] = email;
    arg['otp'] = otp;
    otpless.startHeadless(onHeadlessResult, arg);
  }
}
