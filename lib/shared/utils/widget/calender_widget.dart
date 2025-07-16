import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';

Widget calenderWidget({String? selectedRange, required VoidCallback onTap}) {
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

Widget calenderRangeWidget(
    {required DateTimeRange selectedRange, required VoidCallback onTap}) {
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
            ' (${selectedRange.start.day} ${_getMonthName(selectedRange.start.month)} ${selectedRange.start.year.toString().substring(2)} to '
            '${selectedRange.end.day} ${_getMonthName(selectedRange.end.month)} ${selectedRange.end.year.toString().substring(2)})',
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

Widget calenderInvoiceWidget(
    {String? selectedRange, required VoidCallback onTap}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          const Icon(
            Icons.calendar_month,
            color: AppColor.darkGrey,
          ),
          Text(
            '  $selectedRange',
            style: AppTextStyle.pw400
                .copyWith(fontSize: 14.px, color: AppColor.grey),
          )
        ],
      ),
    ],
  );
}

String _getMonthName(int month) {
  const List<String> monthNames = [
    '',
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];
  return monthNames[month];
}
