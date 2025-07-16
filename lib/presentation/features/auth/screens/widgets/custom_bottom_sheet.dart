import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_pin_field/otp_pin_field.dart';

import '../../../../../core/utils/get_it_instance.dart';
import '../../domain/bloc/auth_bloc.dart';
import 'input_bottom_sheet.dart';
import 'otp_bottom_sheet.dart';

class CustomBottomSheet {
  static void showCustomBottomSheet({
    required GlobalKey<FormState> formKey,
    required BuildContext context,
    required String buttonText,
    required VoidCallback onButtonClicked,
    required String title,
    required bool isDisabled,
    String? subtitle,
    required List<BottomSheetData> bottomSheetData,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: InputBottomSheetWidget(
            isButtonDisabled: isDisabled,
            formKey: formKey,
            buttonText: buttonText,
            onButtonClicked: onButtonClicked,
            title: title,
            bottomSheetData: bottomSheetData,
          ),
        );
      },
    );
  }

  static void showOtpBottomSheet({
    required BuildContext context,
    required String buttonText,
    required VoidCallback onButtonClicked,
    required VoidCallback onResend,
    required bool isDisabled,
    required GlobalKey<OtpPinFieldState> controller,
    String? subtitle,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: BlocProvider.value(
            value: getIt.get<AuthBloc>(),
            child: OtpBottomSheet(
              onResend: onResend,
              buttonText: buttonText,
              onButtonClicked: onButtonClicked,
              controller: controller,
              isDisabled: isDisabled,
            ),
          ),
        );
      },
    );
  }
}

class BottomSheetData {
  final TextEditingController controller;
  final String hint;
  final String label;

  BottomSheetData({
    required this.controller,
    this.hint = '',
    this.label = '',
  });
}
