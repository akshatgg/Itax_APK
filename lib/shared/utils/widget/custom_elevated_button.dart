import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/color_constants.dart';
import 'base_button.dart';

class CustomElevatedButton extends BaseButton {
  const CustomElevatedButton({
    super.key,
    this.decoration,
    this.leftIcon,
    this.rightIcon,
    super.margin,
    super.onTap,
    super.buttonStyle,
    super.alignment,
    super.buttonTextStyle,
    super.isDisabled,
    super.height,
    super.width,
    super.buttonColor,
    super.textColor,
    required super.text,
  });

  final BoxDecoration? decoration;
  final Widget? leftIcon;
  final Widget? rightIcon;

  @override
  Widget build(BuildContext context) {
    return alignment != null
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: buildElevatedButtonWidget(),
          )
        : buildElevatedButtonWidget();
  }

  Widget buildElevatedButtonWidget() {
    return Container(
      height: height ?? 7.h,
      width: width ?? double.maxFinite,
      margin: margin,
      decoration: decoration,
      child: ElevatedButton(
        style: buttonStyle ??
            ElevatedButton.styleFrom(
              backgroundColor: buttonColor ?? AppColor.appColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.px),
              ),
            ),
        onPressed: isDisabled ?? false ? null : onTap ?? () {},
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            leftIcon ?? const SizedBox.shrink(),
            Text(
              text,
              style: buttonTextStyle ??
                  TextStyle(
                    color: textColor ?? AppColor.white,
                    fontFamily: 'poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.px,
                  ),
            ),
            rightIcon ?? const SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}
