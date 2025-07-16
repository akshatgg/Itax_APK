import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/color_constants.dart';
import '../../../core/utils/logger.dart';
import 'custom_elevated_button.dart';
import 'custom_textfield.dart';

void commonBottomSheet(BuildContext context, {required Widget child}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    enableDrag: true,
    backgroundColor: Colors.transparent,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                    icon: Container(
                        height: 27.px,
                        width: 27.px,
                        decoration: const BoxDecoration(
                            shape: BoxShape.circle, color: Color(0XFFCCCCCC)),
                        child: const Icon(Icons.close)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                child
              ],
            ),
          ),
        ),
      );
    },
  );
}

void changeDetailBottomSheet(
  BuildContext context, {
  required FormFieldValidator<String> validator,
  required String title,
  required String desc,
  required String hint,
  required VoidCallback onSave,
  String? lable,
  bool? read,
  required TextEditingController controller,
}) {
  final formKey = GlobalKey<FormState>(); // Define form key

  commonBottomSheet(
    context,
    child: SafeArea(
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Form(
          key: formKey, // Attach the form key here
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),

              // Title
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),

              // Subtitle
              Text(
                desc,
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 2.h),

              // Input Field
              CustomTextfield(
                read: title.contains('Email') ? true : false,
                hint: hint,
                lable: hint,
                validator: validator,
                controller: controller,
              ),
              SizedBox(height: 2.h),

              // Save Button
              CustomElevatedButton(
                text: 'Save',
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    logger.d('validate');
                    onSave(); // Only call onSave if validation passes
                  }
                },
                height: 44.px,
              ),
              SizedBox(height: 2.h),
            ],
          ),
        ),
      ),
    ),
  );
}

void changeAddressDialog(
  BuildContext context, {
  required FormFieldValidator<String> validator,
  required String title,
  required VoidCallback onSave,
  required TextEditingController controllerF,
  required TextEditingController controllerB,
  required TextEditingController controllerBn,
  required TextEditingController controllerS,
  required TextEditingController controllerA,
  required TextEditingController controllerC,
  required TextEditingController controllerState,
}) {
  commonBottomSheet(context,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: EdgeInsets.symmetric(horizontal: 5.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 2.h,
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'Flat No.',
                validator: validator,
                controller: controllerF,
                lable: 'Flat No.'),
            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'Building No.',
                validator: validator,
                controller: controllerB,
                lable: 'Building No.'),
            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'Building Name',
                validator: validator,
                controller: controllerBn,
                lable: 'Building Name'),
            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'Street',
                validator: validator,
                controller: controllerS,
                lable: 'Street'),
            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'Area',
                validator: validator,
                controller: controllerA,
                lable: 'Area'),
            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'City',
                validator: validator,
                controller: controllerC,
                lable: 'City'),
            SizedBox(height: 2.h),
            CustomTextfield(
                hint: 'State',
                validator: validator,
                controller: controllerState,
                lable: 'State'),
            SizedBox(height: 2.h),
            // Save Button
            CustomElevatedButton(
              text: 'Save',
              onTap: onSave,
              height: 44.px,
            ),
            SizedBox(
              height: 2.h,
            ),
          ],
        ),
      ));
}
