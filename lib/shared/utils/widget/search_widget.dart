import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';

Widget searchTextField({
  VoidCallback? onSort,
  TextEditingController? controller,
  required String hint,
  // Added validator parameter
}) {
  return Row(
    children: [
      Expanded(
        child: TextField(
          controller: controller,
          style: AppTextStyle.pw500.copyWith(
            fontSize: 14.px,
            color: AppColor.grey,
          ),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(
              horizontal: 3.w,
              vertical: 1.h,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: AppColor.grey,
            ),
            hintText: hint,
            errorStyle: AppTextStyle.pw400.copyWith(
              fontSize: 12.px,
              color: Colors.red,
            ),
            hintStyle: AppTextStyle.pw500.copyWith(
              fontSize: 14.px,
              color: AppColor.grey,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: AppColor.grey,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: AppColor.grey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: Colors.red,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.px),
              borderSide: const BorderSide(
                color: AppColor.grey,
              ),
            ),
          ),
          // Added validator here
        ),
      ),
      SizedBox(
        width: 2.w,
      ),
      InkWell(
        onTap: onSort,
        child: Container(
            height: 43.px,
            width: 43.px,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.px),
              border: Border.all(
                color: AppColor.grey,
              ),
            ),
            child: Icon(
              CupertinoIcons.sort_up,
              size: 35.px,
              color: AppColor.grey,
            )),
      )
    ],
  );
}

Widget invoiceSearchTextField({
  TextEditingController? controller,
  required String hint,
  // Added validator parameter
}) {
  return TextField(
    controller: controller,
    style: AppTextStyle.pw500.copyWith(
      fontSize: 14.px,
      color: AppColor.darkGrey,
    ),
    decoration: InputDecoration(
      filled: true,
      fillColor: AppColor.greyContainer,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 5.w,
        vertical: 1.h,
      ),
      prefixIcon: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust spacing
        child: Row(
          mainAxisSize: MainAxisSize.min, // Prevents overflow
          children: [
            Icon(
              Icons.search,
              color: AppColor.grey,
            ),
            SizedBox(width: 4), // Space between icon and text
            Text('|', style: TextStyle(color: AppColor.grey)),
          ],
        ),
      ),
      hintText: hint,
      errorStyle: AppTextStyle.pw400.copyWith(
        fontSize: 12.px,
        color: AppColor.red,
      ),
      hintStyle: AppTextStyle.pw500.copyWith(
        fontSize: 14.px,
        color: AppColor.darkGrey,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.px),
        borderSide: const BorderSide(
          color: AppColor.grey,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.px),
        borderSide: const BorderSide(
          color: AppColor.grey,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.px),
        borderSide: const BorderSide(
          color: Colors.red,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.px),
        borderSide: const BorderSide(
          color: AppColor.grey,
        ),
      ),
    ),
    // Added validator here
  );
}

class InvoiceSearchTextfield extends HookWidget {
  final TextEditingController controller;
  final String hint;

  const InvoiceSearchTextfield({
    super.key,
    required this.controller,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: AppTextStyle.pw500.copyWith(
        fontSize: 14.px,
        color: AppColor.darkGrey,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: AppColor.greyContainer,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 1.h,
        ),
        prefixIcon: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.0), // Adjust spacing
          child: Row(
            mainAxisSize: MainAxisSize.min, // Prevents overflow
            children: [
              Icon(
                Icons.search,
                color: AppColor.grey,
              ),
              SizedBox(width: 4), // Space between icon and text
              Text('|', style: TextStyle(color: AppColor.grey)),
            ],
          ),
        ),
        hintText: hint,
        errorStyle: AppTextStyle.pw400.copyWith(
          fontSize: 12.px,
          color: AppColor.red,
        ),
        hintStyle: AppTextStyle.pw500.copyWith(
          fontSize: 14.px,
          color: AppColor.darkGrey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: const BorderSide(
            color: AppColor.grey,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: const BorderSide(
            color: AppColor.grey,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: const BorderSide(
            color: Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.px),
          borderSide: const BorderSide(
            color: AppColor.grey,
          ),
        ),
      ),
      // Added validator here
    );
  }
}
