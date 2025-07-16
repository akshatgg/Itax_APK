import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/image_constants.dart';
import '../../../shared/utils/widget/calender_widget.dart';
import '../../../shared/utils/widget/custom_app_bar.dart';
import '../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../shared/utils/widget/custom_image.dart';

class ReportCapitalAccountScreen extends StatefulWidget {
  const ReportCapitalAccountScreen({super.key});

  @override
  State<ReportCapitalAccountScreen> createState() =>
      _ReportCapitalAccountScreenState();
}

class _ReportCapitalAccountScreenState
    extends State<ReportCapitalAccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.white,

      /// ✅ AppBar with only gradient background
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColor.gradient1,
                AppColor.gradient2,
              ],
            ),
          ),
          child: CustomAppBar(
            title: 'Capital Account',
            child: Padding(
              padding: EdgeInsets.only(right: 5.w),
              child: const Icon(
                Icons.more_horiz_outlined,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),

      /// ✅ Body with solid white background
      body: SafeArea(
        child: Container(
          color: AppColor.white,
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header Box
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: AppColor.black),
                    ),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        Color(0xFFC8F1BF),
                        Color(0xFFE1F3DD),
                        Color(0xFFDCF3D9),
                      ],
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CustomImageView(
                        imagePath: ImageConstants.capitalProfile,
                        height: 40,
                        width: 40,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            profileDetailWidget(
                                title: 'Name', detail: 'Shabaz Alam'),
                            profileDetailWidget(
                                title: 'GSTIN', detail: '22AAAA0000A1Z5'),
                            profileDetailWidget(
                                title: 'Financial year', detail: '2024-25'),
                          ],
                        ),
                      ),
                      const Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: EdgeInsets.only(top: 36),
                          child: Icon(Icons.arrow_forward_ios, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 2.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Text(
                    'Capital Transactions',
                    style: AppTextStyle.pw600.copyWith(
                      color: AppColor.black,
                      fontSize: 16.px,
                    ),
                  ),
                ),
                SizedBox(height: 2.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: calenderWidget(
                    onTap: () {},
                    selectedRange: 'Apr 24 to 31 Mar 25',
                  ),
                ),
                SizedBox(height: 2.h),

                /// Table Header
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                  decoration: const BoxDecoration(color: AppColor.appColor),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child:
                            tableCellHeader(text: 'Particular', islast: false),
                      ),
                      Expanded(
                        flex: 1,
                        child: tableCellHeader(text: 'Debit', islast: false),
                      ),
                      Expanded(
                        flex: 1,
                        child: tableCellHeader(text: 'Credit', islast: true),
                      ),
                    ],
                  ),
                ),

                /// Static Table Rows
                Column(
                  children: List.generate(7, (index) {
                    return rowItem('Chaitaniya', '0.00', '1,61,450');
                  }),
                ),

                /// Total Footer
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.5.h),
                  decoration: const BoxDecoration(color: AppColor.appColor),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: tableCellHeader(text: 'Total', islast: false),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            tableCellHeader(text: '₹ 28,96,400', islast: false),
                      ),
                      Expanded(
                        flex: 1,
                        child:
                            tableCellHeader(text: '₹ 97,65,750', islast: true),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),

      /// Floating Button
      floatingActionButton: Align(
        alignment: Alignment.bottomRight,
        child: CustomElevatedButton(
          width: 130.px,
          height: 45.px,
          text: 'Print',
          leftIcon: const Icon(
            Icons.print,
            color: AppColor.white,
          ),
        ),
      ),
    );
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
        children: [
          Expanded(
            flex: 2,
            child: tableCell(text: title, isLast: false, isFirst: true),
          ),
          Expanded(
            flex: 1,
            child: tableCell(text: '₹ $debit', isLast: false, isFirst: false),
          ),
          Expanded(
            flex: 1,
            child: tableCell(text: '₹ $credit', isLast: true, isFirst: false),
          ),
        ],
      ),
    );
  }

  Widget tableCellHeader({required String text, required bool islast}) {
    return Text(
      text,
      style: AppTextStyle.pw700.copyWith(
        color: AppColor.white,
        fontSize: 13.px,
      ),
      textAlign: islast ? TextAlign.end : TextAlign.start,
    );
  }

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

  Widget profileDetailWidget({String? title, String? detail}) {
    return Row(
      children: [
        SizedBox(
          width: 103.px,
          child: Text(
            title ?? '',
            style: AppTextStyle.pw500.copyWith(color: AppColor.black),
          ),
        ),
        SizedBox(
          width: 140.px,
          child: Text(
            ': $detail',
            style: AppTextStyle.pw400
                .copyWith(color: AppColor.black, fontSize: 14.px),
          ),
        ),
      ],
    );
  }
}
