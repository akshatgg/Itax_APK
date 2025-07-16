import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/utils/widget/calender_widget.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/gradient_widget.dart';

class ReportProfitLossScreen extends StatefulWidget {
  const ReportProfitLossScreen({super.key});

  @override
  State<ReportProfitLossScreen> createState() => _ReportProfitLossScreenState();
}

class _ReportProfitLossScreenState extends State<ReportProfitLossScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Profit & Loss',
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
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: calenderWidget(
                    onTap: () {}, selectedRange: '1 Apr 24 to 31 Mar 25'),
              ),
              SizedBox(
                height: 1.h,
              ),
              dividerWidget(),
              detailWidget(title: 'Sales Accounts', price: '11,10,200'),
              dividerWidget(),
              detailWidget(title: 'Purchase Accounts', price: '11,10,200'),
              dividerWidget(),
              detailWidget(title: 'Debit Note', price: '11,10,200'),
              dividerWidget(),
              detailWidget(title: 'Credit Note', price: '11,10,200'),
              dividerWidget(),
              detailWidget(title: 'Opening Stocks', price: '11,10,200'),
              dividerWidget(),
              detailWidget(title: 'Closing Stocks', price: '11,10,200'),
              detailWidget(
                  title: 'Gross Profit', price: '11,10,200', isColor: true),
              detailWidget(title: 'Other Income', price: '11,10,200'),
              dividerWidget(),
              detailWidget(title: 'Other Expenses', price: '11,10,200'),
              detailWidget(
                  title: 'Net Profit', price: '11,10,200', isColor: true),
            ],
          ),
        ),
      ),
    ));
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
          Text(
            title,
            style: AppTextStyle.pw400.copyWith(
                color: isColor ?? false ? AppColor.white : AppColor.darkGrey,
                fontSize: 14.px),
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
}
