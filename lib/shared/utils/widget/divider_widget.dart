import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/color_constants.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 1.h,
        ),
        Divider(
          color: AppColor.greyContainer,
          thickness: 3.px,
        ),
        SizedBox(
          height: 1.h,
        )
      ],
    );
  }
}
