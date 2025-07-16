import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_floating_button.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';

class ExpansesCategoryScreen extends StatefulWidget {
  const ExpansesCategoryScreen({super.key});

  @override
  State<ExpansesCategoryScreen> createState() => _ExpansesCategoryScreenState();
}

class _ExpansesCategoryScreenState extends State<ExpansesCategoryScreen> {
  int selectIndex = 0;
  List<String> option = ['All', 'Paid', 'Unpaid'];
  List<String> option2 = ['1D', '1M', '1Y', 'All Time'];
  int selectIndex2 = 0;

  List<PieChartDataModel> pieChartData = [
    PieChartDataModel(value: 40, title: 'Employee Salary,₹ 30000', color: const Color(0XFF9F00AD)),
    PieChartDataModel(value: 30, title: 'Item Purchase,₹ 30000', color: AppColor.appColor),
    PieChartDataModel(value: 20, title: 'Office Rent,₹ 30000', color: const Color(0XFF51546F)),
    PieChartDataModel(value: 10, title: 'Food,₹ 30000', color: const Color(0XFF7963CD)),
    PieChartDataModel(value: 10, title: 'Cab,₹ 30000', color: Colors.greenAccent),
    PieChartDataModel(value: 10, title: 'Office Wi-fi,₹ 30000', color: const Color(0XFFFF8F78)),
    PieChartDataModel(value: 10, title: 'Tea,₹ 30000', color: const Color(0XFFEE0B0B)),
  ];

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'Expenses Category',
          onBackTap: () {
            RouterHelper.pop<void>(context);
          },
        ),
        floatingActionButton: CustomFloatingButton(
          tag: 'item-tag',
          title: 'Add Category',
          imagePath: ImageConstants.createInvoiceIcon,
          onTap: () => RouterHelper.push(context, AppRoutes.addCategory.name),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(
                minHeight: 100.h, // Ensures it fills full height if content is short
              ),
              color: AppColor.white,
              padding: EdgeInsets.only(bottom: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  ...List.generate(
                    pieChartData.length,
                        (index) => Padding(
                      padding: EdgeInsets.only(bottom: 2.h),
                      child: chartdiaplydata(index: index),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget chartdiaplydata({required int index}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Row(
        children: [
          Container(
            height: 30.px,
            width: 30.px,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: pieChartData[index].color,
            ),
            child: Text(
              pieChartData[index].title[0].toUpperCase(),
              style: AppTextStyle.pw500.copyWith(color: AppColor.white, fontSize: 14.px),
            ),
          ),
          SizedBox(width: 3.w),
          Expanded(
            child: Text(
              pieChartData[index].title.split(',').first,
              style: AppTextStyle.pw500.copyWith(color: AppColor.darkGrey, fontSize: 14.px),
            ),
          ),
          Text(
            pieChartData[index].title.split(',').last,
            style: AppTextStyle.pw700.copyWith(color: AppColor.darkGrey, fontSize: 14.px),
          ),
        ],
      ),
    );
  }

  Widget selectOption() {
    return Container(
      height: 40.px,
      padding: EdgeInsets.only(left: 5.w),
      child: Wrap(
        spacing: 10.px,
        children: List.generate(option.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectIndex = index;
              });
            },
            child: Container(
              width: 100.px,
              height: 40.px,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30.px),
                border: Border.all(
                    color: index == selectIndex ? AppColor.appColor : Colors.transparent),
                color: index == selectIndex ? AppColor.lightAppColor : AppColor.greyContainer,
              ),
              child: Text(
                option[index],
                style: AppTextStyle.pw500.copyWith(
                  color: index == selectIndex ? AppColor.appColor : AppColor.darkGrey,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget selectOptionday() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          color: AppColor.greyContainer,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(option2.length, (index) {
            bool isSelected = index == selectIndex2;
            return GestureDetector(
              onTap: () {
                setState(() {
                  selectIndex2 = index;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  option2[index],
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black54,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  List<PieChartSectionData> buildPieChartSections(List<PieChartDataModel> data) {
    return data.map((item) {
      return PieChartSectionData(
        color: item.color,
        value: item.value,
        radius: 30,
        showTitle: false,
      );
    }).toList();
  }
}

class PieChartDataModel {
  final Color color;
  final double value;
  final String title;

  PieChartDataModel({
    required this.color,
    required this.value,
    required this.title,
  });
}
