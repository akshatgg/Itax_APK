import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';

Widget segmentWidget({String? title, VoidCallback? onAdd}) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 5.w),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.pw500
              .copyWith(fontSize: 16.px, color: AppColor.darkGrey),
        ),
        GestureDetector(
          onTap: onAdd,
          child: Text(
            'Add',
            style: AppTextStyle.pw500
                .copyWith(fontSize: 16.px, color: AppColor.appColor),
          ),
        )
      ],
    ),
  );
}
