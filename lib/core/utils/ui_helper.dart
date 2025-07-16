import 'package:flutter/material.dart';
import '../../../shared/utils/widget/snackbar/custom_snackbar.dart';
import 'custom_animated_toast.dart';

void showErrorSnackBar({
  required BuildContext context,
  required String message,
}) {
  CustomAnimatedToast.show(
    context: context,
    message: message,
    type: ToastType.error,
  );
}

void showSuccessSnackBar({
  required BuildContext context,
  required String message,
}) {
  CustomAnimatedToast.show(
    context: context,
    message: message,
    type: ToastType.success,
  );
}