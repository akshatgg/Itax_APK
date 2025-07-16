import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomSvgView extends StatelessWidget {
  const CustomSvgView({
    super.key,
    required this.assetName,
    this.width,
  });
  final String assetName;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SvgPicture.asset(
        assetName,
        fit: BoxFit.cover,
        width: width,
      ),
    );
  }
}
