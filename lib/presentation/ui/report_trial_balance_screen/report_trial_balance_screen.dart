import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../shared/utils/widget/calender_widget.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/gradient_widget.dart';

class ReportTrialBalanceScreen extends StatefulWidget {
  const ReportTrialBalanceScreen({super.key});

  @override
  State<ReportTrialBalanceScreen> createState() =>
      _ReportTrialBalanceScreenState();
}

class _ReportTrialBalanceScreenState extends State<ReportTrialBalanceScreen> {
  @override
  Widget build(BuildContext context) {
    return GradientContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: CustomAppBar(
        title: 'Trial Balance',
        onBackTap: () {
          // RouterHelper.pop(context);
        },
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
          color: AppColor.white,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
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
                height: 2.h,
              ),
              Column(
                children: [
                  // Header Row
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                    decoration: const BoxDecoration(color: AppColor.appColor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            flex: 2,
                            child: tableCellHeader(
                                text: 'Particular', islast: false)),
                        Expanded(
                            flex: 1,
                            child:
                                tableCellHeader(text: 'Debit', islast: false)),
                        Expanded(
                            flex: 1,
                            child:
                                tableCellHeader(text: 'Credit', islast: true)),
                      ],
                    ),
                  ),
                  // Static Data Rows (Manually added)
                  rowItem('Cash In-hand', '0.00', '1,61,450'),
                  rowItem('Bank A/c', '0.00', '70,50,200'),
                  rowItem('Sales A/c', '0.00', '11,10,200'),
                  rowItem('Purchase A/c', '7,05,200', '0.00'),
                  rowItem('Debit Note', '90,500', '0.00'),
                  rowItem('Credit Note', '0.00', '1,11,200'),
                  rowItem('Capital', '3,50,000', '0.00'),
                  rowItem('Assets', '12,40,700', '0.00'),
                  rowItem('Liabilities', '0.00', '13,32,700'),
                  rowItem('Opening Stock', '5,10,000', '0.00'),
                ],
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                decoration: const BoxDecoration(color: AppColor.appColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 2,
                        child: tableCellHeader(text: 'Total', islast: false)),
                    Expanded(
                        flex: 1,
                        child: tableCellHeader(
                            text: '₹ 28,96,400', islast: false)),
                    Expanded(
                        flex: 1,
                        child:
                            tableCellHeader(text: '₹ 97,65,750', islast: true)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }

  Widget rowItem(String title, String debit, String credit) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              flex: 2,
              child: tableCell(text: title, isLast: false, isFirst: true)),
          Expanded(
              flex: 1,
              child:
                  tableCell(text: '₹ $debit', isLast: false, isFirst: false)),
          Expanded(
              flex: 1,
              child:
                  tableCell(text: '₹ $credit', isLast: true, isFirst: false)),
        ],
      ),
    );
  }

// Helper function for Header Cells
  Widget tableCellHeader({required String text, required bool islast}) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.3,
      child: Text(
        text,
        style:
            AppTextStyle.pw700.copyWith(color: AppColor.white, fontSize: 13.px),
        textAlign: islast ? TextAlign.end : TextAlign.start,
      ),
    );
  }

// Helper function for Data Cells
  Widget tableCell(
      {required String text, required bool isLast, required bool isFirst}) {
    return Text(
      text,
      style: isFirst
          ? AppTextStyle.pw400
              .copyWith(color: AppColor.darkGrey, fontSize: 12.px)
          : AppTextStyle.pw600
              .copyWith(color: AppColor.darkGrey, fontSize: 12.px),
      textAlign: isLast ? TextAlign.end : TextAlign.start,
    );
  }
}
