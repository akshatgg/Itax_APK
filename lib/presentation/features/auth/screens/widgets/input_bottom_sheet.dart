import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/utils/input_validations.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../../shared/utils/widget/custom_textfield.dart';
import 'custom_bottom_sheet.dart';

class InputBottomSheetWidget extends StatelessWidget {
  const InputBottomSheetWidget({
    super.key,
    required this.buttonText,
    required this.onButtonClicked,
    required this.title,
    this.subtitle,
    required this.bottomSheetData,
    required this.formKey,
    required this.isButtonDisabled,
  });

  final String buttonText;
  final VoidCallback onButtonClicked;
  final String title;
  final bool isButtonDisabled;
  final String? subtitle;
  final GlobalKey<FormState> formKey;
  final List<BottomSheetData> bottomSheetData;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.center,
              child: IconButton(
                icon: Container(
                    height: 27.px,
                    width: 27.px,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Color(0XFFCCCCCC)),
                    child: const Icon(Icons.close)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 1.h),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  SizedBox(height: 2.h),
                  Form(
                    key: formKey,
                    child: Column(
                      children: bottomSheetData
                          .map(
                            (sheetData) => CustomTextfield(
                              controller: sheetData.controller,
                              lable: sheetData.label,
                              hint: sheetData.hint,
                              validator: (value) =>
                                  InputValidator.hasValue<String>(value),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 2.h),
                  CustomElevatedButton(
                    text: buttonText,
                    onTap: onButtonClicked,
                    height: 44.px,
                    isDisabled: isButtonDisabled,
                  ),
                  SizedBox(height: 2.h),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
