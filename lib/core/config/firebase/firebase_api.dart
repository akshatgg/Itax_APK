import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:either_dart/either.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../../../../core/data/repos/services/firebase_exception.dart';
import '../../../../../core/utils/logger.dart';
class FirebaseService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();


  Future<Either<UserCredential, FirebaseExceptionCodes>>
      signInWithEmailPassword(
    String emailAddress,
    String password,
  ) async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );

      // Fetch user document from Firestore
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(credential.user!.uid)
          .get();

      // Check if isOtpVerified is true
      bool isOtpVerified = userDoc.data()?['isOtpVerified'] as bool? ?? false;

      if (isOtpVerified) {
        return Left(credential); // Login successful
      } else {
        // Sign out because user is not verified
        // await FirebaseAuth.instance.signOut();
        return const Right(FirebaseExceptionCodes.otpNotVerified);
      }
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return Right(firebaseExceptionCodesFromCode(e.code));
    }
  }

  Future<Either<UserCredential, FirebaseExceptionCodes>>
      signupWithEmailPassword(
    String emailAddress,
    String password,
    String fullName,
  ) async {
    try {
      final credential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailAddress,
        password: password,
      );
      credential.user?.updateDisplayName(fullName);
      await _saveUserToFireStore(credential.user);
      return Left(credential);
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return Right(firebaseExceptionCodesFromCode(e.code));
    }
  }

  Future<void> _saveUserToFireStore(User? user) async {
    logger.d(user);
    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'isOtpVerified': false,
        'createdAt': FieldValue.serverTimestamp(), // optional: store timestamp
      });
    }
  }

  Future<Either<UserCredential, String>> signupWithPhone(String phone) async {
    Completer<Either<UserCredential, String>> completer = Completer();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: '+91$phone',
      verificationCompleted: (PhoneAuthCredential credential) async {
        try {
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          logger.d('Auto sign-in successful');
          completer.complete(Left(userCredential));
        } catch (e) {
          completer.complete(Right('Auto sign-in failed: $e'));
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        logger.d('Verification failed: ${e.message}');
        completer.complete(Right(e.code));
      },
      codeSent: (String verId, int? resendToken) {
        logger.d('OTP sent to $phone. Please enter the code.');
        completer.complete(const Right('OTP sent'));
      },
      codeAutoRetrievalTimeout: (String verId) {
        logger.d('Auto retrieval timeout.');
        completer.complete(const Right('Auto retrieval timeout'));
      },
    );

    return completer.future;
  }

  Future<Either<UserCredential, FirebaseExceptionCodes>>
      signInAnonymous() async {
    try {
      final credential = await FirebaseAuth.instance.signInAnonymously();
      return Left(credential);
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return Right(firebaseExceptionCodesFromCode(e.code));
    }
  }

  Future<Either<UserCredential, FirebaseExceptionCodes>>
      convertAnnonymousWithEmail(
    String emailAddress,
    String password,
  ) async {
    try {
      final credential =
          EmailAuthProvider.credential(email: emailAddress, password: password);
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
      if (userCredential == null) {
        return const Right(FirebaseExceptionCodes.noAnonymousUser);
      }
      return Left(userCredential);
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return Right(firebaseExceptionCodesFromCode(e.code));
    }
  }

  Future<Either<UserCredential, FirebaseExceptionCodes>>
      convertAnnonymousWithGoogle(
    String emailAddress,
    String password,
  ) async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      final credential =
          GoogleAuthProvider.credential(idToken: googleAuth?.idToken);
      final userCredential = await FirebaseAuth.instance.currentUser
          ?.linkWithCredential(credential);
      if (userCredential == null) {
        return const Right(FirebaseExceptionCodes.noAnonymousUser);
      }
      return Left(userCredential);
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return Right(firebaseExceptionCodesFromCode(e.code));
    }
  }

  Future<Either<UserCredential, FirebaseExceptionCodes>>
      signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      return Left(userCredential);
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return Right(firebaseExceptionCodesFromCode(e.code));
    }
  }


  // Future<FirebaseExceptionCodes?> forgotPassword(String email) async {
  //   try {
  //     await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  //     return null;
  //   } on FirebaseAuthException catch (e) {
  //     logger.d(e.code);
  //     return firebaseExceptionCodesFromCode(e.code);
  //   }
  // }
  Future<FirebaseExceptionCodes?> forgotPassword(String email) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      logger.d(querySnapshot);
      if (querySnapshot.docs.isEmpty) {
        // You manually assign 'user-not-found' here — good!
        return FirebaseExceptionCodes.noUserFound;
      }

      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return firebaseExceptionCodesFromCode(e.code);
    } catch (e) {
      logger.e(e.toString());
      return FirebaseExceptionCodes.other;
    }
  }

  Future<FirebaseExceptionCodes?> changePassword(
    String email,
  ) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null;
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return FirebaseExceptionCodes.other;
    }
  }

  Future<FirebaseExceptionCodes?> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      logger.d(e.code);
      return FirebaseExceptionCodes.other;
    }
  }
}
