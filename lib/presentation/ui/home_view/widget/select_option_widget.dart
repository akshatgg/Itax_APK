import 'package:flutter/cupertino.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';

class SelectOptionWidget extends StatelessWidget {
  final void Function(String) onClickItem;

  const SelectOptionWidget({super.key, required this.onClickItem});

  @override
  Widget build(BuildContext context) {
    List<String> detailList = [
      'This year',
      'Previous Year',
      'This Month',
      'This Week',
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(detailList.length, (index) {
              return GestureDetector(
                onTap: () => onClickItem(detailList[index]),
                child: Container(
                  padding: EdgeInsets.all(3.w),
                  child: Row(
                    children: [
                      Text(
                        detailList[index],
                        style: AppTextStyle.pw400
                            .copyWith(color: AppColor.grey, fontSize: 16.px),
                      ),
                    ],
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
