import 'package:flutter/material.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';

class CustomTopAppBarView extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;

  const CustomTopAppBarView({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColor.white),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: AppTextStyle.body16.copyWith(color: AppColor.white),
      ),
      actions: [
        if (onMore != null)
          IconButton(
            icon: const Icon(Icons.more_horiz, color: AppColor.white),
            onPressed: onMore,
          ),
      ],
      flexibleSpace: Container(
        decoration: const BoxDecoration(
          gradient: AppColor.blueToGreenGradient,
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
