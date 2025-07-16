// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

class AuthInitial extends AuthState {}

class ProcessLoading extends AuthState {}

class LoggedInSuccess extends AuthState {

}

class SignUpSuccess extends AuthState {}

class SignUpFailure extends AuthState {
  final String reason;

  SignUpFailure({
    this.reason = '',
  });

  @override
  String toString() => 'SignUpFailure(reason: $reason)';
}

class LoggedInFailure extends AuthState {
  final String reason;
  final bool isForgettingPassword;

  LoggedInFailure({
    this.reason = '',
    this.isForgettingPassword = false,
  });

  @override
  String toString() =>
      'LoggedInFailure(reason: $reason, isForgettingPassword: $isForgettingPassword)';
}

class OtpSent extends AuthState {
  final bool isForgettingPassword;

  OtpSent({
    this.isForgettingPassword = false,
  });

  @override
  String toString() => 'OtpSent(isForgettingPassword: $isForgettingPassword)';
}

class OtpVerifyFailed extends AuthState {
  final String reason;
  final bool isForgettingPassword;

  OtpVerifyFailed({
    this.reason = '',
    this.isForgettingPassword = false,
  });

  @override
  String toString() => 'OtpVerifyFailed(reason: $reason)';
}

class OtpSentFailed extends AuthState {
  final String reason;

  OtpSentFailed({
    this.reason = '',
  });

  @override
  String toString() => 'OtpSentFailed(reason: $reason)';
}

class PasswordForgetSuccess extends AuthState {}

class PasswordForgetFailure extends AuthState {
  final String reason;

  PasswordForgetFailure({
    this.reason = '',
  });

  @override
  String toString() => 'PasswordForgetFailure(reason: $reason)';
}

class PasswordChangeSuccess extends AuthState {}

class PasswordChangeFailure extends AuthState {
  final String reason;

  PasswordChangeFailure({
    this.reason = '',
  });

  @override
  String toString() => 'PasswordChangeFailure(reason: $reason)';
}
