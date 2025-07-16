import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/models/invoice/invoice_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/date_utility.dart';
import '../../../../shared/utils/widget/calender_widget.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/date_range.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';

class SalesCustomerDetailScreen extends StatefulWidget {
  final PartyModel? partyModel;

  const SalesCustomerDetailScreen({super.key, required this.partyModel});

  @override
  State<SalesCustomerDetailScreen> createState() =>
      _SalesCustomerDetailScreenState();
}

class _SalesCustomerDetailScreenState extends State<SalesCustomerDetailScreen> {
  final ValueNotifier<DateTimeRange> selectedDateRange =
      ValueNotifier(getCurrentFinancialYearRange());

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(120.0),
          child: Column(
            children: [
              CustomAppBar(
                title: widget.partyModel?.partyName ?? '',
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.search,
                        color: AppColor.white,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        CupertinoIcons.sort_up,
                        color: AppColor.white,
                      ),
                    ),
                    SizedBox(width: 3.w),
                    GestureDetector(
                      onTap: () {},
                      child: const Icon(
                        Icons.more_horiz_outlined,
                        color: AppColor.white,
                      ),
                    ),
                    SizedBox(width: 5.w),
                  ],
                ),
              ),
              SizedBox(height: 1.h),
              Text(
                '₹ ${widget.partyModel?.outstandingBalance}',
                style: AppTextStyle.pw600
                    .copyWith(color: AppColor.white, fontSize: 20.px),
              ),
              Text(
                'Total Sales',
                style: AppTextStyle.pw500
                    .copyWith(color: AppColor.white, fontSize: 12.px),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: AppColor.white,
            child: Column(
              children: [
                SizedBox(height: 2.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: ValueListenableBuilder(
                    valueListenable: selectedDateRange,
                    builder: (context, value, child) {
                      return Column(
                        children: [
                          calenderRangeWidget(
                            selectedRange: value,
                            onTap: () {
                              pickDateRange(context, (DateTimeRange range) {
                                selectedDateRange.value = range;
                              });
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
                SizedBox(height: 1.h),
                Divider(
                  color: AppColor.greyContainer,
                  thickness: 3.px,
                ),
                SizedBox(height: 1.h),
                BlocBuilder<InvoiceBloc, InvoiceState>(
                    builder: (context, state) {
                  final invoices = state.invoices;

                  return ValueListenableBuilder<DateTimeRange?>(
                    valueListenable: selectedDateRange,
                    builder: (context, range, child) {
                      List<InvoiceModel> filteredInvoices = invoices
                          .where((invoice) =>
                              invoice.partyId == widget.partyModel?.id)
                          .toList();

                      if (range != null) {
                        filteredInvoices = filteredInvoices.where((invoice) {
                          DateTime invoiceDate =
                              DateTime.parse(invoice.invoiceDate.toString());
                          return invoiceDate.isAfter(range.start
                                  .subtract(const Duration(days: 1))) &&
                              invoiceDate.isBefore(
                                  range.end.add(const Duration(days: 1)));
                        }).toList();
                      }
                      return filteredInvoices.isEmpty
                          ? const Center(child: NoDataWidget())
                          : Expanded(
                              child: ListView.separated(
                                padding: EdgeInsets.symmetric(horizontal: 5.w),
                                itemBuilder: (context, index) {
                                  return itemWidget(
                                    invoice: filteredInvoices[index],
                                  );
                                },
                                separatorBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      SizedBox(height: 1.h),
                                      const Divider(
                                          color: AppColor.greyContainer),
                                      SizedBox(height: 1.h),
                                    ],
                                  );
                                },
                                itemCount: filteredInvoices.length,
                              ),
                            );
                    },
                  );
                })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget itemWidget({
    required InvoiceModel invoice,
  }) {
    return InkWell(
      onTap: () {
        if (invoice.type == InvoiceType.sales ||
            invoice.type == InvoiceType.purchase) {
          RouterHelper.push(
            context,
            AppRoutes.createSalesInvoice.name,
            extra: {
              'invoiceType': invoice.type,
              'invoice': invoice.toJson(),
            },
          );
          return;
        }
        if (invoice.type == InvoiceType.creditNote ||
            invoice.type == InvoiceType.debitNote) {
          RouterHelper.push(
            context,
            AppRoutes.createNoteInvoice.name,
            extra: {
              'invoiceType': invoice.type,
              'invoice': invoice.toJson(),
            },
          );
          return;
        }
        if (invoice.type == InvoiceType.payment ||
            invoice.type == InvoiceType.receipt) {
          RouterHelper.push(
            context,
            AppRoutes.createReceiptInvoice.name,
            extra: {
              'invoiceType': invoice.type,
              'invoice': invoice.toJson(),
            },
          );
          return;
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text('#${invoice.invoiceNumber}', style: AppTextStyle.pw500),
                  SizedBox(
                    width: 2.w,
                  ),
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.px),
                        color: AppColor.greyContainer),
                    child: Text(
                      invoice.status.name.toString(),
                      style: AppTextStyle.pw400
                          .copyWith(fontSize: 10.px, color: AppColor.grey),
                    ),
                  )
                ],
              ),
              Text(
                '₹ ${invoice.totalAmount.toStringAsFixed(2)}',
                style: AppTextStyle.pw600
                    .copyWith(fontSize: 14.px, color: AppColor.black),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  invoice.invoiceDate.convertToDisplay(),
                  style: AppTextStyle.pw400.copyWith(
                    fontSize: 12.px,
                    color: AppColor.grey,
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 3.w, vertical: 2.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(3.px),
                        color: const Color(0XFFEEF5FF)),
                    child: Text(
                      invoice.type.name,
                      style: AppTextStyle.pw500
                          .copyWith(fontSize: 14.px, color: AppColor.appColor),
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}
