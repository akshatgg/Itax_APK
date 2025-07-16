import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/data/apis/download/download_sales_invoice.dart';
import '../../../../shared/utils/widget/calender_widget.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/date_range.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../router/router_helper.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';
import '../../parties/domain/parties/parties_bloc.dart';
import '../../parties/screens/widget/customer_detail_download_widget.dart';
import 'sales_customer_screen.dart';
import 'sales_month_screen.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  @override
  void initState() {
    super.initState();
    context.read<InvoiceBloc>().add(const GetAllInvoices());
    context.read<PartiesBloc>().add(const OnGetParties());
  }

  final ValueNotifier<int> isSelect = ValueNotifier<int>(0);
  final ValueNotifier<DateTimeRange> selectedDateRange =
      ValueNotifier(getCurrentFinancialYearRange());

  @override
  Widget build(BuildContext context) {
    final partiesBloc = context.watch<PartiesBloc>();
    final customers = partiesBloc.state.customers;

    final receivablesAmount = customers
        .map((customer) => customer.outstandingBalance)
        .fold(0.0, (sum, amount) => sum + amount);
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Column(
            children: [
              CustomAppBar(
                title: 'Sales',
                child: Row(
                  children: [
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: const Icon(
                    //     Icons.search,
                    //     color: AppColor.white,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 3.w,
                    // ),
                    // GestureDetector(
                    //   onTap: () {},
                    //   child: const Icon(
                    //     CupertinoIcons.sort_up,
                    //     color: AppColor.white,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 3.w,
                    // ),
                    BlocBuilder<InvoiceBloc, InvoiceState>(
                      builder: (context, state) {
                        return GestureDetector(
                          onTap: () {
                            commonBottomSheet(context,
                                child: CustomerDetailDownloadWidget(
                                  list: false,
                                  type: 'customer',
                                  onClickItem: (index) {
                                    if (index == 0) {
                                      SalesInvoiceServices()
                                          .generateAndDownloadExcel(
                                        context,
                                        invoiceData: state.invoices,
                                      );
                                    }
                                    if (index == 1) {
                                      // PartyList().generateAndDownloadPDF(
                                      //   context,
                                      //   partyData:
                                      //   state.customers + state.suppliers,
                                      // );
                                    }
                                    if (index == 2) {
                                      // PartyList().generateAndDownloadCSV(
                                      //   context,
                                      //   party:
                                      //   state.customers + state.suppliers,
                                      // );
                                    }

                                    RouterHelper.pop<void>(context);
                                  },
                                ));
                          },
                          child: const Icon(
                            Icons.more_horiz_outlined,
                            color: AppColor.white,
                          ),
                        );
                      },
                    ),
                    SizedBox(
                      width: 5.w,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              Text(
                '₹ ${receivablesAmount.toStringAsFixed(2)}',
                style: AppTextStyle.pw600
                    .copyWith(color: AppColor.white, fontSize: 20.px),
              ),
              Text(
                'Total Sales',
                style: AppTextStyle.pw500
                    .copyWith(color: AppColor.white, fontSize: 12.px),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            color: AppColor.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              children: [
                SizedBox(
                  height: 2.h,
                ),
                ValueListenableBuilder(
                    valueListenable: isSelect,
                    builder: (context, selectedIndex, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buildSegmentButton(index: 0, text: 'Monthly'),
                          buildSegmentButton(index: 1, text: 'Customer'),
                        ],
                      );
                    }),
                dividerWidget(),
                ValueListenableBuilder(
                  valueListenable: selectedDateRange,
                  builder: (context, value, child) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: calenderRangeWidget(
                            selectedRange: value,
                            onTap: () {
                              pickDateRange(context, (DateTimeRange range) {
                                selectedDateRange.value = range;
                              });
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),
                dividerWidget(),
                ValueListenableBuilder<int>(
                  valueListenable: isSelect, // Listen to isSelect changes
                  builder: (context, selectedIndex, child) {
                    return ValueListenableBuilder<DateTimeRange?>(
                      valueListenable: selectedDateRange,
                      // Listen to date range changes
                      builder: (context, range, child) {
                        return Expanded(
                          child: selectedIndex == 1
                              ? SalesCustomerScreen(
                                  dateRange: range,
                                )
                              : SalesMonthScreen(
                                  dateRange: range,
                                ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildSegmentButton({required String text, required int index}) {
    return GestureDetector(
      onTap: () {
        isSelect.value = index; // Correctly update ValueNotifier value
      },
      child: ValueListenableBuilder<int>(
        valueListenable: isSelect,
        builder: (context, selectedIndex, child) {
          return Container(
            height: 45.px,
            width: 130.px,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border.all(
                color: selectedIndex == index
                    ? AppColor.appColor
                    : Colors.transparent,
              ),
              color: selectedIndex == index
                  ? AppColor.lightAppColor
                  : AppColor.greyContainer,
              borderRadius: BorderRadius.circular(30.px),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                color: selectedIndex == index
                    ? AppColor.appColor
                    : AppColor.darkGrey,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget dividerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 1.h,
        ),
        Divider(
          thickness: 2.px,
          color: AppColor.greyContainer,
        ),
        SizedBox(
          height: 1.h,
        ),
      ],
    );
  }
}
