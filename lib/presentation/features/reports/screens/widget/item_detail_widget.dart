import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';

class ItemWidget extends StatelessWidget {
  final String name;
  final String date;
  final String type;
  final String price;
  final String id;

  const ItemWidget({
    super.key,
    required this.name,
    required this.id,
    required this.date,
    required this.type,
    required this.price,
  });

  String _formatDate(String rawDate) {
    try {
      final parsedDate = DateTime.parse(rawDate);
      return DateFormat('dd MMMM yy').format(parsedDate);
    } catch (e) {
      return rawDate; // fallback if parsing fails
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppTextStyle.pw500,
              ),
              Text(
                '₹ $price',
                style: AppTextStyle.pw700
                    .copyWith(color: AppColor.black, fontSize: 14.px),
              ),
            ],
          ),
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_formatDate(date)} |  #$id',
                style: AppTextStyle.pw400
                    .copyWith(color: AppColor.grey, fontSize: 12.px),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColor.greyContainer,
                  borderRadius: BorderRadius.circular(30.px),
                ),
                child: Text(
                  type,
                  style: AppTextStyle.pw400
                      .copyWith(color: AppColor.darkGrey, fontSize: 10.px),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
