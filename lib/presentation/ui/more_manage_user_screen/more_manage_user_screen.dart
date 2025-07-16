import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';
import '../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../shared/utils/widget/custom_floating_button.dart';
import '../../../shared/utils/widget/custom_textfield.dart';

class MoreManageUserScreen extends StatefulWidget {
  const MoreManageUserScreen({super.key});

  @override
  State<MoreManageUserScreen> createState() => _MoreManageUserScreenState();
}

class _MoreManageUserScreenState extends State<MoreManageUserScreen> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  bool isView = false;
  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBarMore(
        title: 'Manage User',
        child: Padding(
          padding: EdgeInsets.only(right: 5.w),
          child: GestureDetector(
            onTap: () {},
            child: const Icon(Icons.search),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
          tag: 'add-user',
          title: 'Add User',
          imagePath: ImageConstants.createInvoiceIcon,
          onTap: () {
            addUserBottomSheet(context);
          }),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: AppColor.lightAppColor,
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
              child: Row(
                children: [
                  Container(
                    height: 35.px,
                    width: 35.px,
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: AppColor.appColor),
                    child: Icon(
                      Icons.person,
                      size: 30.px,
                      color: AppColor.white,
                    ),
                  ),
                  SizedBox(
                    width: 2.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shahbaz Alam',
                          style: AppTextStyle.pw500.copyWith(
                              color: AppColor.darkGrey, fontSize: 14.px),
                        ),
                        Text(
                          '8571854900  |  Admin',
                          style: AppTextStyle.pw400
                              .copyWith(color: AppColor.grey, fontSize: 10.px),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    child: const Icon(
                      Icons.edit,
                      color: AppColor.appColor,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 5.w),
              child: Text(
                'Other Members',
                style: AppTextStyle.pw500
                    .copyWith(fontSize: 16.px, color: AppColor.darkGrey),
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Expanded(
              child: ListView.separated(
                  itemBuilder: (context, index) {
                    return infoWidget();
                  },
                  separatorBuilder: (context, index) {
                    return Column(
                      children: [
                        SizedBox(
                          height: 1.h,
                        ),
                        const Divider(
                          color: AppColor.greyContainer,
                          thickness: 2,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                      ],
                    );
                  },
                  itemCount: 5),
            )
          ],
        ),
      ),
    );
  }

  Widget infoWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        children: [
          Container(
            height: 35.px,
            width: 35.px,
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: Color(0XFFE0E0E0)),
            child: Icon(
              Icons.person,
              size: 30.px,
              color: AppColor.white,
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shahbaz Alam',
                  style: AppTextStyle.pw500
                      .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
                ),
                Text(
                  '8571854900  |  Sub User | Edit',
                  style: AppTextStyle.pw400
                      .copyWith(color: AppColor.grey, fontSize: 10.px),
                ),
              ],
            ),
          ),
          GestureDetector(
            child: const Icon(
              Icons.edit,
              color: AppColor.appColor,
            ),
          ),
          SizedBox(width: 2.w),
          GestureDetector(
            child: const Icon(
              CupertinoIcons.delete,
              color: AppColor.red,
            ),
          ),
        ],
      ),
    );
  }

  void addUserBottomSheet(BuildContext context) {
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
                'Add User',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 1.h),

              // Subtitle

              // Email Input Field
              CustomTextfield(
                  hint: 'Full Name',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please add your full name';
                    }
                    return null;
                  },
                  controller: fullNameController,
                  lable: 'Full Name'),
              SizedBox(height: 2.h),
              CustomTextfield(
                  hint: 'Mobile Number',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please add your mobile number';
                    }
                    return null;
                  },
                  controller: fullNameController,
                  lable: 'Mobile Number'),
              SizedBox(height: 1.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: isView,
                          onChanged: (value) {
                            setState(() {
                              isView = value!;
                            });
                          }),
                      SizedBox(
                        width: 1.w,
                      ),
                      Text('Only View',
                          style: AppTextStyle.pw500.copyWith(
                              fontSize: 12.px, color: AppColor.darkGrey))
                    ],
                  ),
                  Row(
                    children: [
                      Checkbox(
                          value: isEdit,
                          onChanged: (value) {
                            setState(() {
                              isEdit = value!;
                            });
                          }),
                      SizedBox(
                        width: 1.w,
                      ),
                      Text('All Edit Permission',
                          style: AppTextStyle.pw500.copyWith(
                              fontSize: 12.px, color: AppColor.darkGrey))
                    ],
                  )
                ],
              ),
              SizedBox(height: 2.h),
              // Save Button
              CustomElevatedButton(
                text: 'Save',
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
