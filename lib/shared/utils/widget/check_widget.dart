import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';

class CheckWidget extends StatelessWidget {
  const CheckWidget(
      {super.key,
      required this.value,
      required this.title,
      required this.onChanged});

  final bool value;
  final String title;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return AppColor
                    .appColor; // Change to your desired color when checked
              }
              return Colors
                  .white; // Change to your desired color when unchecked
            }),
            value: value,
            onChanged: onChanged),
        SizedBox(
          width: 1.w,
        ),
        Text(
          title,
          style: AppTextStyle.pw500.copyWith(color: AppColor.darkGrey),
        )
      ],
    );
  }
}
