// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../presentation/router/routes.dart';

class CustomBottomAppBar extends StatelessWidget {
  final int currentIndex;
  final void Function(int index, String route) onItemSelected;

  const CustomBottomAppBar({
    Key? key,
    required this.currentIndex,
    required this.onItemSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<BottomNavItem> items = [
      BottomNavItem(
        label: 'Home',
        icon: Icons.home,
        routeName: AppRoutes.dashboardView.name,
      ),
      BottomNavItem(
        label: 'Tools',
        icon: Icons.build,
        routeName: AppRoutes.profile.name,
      ),
      BottomNavItem(
        label: 'Blogs',
        icon: Icons.article,
        routeName: AppRoutes.profile.name,
      ),
      BottomNavItem(
        label: 'More',
        icon: Icons.more_horiz,
        routeName: AppRoutes.profile.name,
      ),
    ];

    return Container(
      padding: EdgeInsets.only(top: 10.px),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.px),
          topRight: Radius.circular(20.px),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black54,
            spreadRadius: 0.1,
            blurRadius: 2,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: BottomAppBar(
        color: AppColor.white,
        padding: EdgeInsets.zero,
        height: 60.px,
        child: Row(
          children: List.generate(items.length, (index) {
            final item = items[index];
            final isSelected = index == currentIndex;

            return Expanded(
              child: InkWell(
                onTap: () => onItemSelected(index, item.routeName),
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    item.imagePath != null
                        ? Image.asset(
                            item.imagePath!,
                            height: 22.px,
                            color: isSelected
                                ? AppColor.appColor
                                : Colors.black.withOpacity(0.4),
                          )
                        : Icon(
                            item.icon,
                            color: isSelected
                                ? AppColor.appColor
                                : Colors.black.withOpacity(0.4),
                          ),
                    SizedBox(height: 4.px),
                    Text(
                      item.label,
                      style: AppTextStyle.pw500.copyWith(
                        fontSize: 10.sp,
                        color: isSelected
                            ? AppColor.appColor
                            : Colors.black.withOpacity(0.4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class BottomNavItem {
  final String label;
  final IconData icon;
  final String routeName;
  final String? imagePath;

  BottomNavItem({
    required this.label,
    required this.icon,
    required this.routeName,
    this.imagePath,
  });
}
