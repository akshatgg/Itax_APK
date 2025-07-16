import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';

class CustomTextfield extends HookWidget {
  final bool obsecure;
  final TextEditingController controller;
  final String lable;
  final String hint;
  final Widget suffixWidget;
  final int maxLine;
  final bool read;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final void Function(String)? onChanged;
  final TextInputAction? textInputAction;
  final void Function(String)? onFieldSubmitted;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> inputFormatters;
  final FocusNode? focusNode;

  const CustomTextfield({
    super.key,
    this.suffixWidget = const SizedBox(),
    this.focusNode,
    this.read = false,
    this.maxLine = 1,
    this.obsecure = false,
    required this.controller,
    required this.lable,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.onChanged,
    this.textInputAction,
    this.onFieldSubmitted,
    this.textCapitalization = TextCapitalization.none,
    this.inputFormatters = const [],
  });

  @override
  Widget build(BuildContext context) {
    final isObsecure = useState(true);

    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.px),
      borderSide: const BorderSide(
        color: AppColor.grey,
      ),
    );

    return TextFormField(
      focusNode: focusNode,
      autofocus: false,
      maxLines: maxLine,
      textCapitalization: textCapitalization,
      inputFormatters: inputFormatters,
      readOnly: read,
      obscureText: obsecure && isObsecure.value,
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: textInputAction ?? TextInputAction.next,
      style: AppTextStyle.pw500.copyWith(
        fontSize: 14.px,
        color: AppColor.grey,
      ),
      onFieldSubmitted: onFieldSubmitted,
      onChanged: onChanged,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(
          horizontal: 3.w,
          vertical: 1.h,
        ),
        suffixIcon: obsecure
            ? IconButton(
                onPressed: () => isObsecure.value = !isObsecure.value,
                icon: Icon(
                  isObsecure.value ? Icons.visibility : Icons.visibility_off,
                  color: AppColor.grey,
                ),
              )
            : suffixWidget,
        hintText: hint,
        label: lable.isEmpty
            ? null
            : Text(
                lable,
                style: AppTextStyle.pw500.copyWith(
                  fontSize: 14.px,
                  color: AppColor.grey,
                ),
              ),
        errorStyle: AppTextStyle.pw400.copyWith(
          fontSize: 12.px,
          color: Colors.red,
        ),
        hintStyle: AppTextStyle.pw500.copyWith(
          fontSize: 14.px,
          color: AppColor.grey,
        ),
        border: border,
        enabledBorder: border,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: border,
      ),
      validator: validator,
    );
  }
}
