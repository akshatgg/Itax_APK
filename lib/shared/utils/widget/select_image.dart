// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'snackbar/custom_snackbar.dart';

Future<File?> pickImage(BuildContext context) async {
  bool hasPermission = await requestPermissions();

  if (!hasPermission) {
    CustomSnackBar.showSnack(
      context: context,
      snackBarType: SnackBarType.error,
      message: 'Permission denied! Please enable access to pick an image.',
    );
    return null;
  }

  ImagePicker picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.gallery);

  if (photo != null) {
    return File(photo.path);
  } else {
    CustomSnackBar.showSnack(
      context: context,
      snackBarType: SnackBarType.error,
      message: 'No Image Selected',
    );
    return null;
  }
}

Future<bool> requestPermissions() async {
  if (Platform.isAndroid) {
    // Android 13+ (New Media Permissions)
    if (await Permission.photos.request().isGranted) {
      return true;
    }

    // Request storage permission (for Android 10 and below)
    var storageStatus = await Permission.storage.request();
    if (storageStatus.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    // For Android 11+ (Scoped Storage)
    var manageStatus = await Permission.manageExternalStorage.request();
    if (manageStatus.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }

    return storageStatus.isGranted || manageStatus.isGranted;
  }

  if (Platform.isIOS) {
    // Request photo library permission
    var photoStatus = await Permission.photos.request();
    if (photoStatus.isPermanentlyDenied) {
      openAppSettings();
      return false;
    }
    return photoStatus.isGranted;
  }

  return false;
}
