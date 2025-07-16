import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';
import '../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../shared/utils/widget/custom_image.dart';
import '../../../shared/utils/widget/custom_textfield.dart';

class MoreGstSetUpScreen extends StatefulWidget {
  const MoreGstSetUpScreen({super.key});

  @override
  State<MoreGstSetUpScreen> createState() => _MoreGstSetUpScreenState();
}

class _MoreGstSetUpScreenState extends State<MoreGstSetUpScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isPassShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBarMore(
        title: 'GSP Setup',
        child: GestureDetector(
            onTap: () {
              addGspUserBottomSheet(context);
            },
            child: Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: Text(
                'Login',
                style: AppTextStyle.pw500.copyWith(color: AppColor.appColor),
              ),
            )),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CustomImageView(
                imagePath: ImageConstants.gstSetupIcon,
              ),
            ),
            Text(
              'Login GSP',
              style: AppTextStyle.pw500
                  .copyWith(color: AppColor.darkGrey, fontSize: 16.px),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'To Generate eWay Bill & eInvoice setup your GSP',
              style: AppTextStyle.pw400,
            )
          ],
        ),
      ),
    );
  }

  void addGspUserBottomSheet(BuildContext context) {
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
              const Text(
                'GSP Login',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),

              // Subtitle

              // Email Input Field
              CustomTextfield(
                  hint: 'GSP Username',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please add your gsp username';
                    }
                    return null;
                  },
                  controller: userNameController,
                  lable: 'GSP Username'),
              SizedBox(height: 2.h),
              CustomTextfield(
                  obsecure: isPassShow,
                  hint: 'Password',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please add your password';
                    }
                    return null;
                  },
                  controller: passwordController,
                  lable: 'Password'),

              SizedBox(height: 2.h),
              // Save Button
              CustomElevatedButton(
                text: 'Save',
                onTap: () {
                  Navigator.pop(context);
                  gspLoginSuccessBottomSheet(context);
                },
                height: 44.px,
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }

  void gspLoginSuccessBottomSheet(BuildContext context) {
    commonBottomSheet(context,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 2.h,
              ),
              Center(
                  child: Icon(
                Icons.check_circle,
                color: AppColor.green,
                size: 50.px,
              )),
              SizedBox(
                height: 2.h,
              ),
              const Text(
                'GSP Login Successfully',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                'Now you can generate eWay Bill & eInvoice',
                style: AppTextStyle.pw400.copyWith(color: AppColor.grey),
              ),
              SizedBox(height: 2.h),

              // Save Button
              CustomElevatedButton(
                text: 'Done',
                onTap: () {},
                height: 44.px,
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }
}
