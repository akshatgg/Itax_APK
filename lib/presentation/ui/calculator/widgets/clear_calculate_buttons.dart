// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';

class ClearCalculateButtons extends StatelessWidget {
  final VoidCallback onClearPressed;
  final VoidCallback onCalculatePressed;

  const ClearCalculateButtons({
    Key? key,
    required this.onClearPressed,
    required this.onCalculatePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 76,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: const BoxDecoration(color: AppColor.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Clear Button
          Expanded(
            child: GestureDetector(
              onTap: onClearPressed,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  gradient: AppColor.redGradient,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Clear',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.pw600.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 18), // Spacing between buttons
          // Calculate Button
          Expanded(
            child: GestureDetector(
              onTap: onCalculatePressed,
              child: Container(
                height: 44,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: ShapeDecoration(
                  gradient: AppColor.greenGradient,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Center(
                  child: Text(
                    'Calculate',
                    textAlign: TextAlign.center,
                    style: AppTextStyle.pw600.copyWith(
                      color: AppColor.white,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
