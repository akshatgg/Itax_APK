import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import 'change_detail_dialog.dart';

class SortByBottomSheet extends StatelessWidget {
  final void Function(int) onClickItem;

  const SortByBottomSheet({super.key, required this.onClickItem});

  @override
  Widget build(BuildContext context) {
    final List<String> sortList = [
      'Amount (High-Low)',
      'Amount (Low-High)',
      'Most recent',
      'By Name (A-Z)',
      'By Name (Z-A)'
    ];

    return SafeArea(child: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.center,
            child: IconButton(
              icon: Container(
                  height: 27.px,
                  width: 27.px,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Color(0XFFCCCCCC)),
                  child: const Icon(Icons.close)),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 2.h,
                ),
                const Text(
                  'Sort by',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(sortList.length, (index) {
                    return GestureDetector(
                      onTap: () => onClickItem(index),
                      child: Container(
                        padding: EdgeInsets.all(3.w),
                        child: Text(
                          sortList[index],
                          style: AppTextStyle.pw400
                              .copyWith(color: AppColor.grey, fontSize: 16.px),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(
                  height: 2.h,
                ),
              ],
            ),
          ),
        ],
      ),
    ));
  }
}

void sortBottomSheet(BuildContext context, {required VoidCallback onTap}) {
  List<String> sortList = [
    'Amount (High-Low)',
    'Amount (Low-High)',
    'Most recent',
    'By Name (A-Z)',
    'By Name (Z-A)'
  ];
  commonBottomSheet(context,
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            const Text(
              'Sort by',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(sortList.length, (index) {
                return GestureDetector(
                  onTap: onTap,
                  child: Container(
                    padding: EdgeInsets.all(3.w),
                    child: Text(
                      sortList[index],
                      style: AppTextStyle.pw400
                          .copyWith(color: AppColor.grey, fontSize: 16.px),
                    ),
                  ),
                );
              }),
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ));
}


class SortByDayBottomSheet extends StatelessWidget {
  final void Function(int) onClickItem;

  const SortByDayBottomSheet({super.key, required this.onClickItem});

  @override
  Widget build(BuildContext context) {
    final List<String> sortList = [
      'All',
      '30 days',
      '60 days',
      '120 days',
      '180 days',
      '365 & above days'
    ];

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 2.h,
          ),
          const Text(
            'Sort by',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(sortList.length, (index) {
              return GestureDetector(
                onTap: () => onClickItem(index),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: Text(
                    sortList[index],
                    style: AppTextStyle.pw400
                        .copyWith(color: AppColor.grey, fontSize: 16.px),
                  ),
                ),
              );
            }),
          ),
          SizedBox(
            height: 2.h,
          ),
        ],
      ),
    );
  }
}
