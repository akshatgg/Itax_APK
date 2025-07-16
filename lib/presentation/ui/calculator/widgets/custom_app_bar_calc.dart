// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../gen/assets.gen.dart';

class CustomAppBarCalculator extends StatelessWidget
    implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onDownload;

  const CustomAppBarCalculator({
    Key? key,
    required this.title,
    this.onBack,
    this.onShare,
    this.onDownload,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      leading: onBack != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: AppColor.white,
              ),
              onPressed: onBack,
            )
          : null,
      title: Text(
        title,
        style: AppTextStyle.body16.copyWith(color: AppColor.white),
      ),
      actions: [
        if (onDownload != null)
          IconButton(
            icon: SvgPicture.asset(
              Assets.icons.materialSymbolsDownload,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
            ),
            onPressed: onDownload,
          ),
        if (onShare != null)
          IconButton(
            icon: SvgPicture.asset(
              Assets.icons.materialSymbolsShare,
              height: 24,
              colorFilter:
                  const ColorFilter.mode(AppColor.white, BlendMode.srcIn),
            ),
            onPressed: onShare,
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
