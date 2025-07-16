import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../../../shared/utils/widget/custom_svg_view.dart';

class BannerSlider extends StatelessWidget {
  final List<String> imageList;

  const BannerSlider({super.key, required this.imageList});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        aspectRatio: 1,
        viewportFraction: 0.8,
      ),
      items: imageList.map((item) {
        return Container(
          width: MediaQuery.of(context).size.width,
          margin: const EdgeInsets.all(8.0),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          child: CustomSvgView(assetName: item),
        );
      }).toList(),
    );
  }
}