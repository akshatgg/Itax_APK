import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';

class AddInfoWidget extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const AddInfoWidget({super.key, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          const Icon(
            Icons.add_circle,
            color: AppColor.black,
          ),
          SizedBox(
            width: 3.w,
          ),
          Text(
            title,
            style: AppTextStyle.pw600
                .copyWith(color: AppColor.black, fontSize: 16.px),
          )
        ],
      ),
    );
  }
}
