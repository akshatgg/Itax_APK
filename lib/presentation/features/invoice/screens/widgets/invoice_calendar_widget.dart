import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';

Widget buildCalenderWidget({
  String? selectedRange,
  required VoidCallback onTap,
}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          const Icon(
            Icons.calendar_month,
            color: AppColor.appColor,
          ),
          Text(
            '  Financial Year',
            style: AppTextStyle.pw400.copyWith(fontSize: 12.px),
          ),
          Text(
            ' ($selectedRange)',
            style: AppTextStyle.pw400
                .copyWith(fontSize: 10.px, color: AppColor.grey),
          )
        ],
      ),
      GestureDetector(
        onTap: onTap,
        child: Text(
          'Change',
          style: AppTextStyle.pw400
              .copyWith(fontSize: 12.px, color: AppColor.appColor),
        ),
      )
    ],
  );
}
