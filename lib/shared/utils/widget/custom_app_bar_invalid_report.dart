import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../presentation/router/router_helper.dart';

PreferredSize customAppBarReportInvalid(BuildContext context,
    {required String title,
    required String subtitle1,
    required String subtitle2,
    required String subdes2,
    required String price,
    VoidCallback? onPdf,
    VoidCallback? onbackTap}) {
  return PreferredSize(
    preferredSize: Size.fromHeight(120.px),
    child: Column(children: [
      SizedBox(
        height: 5.h,
      ),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => onbackTap ?? RouterHelper.pop<void>(context),
                  child:
                      const Icon(Icons.arrow_back_ios, color: AppColor.white),
                ),
                const SizedBox(width: 10),
                // Add spacing between icon and text
                Text(title,
                    style: AppTextStyle.pw600.copyWith(color: AppColor.white)),
              ],
            ),
            InkWell(
              onTap: onPdf,
              child: Container(
                height: 25.px,
                width: 25.px,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7.px),
                    color: AppColor.white),
                child: Icon(
                  Icons.picture_as_pdf,
                  color: AppColor.red,
                  size: 15.px,
                ),
              ),
            )
          ],
        ),
      ),
      SizedBox(
        height: 3.h,
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Text(
                price,
                style: AppTextStyle.pw600
                    .copyWith(color: AppColor.white, fontSize: 16.px),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                subtitle1,
                style: AppTextStyle.pw500
                    .copyWith(color: AppColor.white, fontSize: 12.px),
              ),
            ],
          ),
          Container(
            height: 5.h,
            width: 3.px,
            color: AppColor.white,
          ),
          Column(
            children: [
              Text(
                subdes2,
                style: AppTextStyle.pw600
                    .copyWith(color: AppColor.white, fontSize: 16.px),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                subtitle2,
                style: AppTextStyle.pw500
                    .copyWith(color: AppColor.white, fontSize: 12.px),
              ),
            ],
          ),
        ],
      )
    ]),
  );
}
