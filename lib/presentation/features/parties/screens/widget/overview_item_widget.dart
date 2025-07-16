import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../shared/utils/widget/custom_image.dart';

class OverviewItemWidget extends StatelessWidget {
  final String title;
  final String image;
  final String value;

  const OverviewItemWidget(
      {super.key,
      required this.value,
      required this.title,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(3.w),
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10.px),
          boxShadow: [
            const BoxShadow(
                color: Colors.black54,
                blurRadius: 1.0,
                spreadRadius: 0.5,
                offset: Offset(1, 1))
          ]),
      child: Row(
        children: [
          CustomImageView(
            width: 25.px,
            height: 25.px,
            imagePath: image,
          ),
          SizedBox(
            width: 3.w,
          ),
          Expanded(
            child: Text(
              title,
              style: AppTextStyle.pw500
                  .copyWith(color: AppColor.black, fontSize: 14.px),
            ),
          ),
          Text(
            '₹ $value',
            style: AppTextStyle.pw500
                .copyWith(color: AppColor.black, fontSize: 14.px),
          ),
        ],
      ),
    );
  }
}
