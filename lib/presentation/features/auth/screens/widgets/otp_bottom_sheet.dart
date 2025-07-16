import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/strings_constants.dart';
import '../../../../../core/utils/logger.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../domain/bloc/auth_bloc.dart';

class OtpBottomSheet extends HookWidget {
  const OtpBottomSheet({
    super.key,
    required this.buttonText,
    required this.onButtonClicked,
    required this.controller,
    required this.isDisabled,
    required this.onResend,
  });

  final String buttonText;
  final VoidCallback onButtonClicked;
  final VoidCallback onResend;
  final GlobalKey<OtpPinFieldState> controller;
  final bool isDisabled;

  @override
  Widget build(BuildContext context) {
    final errorMessage = useState('');
    context.watch<AuthBloc>();
    logger.d('isDisabled : $isDisabled');
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        logger.d('OtpBottomSheet state: $state');
        if (state is LoggedInFailure) {
          errorMessage.value = state.reason;
        }
        if (state is OtpSentFailed) {
          errorMessage.value = state.reason;
        }
      },
      child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              const BoxShadow(
                color: Colors.black12,
                blurRadius: 10,
                spreadRadius: 2,
                offset: Offset(0, 5), // Shadow only at the top
              )
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (errorMessage.value.isNotEmpty)
                Text(
                  errorMessage.value,
                  style: AppTextStyle.pw500
                      .copyWith(fontSize: 14.px, color: AppColor.red),
                ),
              const Text(
                AppStrings.enterOtp,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),

              // Subtitle
              Text(
                AppStrings.otpInstruction,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 2.h),
              // Email Input Field
              OtpPinField(
                key: controller,
                autoFillEnable: false,
                autoFocus: false,
                onSubmit: (text) {},
                onChange: (text) {},
                onCodeChanged: (code) {},
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
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.didntGetOtp,
                    style: AppTextStyle.pw500
                        .copyWith(fontSize: 14.px, color: AppColor.black),
                  ),
                  GestureDetector(
                    onTap: onResend,
                    child: Text(
                      AppStrings.resendOtp,
                      style: AppTextStyle.pw500
                          .copyWith(fontSize: 14.px, color: AppColor.appColor),
                    ),
                  )
                ],
              ),
              SizedBox(height: 2.h),
              // Save Button
              CustomElevatedButton(
                isDisabled: isDisabled,
                text: buttonText,
                onTap: () {
                  logger.d('onButtonClicked');
                  onButtonClicked();
                },
                height: 44.px,
              )
            ],
          ),
        ),
      ),
    );
  }
}
