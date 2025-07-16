import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';
import 'custom_elevated_button.dart';

class CustomFloatingButton extends StatelessWidget {
  final String title;
  final String? imagePath;
  final VoidCallback onTap;
  final String tag;

  const CustomFloatingButton({
    required this.tag,
    super.key,
    required this.title,
    this.imagePath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: FloatingActionButton(
        heroTag: tag,
        onPressed: onTap,
        backgroundColor: AppColor.appColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: CustomElevatedButton(
          buttonColor: AppColor.appColor,
          text: ' $title',
          onTap: onTap,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
          buttonStyle: ElevatedButton.styleFrom(
              backgroundColor: AppColor.appColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30))),
          width: 200,
          leftIcon: (imagePath != null && imagePath!.isNotEmpty)
              ? Image.asset(
            imagePath!,
            height: 18,
            width: 18,
          )
              : null,
        ),
      ),
    );
  }
}
