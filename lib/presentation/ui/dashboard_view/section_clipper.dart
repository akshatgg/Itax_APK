import 'package:flutter/material.dart';

class AngledHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double cutSize = 12; // Adjust this for sharper or smoother cuts

    Path path = Path();
    path.moveTo(cutSize, 0);
    path.lineTo(size.width - cutSize, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
