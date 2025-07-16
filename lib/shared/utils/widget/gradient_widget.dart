import 'package:flutter/material.dart';

import '../../../core/constants/color_constants.dart';

class GradientContainer extends StatelessWidget {
  final Widget child;

  const GradientContainer({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColor.gradient1,
            AppColor.gradient2,
          ],
        ),
      ),
      child: child,
    );
  }
}
