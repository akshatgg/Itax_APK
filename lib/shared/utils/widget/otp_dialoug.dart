import 'package:flutter/material.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/utils/logger.dart';
import 'change_detail_dialog.dart';
import 'custom_elevated_button.dart';

void otpDialog(
  BuildContext context, {
  required void Function(String otp) onSave, // Pass OTP as a parameter
}) {
  String otpValue = ''; // Store entered OTP

  commonBottomSheet(
    context,
    child: Container(
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.h),

          // Title
          const Text(
            'Enter OTP',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 1.h),

          // Subtitle
          Text(
            'Enter the 4 digits code that you received on your Mobile Number or Email.',
            style: TextStyle(color: Colors.grey[600]),
          ),
          SizedBox(height: 2.h),

          // OTP Input Field
          OtpPinField(
            autoFillEnable: false,
            autoFocus: false,
            onSubmit: (text) {
              otpValue = text;
              logger.d('Entered pin is $otpValue');
            },
            onChange: (text) {
              otpValue = text; // Update value on change
              logger.d('Enter on change pin is $otpValue');
            },
            otpPinFieldStyle: OtpPinFieldStyle(
              showHintText: true,
              filledFieldBorderColor: AppColor.appColor,
              activeFieldBackgroundColor: AppColor.white,
              filledFieldBackgroundColor: AppColor.white,
              defaultFieldBackgroundColor: AppColor.white,
              fieldBorderWidth: 1,
              activeFieldBorderColor: AppColor.appColor,
              defaultFieldBorderColor: Colors.grey.shade400,
              textStyle: AppTextStyle.pw500,
            ),
            maxLength: 4,
            showCursor: true,
            cursorColor: AppColor.appColor,
            showCustomKeyboard: false,
            cursorWidth: 3,
            mainAxisAlignment: MainAxisAlignment.center,
            highlightBorder: true,
            showDefaultKeyboard: true,
            otpPinFieldDecoration:
                OtpPinFieldDecoration.defaultPinBoxDecoration,
          ),
          SizedBox(height: 2.h),

          // Resend OTP Text
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Didn’t get OTP Code?',
                style: AppTextStyle.pw500
                    .copyWith(fontSize: 14.px, color: AppColor.black),
              ),
              Text(
                '  Resend OTP',
                style: AppTextStyle.pw500
                    .copyWith(fontSize: 14.px, color: AppColor.appColor),
              )
            ],
          ),
          SizedBox(height: 2.h),

          // Save Button
          CustomElevatedButton(
            text: 'Save',
            onTap: () {
              if (otpValue.length == 4) {
                // Ensure OTP is fully entered
                onSave(otpValue);
              } else {
                logger.d('Invalid OTP');
              }
            },
            height: 44.px,
          ),
          SizedBox(height: 2.h),
        ],
      ),
    ),
  );
}
