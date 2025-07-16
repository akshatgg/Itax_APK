import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import 'custom_elevated_button.dart';

Future<void> showLogOutDialog(BuildContext context,
    {String? title,
    required VoidCallback onCancel,
    required VoidCallback onYes}) {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      backgroundColor: AppColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.px)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.pw600
                .copyWith(fontSize: 16.px, color: AppColor.black),
          ),
          SizedBox(
            height: 2.h,
          ),
          Row(
            children: [
              Expanded(
                child: CustomElevatedButton(
                  text: 'Yes',
                  onTap: onYes,
                  textColor: AppColor.white,
                  height: 40.px,
                  width: 135.px,
                  buttonStyle: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.appColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.px))),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              Expanded(
                child: CustomElevatedButton(
                  text: 'Cancel',
                  onTap: onCancel,
                  textColor: AppColor.appColor,
                  height: 40.px,
                  width: 135.px,
                  buttonStyle: ElevatedButton.styleFrom(
                    backgroundColor: AppColor.white,
                    side: const BorderSide(color: AppColor.appColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.px),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    ),
  );
}
