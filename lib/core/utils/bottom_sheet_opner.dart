import 'package:flutter/material.dart';

void openBottomSheet<T>({
  required BuildContext context,
  required Widget child,
  Color? color,
}) {
  showModalBottomSheet<T>(
    barrierColor: Colors.transparent,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    isDismissible: true,
    enableDrag: true,
    context: context,
    builder: (context) => SafeArea(child: child),
  );
}
