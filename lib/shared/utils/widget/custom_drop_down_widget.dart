import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';

class CustomDropdown extends StatelessWidget {
  final List<String> items;
  final String hintText;
  final IconData icon;
  final ValueNotifier<String> selectedValue;
  final double borderRadius;
  final String? title;
  final String? message;
  final FormFieldValidator<String>? validator;

  const CustomDropdown({
    super.key,
    this.message,
    this.title,
    required this.items,
    required this.selectedValue,
    this.hintText = 'Select an item',
    this.icon = Icons.arrow_drop_down,
    this.validator,
    this.borderRadius = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: AppTextStyle.pw400.copyWith(
              color: Colors.grey.shade600,
              fontSize: 16.px,
            ),
          ),
        if (title != null) SizedBox(height: 1.h),
        DropdownButtonFormField<String>(
          isDense: true,
          decoration: InputDecoration(
            errorStyle: AppTextStyle.pw400.copyWith(
              fontSize: 12.px,
              color: Colors.red,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: AppColor.grey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: AppColor.grey,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(borderRadius),
              borderSide: const BorderSide(
                color: AppColor.grey,
              ),
            ),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return message;
            }
            return null;
          },
          // Keep validator here
          dropdownColor: AppColor.white,
          borderRadius: BorderRadius.circular(10.px),
          value: selectedValue.value.isEmpty ? null : selectedValue.value,
          hint: Text(hintText),
          icon: Icon(icon, color: Colors.grey.shade600),
          isExpanded: true,
          onChanged: (newValue) {
            selectedValue.value = newValue!;
          },
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item,
                        style: AppTextStyle.pw500.copyWith(
                          fontSize: 14.px,
                          color: AppColor.grey,
                        )),
                  ))
              .toList(),
        ),
      ],
    );
  }
}
