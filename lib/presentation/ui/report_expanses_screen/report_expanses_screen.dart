import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/gradient_widget.dart';
import '../../../shared/utils/widget/sort_by_bottom_model_sheet.dart';
import '../../features/parties/screens/widget/customer_detail_download_widget.dart';
import '../../features/reports/screens/widget/report_expanses_download_widget.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';

class ReportExpansesScreen extends StatefulWidget {
  const ReportExpansesScreen({super.key});

  @override
  State<ReportExpansesScreen> createState() => _ReportExpansesScreenState();
}

class _ReportExpansesScreenState extends State<ReportExpansesScreen> {
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
          title: 'Expenses',
          onBackTap: () {
            RouterHelper.pop<void>(context);
          },
          child: Row(
            children: [
              GestureDetector(
                onTap: () {
                  showModalBottomSheet<void>(
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (context) {
                      return SortByBottomSheet(
                        onClickItem: (int ) {  },
                      );
                    },
                  );
                },
                child: Icon(CupertinoIcons.sort_up, color: AppColor.white, size: 25.px),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: () {
                  RouterHelper.push(context, AppRoutes.addCategory.name);
                },
                child: Icon(Icons.settings, color: AppColor.white, size: 25.px),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: () {
                  commonBottomSheet(context,
                      child: ReportDetailDownloadWidget(
                        list: false,
                        type: 'customer',
                        onClickItem: (index) {
                          if (index == 0) {

                          }
                          if (index == 1) {

                          }
                          if (index == 2) {}

                          RouterHelper.pop<void>(context);
                        },
                      ));
                },
                child: const Icon(
                  Icons.more_horiz_outlined,
                  color: AppColor.white,
                ),
              ),
              SizedBox(width: 5.w),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: double.infinity,
              color: AppColor.white,
              padding: EdgeInsets.only(bottom: 5.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  selectOption(),
                  SizedBox(height: 3.h),
                  selectOptionday(),
                  SizedBox(height: 8.h),
                  SizedBox(
                    height: 25.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        PieChart(
                          PieChartData(
                            sections: buildPieChartSections(pieChartData),
                            borderData: FlBorderData(show: false),
                            sectionsSpace: 5,
                            centerSpaceRadius: 80,
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Last 1 month \ntotal expenses',
                              textAlign: TextAlign.center,
                              style: AppTextStyle.pw400.copyWith(fontSize: 15.px, color: AppColor.grey),
                            ),
                            Text(
                              '₹ 99,900',
                              style: AppTextStyle.pw500.copyWith(fontSize: 24.px, color: AppColor.black),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),

                  // ✅ Scrollable section (all rows generated)
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
