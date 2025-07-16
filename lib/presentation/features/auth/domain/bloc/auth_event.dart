part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

class OnLoginEmailPassword extends AuthEvent {
  final String email;
  final String password;

  OnLoginEmailPassword({
    this.email = '',
    this.password = '',
  });
}

class OnPhoneSignUp extends AuthEvent {
  final String phone;

  OnPhoneSignUp({
    this.phone = '',
  });
}

class OnSignWithGoogle extends AuthEvent {
  OnSignWithGoogle();
}

class OnSignup extends AuthEvent {
  final String email;
  final String password;
  final String fullName;

  OnSignup({
    this.email = '',
    this.password = '',
    this.fullName = '',
  });
}

class OnVerifyOtp extends AuthEvent {
  final String otp;
  final String email;
  final bool isForgettingPassword;

  OnVerifyOtp({
    this.otp = '',
    this.email = '',
    this.isForgettingPassword = false,
  });
}

class OnForgotPassword extends AuthEvent {
  final String email;

  OnForgotPassword({
    this.email = '',
  });
}

class OnSendOtp extends AuthEvent {
  final String email;

  OnSendOtp({
    this.email = '',
  });
}

class OtpVerified extends AuthEvent {
  final String status;

  OtpVerified({
    this.status = '',
  });
}

class OnChangePassword extends AuthEvent {
  final String newPsw;

  OnChangePassword({
    this.newPsw = '',
  });
}
