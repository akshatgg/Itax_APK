import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/data/apis/models/shared/user_model.dart';
import '../../../../../core/data/repos/auth_repo.dart';
import '../../../../../core/data/repos/services/otpless_service.dart';
import '../../../../../core/utils/logger.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepo authRepo;
  final OtplessService otplessService;
  StreamSubscription<String>? _otplessSubscription;

  bool isForgettingPassword = false;

  AuthBloc(
    this.authRepo,
    this.otplessService,
  ) : super(AuthInitial()) {
    on<OnLoginEmailPassword>(_onLoginEmailPassword);
    on<OnSignup>(_onSignup);
    on<OnSignWithGoogle>(_onGoogleSignIn);
    on<OnVerifyOtp>(_onVerifyOtp);
    on<OnForgotPassword>(_onForgotPassword);
    on<OnSendOtp>(_onSendOtp);
    on<OnPhoneSignUp>(_onPhoneSignup);
    on<OtpVerified>(_onOtpVerified);

    _otplessSubscription = otplessService.otplessStream.listen((otp) {
      logger.d('otp: $otp');
      add(OtpVerified(status: otp));
    });
  }

  @override
  Future<void> close() {
    _otplessSubscription?.cancel();
    return super.close();
  }

  Future<void> _onOtpVerified(
    OtpVerified event,
    Emitter<AuthState> emit,
  ) async {
    logger.d('_onOtpVerified event.status: ${event.status}');
    if (event.status == 'SUCCESS' || event.status == 'COMPLETED') {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'isOtpVerified': true});
      }
      if (isForgettingPassword) {
        emit(PasswordForgetSuccess());
      } else {
        emit(LoggedInSuccess());
      }
    } else {
      emit(LoggedInFailure(reason: AppStrings.otpError));
    }
  }

  Future<void> _onSendOtp(
    OnSendOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      logger.d('_onSendOtp event.email: ${event.email}');
      otplessService.sendOtp(event.email);
      emit(OtpSent(isForgettingPassword: true));
    } catch (e) {
      logger.e('_onSendOtp $e');
      emit(OtpSentFailed(reason: AppStrings.otpFailedToSend));
    }
  }

  Future<void> _onLoginEmailPassword(
    OnLoginEmailPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      UserModel user = UserModel(
        email: event.email,
        password: event.password,
      );
      final response = await authRepo.emailLogin(user);
      if (response == AppStrings.loginSuccessful) {
        emit(LoggedInSuccess());
      } else {
        if (authRepo.errorMessage == AppStrings.otpNotVerified) {
          otplessService.sendOtp(event.email);
          emit(OtpSent(isForgettingPassword: false));
        } else {
          emit(LoggedInFailure(
              reason: authRepo.errorMessage ?? AppStrings.loginFailed));
        }
      }
    } catch (e) {
      logger.e('OnLoginEmailPassword $e');
      emit(LoggedInFailure(reason: AppStrings.loginFailed));
    }
  }

  Future<void> _onGoogleSignIn(
    OnSignWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final response = await authRepo.googleSignUp();

      if (response == AppStrings.signupSuccessful) {
        emit(LoggedInSuccess());
      } else {
        logger.e(authRepo.errorMessage);
        emit(LoggedInFailure(
            reason: authRepo.errorMessage ?? AppStrings.loginFailed));
      }
    } catch (e) {
      logger.e('OnGoogleSignIn $e');
      emit(LoggedInFailure(reason: AppStrings.loginFailed));
    }
  }

  Future<void> _onSignup(
    OnSignup event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      var fullName = event.fullName.split(' ');
      UserModel user = UserModel(
        email: event.email,
        password: event.password,
        firstName: fullName.isNotEmpty ? fullName[0] : event.fullName,
        lastName: fullName.length > 1 ? fullName[1] : event.fullName,
      );
      final response = await authRepo.emailSignUp(user);
      if (response == AppStrings.signupSuccessful) {
        otplessService.sendOtp(event.email);
        emit(OtpSent(isForgettingPassword: false));
      } else {
        emit(LoggedInFailure(
            reason: authRepo.errorMessage ?? AppStrings.signupFailed));
      }
    } catch (e) {
      logger.e('OnSignup $e');
      emit(LoggedInFailure(reason: AppStrings.signupFailed));
    }
  }

  Future<void> _onPhoneSignup(
    OnPhoneSignUp event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      UserModel user = UserModel(
        phone: event.phone,
      );
      final response = await authRepo.phoneSignUp(user);
      if (response == AppStrings.signupSuccessful) {
        emit(OtpSent(isForgettingPassword: false));
      } else {
        emit(LoggedInFailure(
            reason: authRepo.errorMessage ?? AppStrings.loginFailed));
      }
    } catch (e) {
      logger.e('OnPhoneSignup $e');
      emit(LoggedInFailure(reason: AppStrings.signupFailed));
    }
  }

  Future<void> _onVerifyOtp(
    OnVerifyOtp event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      logger.d('Verifying OTP');
      otplessService.verifyOtp(
        event.email,
        event.otp,
      );

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        emit(OtpVerifyFailed(reason: AppStrings.userNotSignedIn));
        return;
      }

      if (event.isForgettingPassword) {
        isForgettingPassword = true;
      }

      emit(ProcessLoading());
    } catch (e) {
      logger.e('OnVerifyOtp $e');
      emit(OtpVerifyFailed(reason: AppStrings.otpError));
    }
  }

  Future<void> _onForgotPassword(
    OnForgotPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(ProcessLoading());
    try {
      final response = await authRepo.forgotPassword(event.email);
      if (response == null) {
        emit(PasswordForgetSuccess());
      } else {
        emit(PasswordForgetFailure(
            reason: authRepo.errorMessage ?? AppStrings.passwordForgetFailed));
      }
    } catch (e) {
      logger.e('OnForgotPassword $e');
      emit(PasswordForgetFailure(reason: AppStrings.passwordForgetFailed));
    }
  }
}
