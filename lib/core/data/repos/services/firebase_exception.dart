enum FirebaseExceptionCodes {
  weakPassword(message: 'Weak Password', code: 'weak-password'),
  usedEmail(
      message: 'Email is used in another account',
      code: 'email-already-in-use'),
  noUserFound(message: 'No Account found with Email', code: 'user-not-found'),
  wrongPassword(message: 'Wrong Password', code: 'wrong-password'),
  notAllowed(message: 'Not Allowed', code: 'operation-not-allowed'),
  noAnonymousUser(message: 'No Anonymous User', code: 'noAnonymousUser'),
  providerAlreadyLinked(
      message: 'Provider Already Linked', code: 'provider-already-linked'),
  invalidCredential(message: 'Invalid Credential', code: 'invalid-credential'),
  credentialInUse(
      message: 'Credential In Use', code: 'credential-already-in-use'),
  other(message: 'Other', code: 'other'),
  invalidEmail(message: 'Invalid Email', code: 'invalid-email'),
  otpNotVerified(
      message: 'OTP not verified', code: 'otp-not-verified'); // ✅ Added this

  final String message;
  final String code;

  const FirebaseExceptionCodes({required this.message, required this.code});
}

FirebaseExceptionCodes firebaseExceptionCodesFromCode(String code) {
  return FirebaseExceptionCodes.values.firstWhere(
    (t) => t.code == code,
    orElse: () => FirebaseExceptionCodes.other,
  );
}
