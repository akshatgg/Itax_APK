import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../presentation/router/router_helper.dart';

class CustomAppBarMore extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? child;
  final bool showBackButton;
  final Widget? titleWidget;
  final VoidCallback? onCompany;
  final bool arrow;
  final VoidCallback? onBack;

  const CustomAppBarMore({
    super.key,
    this.title = '',
    this.child,
    this.onBack,
    this.showBackButton = true,
    this.titleWidget,
    this.onCompany,
    this.arrow = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final iconColor = isDark ? Colors.white : Colors.black;
    final textColor = isDark ? Colors.white : Colors.black;

    return AppBar(
      automaticallyImplyLeading: false,
      leading: Builder(
        builder: (context) {
          return showBackButton
              ? IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: iconColor,
              size: 20.px,
            ),
            onPressed: onBack ?? () => RouterHelper.pop<void>(context),
          )
              : IconButton(
            icon: Icon(
              Icons.menu,
              color: iconColor,
              size: 25.px,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          );
        },
      ),
      title: Row(
        children: [
          titleWidget ??
              Text(
                title,
                style: AppTextStyle.pw600.copyWith(
                  color: textColor,
                  fontSize: 16.px,
                ),
              ),
          SizedBox(width: 3.w),
          if (arrow)
            GestureDetector(
              onTap: onCompany,
              child: Icon(
                Icons.keyboard_arrow_down_outlined,
                color: iconColor,
                size: 20.px,
              ),
            ),
        ],
      ),
      actions: child != null ? [child!] : [],
      backgroundColor: Colors.transparent,
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}