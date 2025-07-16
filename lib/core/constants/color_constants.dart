import 'package:flutter/material.dart';

class AppColor {
  static const Color appColor = Color(0xFF3C7CDD);
  static const Color white = Colors.white;
  static const Color black = Colors.black;
  static const Color red = Color(0xFFE11900);
  static const Color green = Color(0xFF4CB050);
  static const Color gradient1 = Color(0xFF3C7CDD);
  static const Color gradient2 = Color(0xFF43CEA2);
  static const Color grey = Color(0xFF707D8f);
  static const Color darkGrey = Color(0xFF373844);
  static const Color greyContainer = Color(0xFFF6F6F6);
  static const Color lightAppColor = Color(0xFFE9F2FF);
  static const Color lightRedColor = Color(0xFFFFF7F6);

  // Gradients
  static const LinearGradient blueToGreenGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xFF3C7CDD), // Start color
      Color(0xFF43CEA2), // End color
    ],
  );

  static const LinearGradient redGradient = LinearGradient(
    begin: Alignment(0.50, 0.00),
    end: Alignment(0.50, 1.00),
    colors: [Color(0xFFF96161), Color(0xFFE11E1E)],
  );

  static const LinearGradient greenGradient = LinearGradient(
    begin: Alignment(0.50, 0.00),
    end: Alignment(0.50, 1.00),
    colors: [Color(0xFF6BFF57), Color(0xFF2F7525)],
  );

  static const Color primary = Color(0xFF3C7CDD);
  static var secondary = const Color(0xFF8E8E93);
}
