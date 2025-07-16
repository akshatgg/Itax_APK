import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../../../../core/constants/image_constants.dart';
import '../../../../../shared/utils/widget/custom_image.dart';

class CustomerDetailWidget extends StatelessWidget {
  final String? name;
  final String? type;
  final String? phone;
  final String? receivable;
  final String? lastSales;
  final String? inactive;

  const CustomerDetailWidget({
    super.key,
    this.name,
    this.type,
    this.phone,
    this.receivable,
    this.lastSales,
    this.inactive,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          Row(
            children: [
              type == 'customer'
                  ? Container(
                      height: 30.px,
                      width: 30.px,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColor.greyContainer),
                      child: Text(
                        name!.isNotEmpty ? name![0].toUpperCase() : '',
                        style: AppTextStyle.pw500,
                      ))
                  : CustomImageView(
                      imagePath: ImageConstants.itemBoxIcon,
                    ),
              SizedBox(width: 3.w),
              Expanded(
                child: Text(
                  name ?? '',
                  style: AppTextStyle.pw600
                      .copyWith(fontSize: 16.px, color: AppColor.darkGrey),
                ),
              ),
              type == 'customer'
                  ? OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                              color: AppColor.appColor, width: 1),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.px),
                              side: const BorderSide(
                                  color: AppColor.appColor, width: 2))),
                      onPressed: () async {
                        final Uri url = Uri(scheme: 'tel', path: phone);
                        if (await canLaunchUrl(url)) {
                          await launchUrl(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.phone,
                              color: AppColor.appColor),
                          Text(
                            '  Call',
                            style: AppTextStyle.pw500.copyWith(
                                fontSize: 13.px, color: AppColor.appColor),
                          )
                        ],
                      ))
                  : const SizedBox()
            ],
          ),
          SizedBox(height: 2.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              type == 'customer'
                  ? segmentWidget(title: 'Receivables', desc: receivable)
                  : segmentWidget(title: 'Current Stock', desc: receivable),
              segmentWidget(title: 'Last Sales Date', desc: lastSales),
              segmentWidget(title: 'Inactive Since', desc: inactive),
            ],
          )
        ],
      ),
    );
  }
}

Widget segmentWidget({String? title, String? desc}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        title ?? '',
        style: AppTextStyle.pw400.copyWith(color: AppColor.grey),
      ),
      SizedBox(
        height: 1.h,
      ),
      Text(
        desc ?? '',
        style: AppTextStyle.pw400.copyWith(
            color:
                title!.contains('Inactive') ? AppColor.red : AppColor.darkGrey,
            fontSize: 14.px),
      ),
    ],
  );
}
