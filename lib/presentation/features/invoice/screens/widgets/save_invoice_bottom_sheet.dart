import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/color_constants.dart';
import '../../../../../shared/utils/widget/custom_elevated_button.dart';

class SaveInvoiceBottomSheet extends StatelessWidget {
  const SaveInvoiceBottomSheet(
      {super.key, required this.onSave, required this.onExport});

  final void Function() onSave;
  final void Function() onExport;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    CustomElevatedButton(
                      height: 44.px,
                      text: 'Save',
                      onTap: onSave,
                    ),
                    SizedBox(height: 2.h),
                    CustomElevatedButton(
                      height: 44.px,
                      text: 'Export',
                      onTap: onExport,
                    ),
                    SizedBox(height: 3.h),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
