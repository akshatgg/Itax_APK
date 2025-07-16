import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

Widget buildAmountInfo(String amount, String label) {
  return Column(
    children: [
      Text(
        amount,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w400,
          color: Colors.white,
        ),
      ),
    ],
  );
}
