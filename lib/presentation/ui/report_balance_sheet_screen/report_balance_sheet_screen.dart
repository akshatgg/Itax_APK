import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../shared/utils/widget/calender_widget.dart';
import '../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../shared/utils/widget/custom_floating_button.dart';
import '../../../shared/utils/widget/custom_textfield.dart';
import '../../../shared/utils/widget/gradient_widget.dart';

class ReportBalanceSheetScreen extends StatefulWidget {
  const ReportBalanceSheetScreen({super.key});

  @override
  State<ReportBalanceSheetScreen> createState() =>
      _ReportBalanceSheetScreenState();
}

class _ReportBalanceSheetScreenState extends State<ReportBalanceSheetScreen> {
  int isSelect = 1;
  int isAssetIndex = -1;
  TextEditingController dateController = TextEditingController();
  TextEditingController itemController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  List<String> assetList = [
    'Current Assets',
    'Fixed Assets',
    'Investments',
    'Loans Advance'
  ];
  List<String> liabilityList = ['Current Liabilities', 'Capital', 'Loan'];
  ValueNotifier<String> selectItemNotifier = ValueNotifier<String>('');

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
        child: Scaffold(
      appBar: CustomAppBar(
        title: 'Balance Sheet',
        child: Padding(
          padding: EdgeInsets.only(right: 5.w),
          child: GestureDetector(
            child: const Icon(
              Icons.more_horiz_outlined,
              color: AppColor.white,
            ),
          ),
        ),
      ),
      floatingActionButton: CustomFloatingButton(
        tag: 'reports-tag',
        title: 'Add New Entry',
        imagePath: ImageConstants.createInvoiceIcon,
        onTap: () {
          addEntryBottomSheet(
            context,
            onSave: () {},
            title: isSelect == 1 ? 'Add Assets' : 'Add Liabilities',
          );
        },
      ),
      bottomNavigationBar: detailWidget(
          title: isSelect == 1 ? 'Total Assets' : 'Total Liabilities',
          price: '5,30,200',
          isColor: true),
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: AppColor.white,
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSegmentButton(text: 'Assets', index: 1),
                  _buildSegmentButton(text: 'Liabilities', index: 2),
                ],
              ),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: calenderWidget(
                    onTap: () {}, selectedRange: '1 Apr 24 to 31 Mar 25'),
              ),
              SizedBox(
                height: 1.h,
              ),
              const Divider(
                color: AppColor.greyContainer,
                thickness: 4,
              ),
              isSelect == 1
                  ? Column(
                      children: [
                        detailWidget(
                            title: 'Current Assets', price: '5,30,200'),
                        dividerWidget(),
                        detailWidget(title: 'Fixed Assets', price: '5,30,200'),
                        dividerWidget(),
                        detailWidget(title: 'Investments', price: '5,30,200'),
                        dividerWidget(),
                        detailWidget(title: 'Loan Advances', price: '5,30,200'),
                        dividerWidget(),
                      ],
                    )
                  : Column(
                      children: [
                        detailWidget(title: 'Capital', price: '5,30,200'),
                        dividerWidget(),
                        detailWidget(
                            title: 'Current Liability', price: '5,30,200'),
                        dividerWidget(),
                        detailWidget(title: 'Loan', price: '5,30,200'),
                        dividerWidget(),
                        detailWidget(title: 'Net Income', price: '5,30,200'),
                        dividerWidget(),
                      ],
                    )
            ],
          ),
        ),
      ),
    ));
  }

  Widget _buildSegmentButton({required String text, required int index}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelect = index;
          itemController.clear();
        });
      },
      child: Container(
        height: 40.px,
        width: 164.px,
        alignment: Alignment.center,
        // padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
        decoration: BoxDecoration(
          border: Border.all(
              color:
                  isSelect == index ? AppColor.appColor : Colors.transparent),
          color: isSelect == index
              ? AppColor.lightAppColor
              : AppColor.greyContainer,
          borderRadius: BorderRadius.circular(30.px),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: isSelect == index ? AppColor.appColor : AppColor.darkGrey,
          ),
        ),
      ),
    );
  }

  Widget dividerWidget() {
    return const Divider(
      color: AppColor.greyContainer,
      thickness: 3,
    );
  }

  Widget detailWidget(
      {required String title, required String price, bool? isColor}) {
    return Container(
      color: isColor ?? false ? AppColor.appColor : Colors.transparent,
      padding: EdgeInsets.symmetric(
          horizontal: 5.w, vertical: isColor ?? false ? 1.5.h : 1.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                title,
                style: AppTextStyle.pw400.copyWith(
                    color:
                        isColor ?? false ? AppColor.white : AppColor.darkGrey,
                    fontSize: 14.px),
              ),
              SizedBox(
                width: 1.w,
              ),
              Icon(
                Icons.info_outline,
                color: AppColor.grey,
                size: 15.px,
              )
            ],
          ),
          Text(
            '₹ $price',
            style: AppTextStyle.pw600.copyWith(
                color: isColor ?? false ? AppColor.white : AppColor.darkGrey,
                fontSize: 14.px),
          )
        ],
      ),
    );
  }

  void addEntryBottomSheet(
    BuildContext context, {
    required String title,
    required VoidCallback onSave,
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
              SizedBox(height: 1.h),
              CustomTextfield(
                  hint: isSelect == 1 ? 'Select Assets' : 'Select Liabilities',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please select item';
                    }
                    return null;
                  },
                  controller: itemController,
                  lable: isSelect == 1 ? 'Select Assets' : 'Select Liabilities',
                  suffixWidget: GestureDetector(
                    onTap: () {
                      assetsListBottomSheet(context);
                    },
                    child: const Icon(
                      Icons.keyboard_arrow_down,
                      color: AppColor.grey,
                    ),
                  )),
              SizedBox(
                height: 2.h,
              ),
              CustomTextfield(
                  hint: 'Select Date',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please select date';
                    }
                    return null;
                  },
                  controller: dateController,
                  lable: 'Select Date',
                  suffixWidget: GestureDetector(
                    child: const Icon(
                      Icons.date_range,
                      color: AppColor.grey,
                    ),
                  )),
              SizedBox(height: 2.h),
              CustomTextfield(
                  hint: 'Amount',
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Please add amount';
                    }
                    return null;
                  },
                  controller: amountController,
                  lable: 'Amount'),
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

  void assetsListBottomSheet(BuildContext context) {
    int selectedIndex = -1;
    commonBottomSheet(context, child: // Local state for selection tracking

        StatefulBuilder(
      builder: (context, setModalState) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: const Text(
                  'Category',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(
                  isSelect == 1 ? assetList.length : liabilityList.length,
                  (index) {
                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          itemController.text = isSelect == 1
                              ? assetList[index]
                              : liabilityList[index];
                          selectedIndex = index;
                          // Update local state
                        });
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        color: selectedIndex == index
                            ? AppColor.greyContainer
                            : AppColor.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 5.w,
                          vertical: 1.h,
                        ),
                        child: Text(
                          isSelect == 1
                              ? assetList[index]
                              : liabilityList[index],
                          style: AppTextStyle.pw400
                              .copyWith(color: AppColor.grey, fontSize: 16.px),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    ));
  }
}
