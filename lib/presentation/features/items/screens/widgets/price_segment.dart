import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';

class PriceSegment extends StatelessWidget {
  const PriceSegment({
    super.key,
    this.title,
    this.price,
  });

  final String? title;
  final String? price;

  @override
  Widget build(BuildContext context) {
    int priceValue = int.tryParse(price ?? '0') ?? 0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title ?? '',
          style: AppTextStyle.pw400
              .copyWith(fontSize: 12.px, color: AppColor.grey),
        ),
        SizedBox(
          height: 1.h,
        ),
        title!.contains('Stock')
            ? Text(
                '$priceValue',
                style: AppTextStyle.pw400.copyWith(
                  fontSize: 14.px,
                  color: (priceValue <= 0) ? Colors.red : Colors.green,
                ),
              )
            : Text(
                '$price',
                style: AppTextStyle.pw400
                    .copyWith(fontSize: 14.px, color: AppColor.black),
              )
      ],
    );
  }
}
