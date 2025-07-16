import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  List<ReportData> accountReport = [
    ReportData(
        image: ImageConstants.daybookIcon,
        color: const Color(0XFFE9F4EE),
        title: 'Day Book',
        path: AppRoutes.reportDay.name),
    ReportData(
        image: ImageConstants.expanseIcon,
        color: const Color(0XFFF6F3FC),
        title: 'Expenses',
        path: AppRoutes.reportExpanse.name),
    ReportData(
        image: ImageConstants.inactiveCustomerIcon,
        color: const Color(0XFFFEF2FF),
        title: 'Inactive Customers',
        path: AppRoutes.reportInactiveCustomer.name),
    ReportData(
        image: ImageConstants.inactiveItemIcon,
        color: const Color(0XFFFFF1FC),
        title: 'Inactive Item',
        path: AppRoutes.reportInactiveItem.name)
  ];
  List<ReportData> financeReport = [
    ReportData(
        image: ImageConstants.trialBalanceIcon,
        color: const Color(0XFFFFF2F2),
        title: 'Trial Balance',
        path: AppRoutes.reportTrialBalance.name),
    ReportData(
        image: ImageConstants.profitLossIcon,
        color: const Color(0XFFECF4FF),
        title: 'Profit & Loss',
        path: AppRoutes.reportProfitLoss.name),
    ReportData(
        image: ImageConstants.capitalAmountIcon,
        color: const Color(0XFFEEF2FF),
        title: 'Capital Account',
        path: AppRoutes.reportCapitalAccount.name),
    ReportData(
        image: ImageConstants.balanceSheetIcon,
        color: const Color(0XFFFFFCE3),
        title: 'Balance Sheet',
        path: AppRoutes.reportBalanceSheet.name)
  ];

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          onBackTap: () {
            GoRouter.of(context).go(AppRoutes.dashboardView.path);
          },
          title: 'Reports',
          showBackButton: true,
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.more_horiz_outlined,
                  color: AppColor.white,
                  size: 25.px,
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              color: AppColor.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      'Accounting Reports',
                      style: AppTextStyle.pw500Title.copyWith(color: AppColor.black),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.1,
                        crossAxisCount: 3,
                        crossAxisSpacing: 0.w,
                        // mainAxisSpacing: 5.w
                      ),
                      itemCount: accountReport.length,
                      itemBuilder: (context, index) {
                        return itemDetailWidget(
                          onTap: () {
                            RouterHelper.push(context, accountReport[index].path);
                          },
                          color: accountReport[index].color,
                          title: accountReport[index].title,
                          image: accountReport[index].image,
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      'Finance Reports',
                      style: AppTextStyle.pw500Title.copyWith(color: AppColor.black),
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Expanded(
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 1.1,
                        crossAxisCount: 3,
                        crossAxisSpacing: 0.w,
                        // mainAxisSpacing: 5.w
                      ),
                      itemCount: 4,
                      itemBuilder: (context, index) {
                        return itemDetailWidget(
                            onTap: () {
                              RouterHelper.push(context, financeReport[index].path);
                              // Navigator.of(context).push(MaterialPageRoute(
                              //     builder: (context) =>
                              //         financeReport[index].screen));
                            },
                            color: financeReport[index].color,
                            title: financeReport[index].title,
                            image: financeReport[index].image);
                      },
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

  Widget itemDetailWidget(
      {Color? color,
      String? image,
      String? title,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60.px,
            width: 80.px,
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10.px),
                boxShadow: [
                  const BoxShadow(color: Colors.black54, blurRadius: 4)
                ]),
            child: CustomImageView(
              imagePath: image,
              fit: BoxFit.contain,
              height: 40.px,
              width: 40.px,
            ),
          ),
          const SizedBox(
            height: 7,
          ),
          Text(
            title ?? '',
            textAlign: TextAlign.center,
            style: AppTextStyle.pw500,
          )
        ],
      ),
    );
  }
}

class ReportData {
  final String image;
  final Color color;
  final String title;
  final String path; // Non-nullable Widget type

  ReportData({
    required this.image,
    required this.color,
    required this.title,
    required this.path, // Ensure screen is always provided
  });
}
