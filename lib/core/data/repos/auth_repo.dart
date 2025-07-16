import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

import '../../config/firebase/firebase_api.dart';
import '../../utils/logger.dart';
import '../apis/models/shared/user_model.dart';
import 'storage/user_storage.dart';

class AuthRepo {
  final FirebaseService firebaseApi;
  final UserStorage storageService;

  AuthRepo({
    required this.firebaseApi,
    required this.storageService,
  });

  UserModel? loggedInUser;
  String authToken = '';
  String? errorMessage;
  int? otpKey;
  UserCredential? userCredential;

  Future<String?> googleSignUp() async {
     final response = await firebaseApi.signInWithGoogle();
    if (response.isRight) {
      errorMessage = response.right.message;
      return null;
    } else {
      userCredential = response.left;
      Uint8List imageBytes = Uint8List(0);
      imageBytes =
          await fetchImage((userCredential?.user?.photoURL).toString());
      await storageService.createUser(
        UserModel(
          email: userCredential?.user?.email ?? '',
          firstName: userCredential?.user?.displayName ?? '',
          id: userCredential?.user?.uid.toString() ??
              DateTime.now().millisecondsSinceEpoch.toString(),
          userImage: imageBytes,
        ),
      );
      return 'sign up Successful';
    }
  }

  Future<Uint8List> fetchImage(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        return response.bodyBytes;
      }
    } catch (e) {
      return Uint8List(0);
    }
    return Uint8List(0);
  }

  Future<String?> emailSignUp(UserModel user) async {
    final response = await firebaseApi.signupWithEmailPassword(
        user.email, user.password, user.firstName);
    if (response.isRight) {
      errorMessage = response.right.message;
      return null;
    } else {
      userCredential = response.left;
      await storageService.createUser(UserModel(
        email: userCredential?.user?.email ?? '',
        firstName: userCredential?.user?.displayName ?? '',
        id: userCredential?.user?.uid ?? '',
      ));
      return 'sign up Successful';
    }
  }

  Future<String?> phoneSignUp(UserModel user) async {
    logger.d('auth repo');
    final response = await firebaseApi.signupWithPhone(user.phone);
    if (response.isRight) {
      errorMessage = response.right;
      return null;
    } else {
      userCredential = response.left;
      await storageService.createUser(UserModel(
        phone: userCredential?.user?.phoneNumber ?? '',
        id: userCredential?.user?.uid ?? '',
      ));
      return 'sign up Successful';
    }
  }

  Future<String?> emailLogin(UserModel user) async {
    final response =
    await firebaseApi.signInWithEmailPassword(user.email, user.password);
    if (response.isRight) {
      errorMessage = response.right.message;
      return null;
    } else {
      userCredential = response.left;
      await storageService.createUser(UserModel(
        email: userCredential?.user?.email ?? '',
        firstName: userCredential?.user?.displayName ?? '',
        id: userCredential?.user?.uid ?? '',
      ));
      return 'Login Successful';
    }
  }

  Future<String?> forgotPassword(String email) async {
    final response = await firebaseApi.forgotPassword(email);
    logger.d(response);
    if (response == null) {
      return null;
    } else {
      errorMessage = response.message;
      return 'error';
    }
  }
}