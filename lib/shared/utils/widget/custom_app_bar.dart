import 'package:flutter/material.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../presentation/router/router_helper.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;
  final Widget? child;
  final bool showBackButton;

  const CustomAppBar({
    super.key,
    required this.title,
    this.onBackTap,
    this.child,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          if (showBackButton)
            GestureDetector(
              onTap: onBackTap ?? () => RouterHelper.pop<void>(context),
              child: const Icon(Icons.arrow_back_ios, color: AppColor.white),
            ),
          const SizedBox(width: 10), // Add spacing between icon and text
          Text(title, style: AppTextStyle.pw600),
        ],
      ),
      actions: [child ?? const SizedBox()],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class CustomAppBar2 extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackTap;

  const CustomAppBar2({
    super.key,
    required this.title,
    this.onBackTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          GestureDetector(
            onTap: onBackTap ?? () => RouterHelper.pop<void>(context),
            child: const Icon(Icons.arrow_back_ios, color: AppColor.white),
          ),
          const SizedBox(width: 10), // Add spacing between icon and text
          Text(title, style: AppTextStyle.pw600),
        ],
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
