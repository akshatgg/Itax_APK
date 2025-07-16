import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';

class SalesMonthScreen extends StatelessWidget {
  final DateTimeRange? dateRange;

  const SalesMonthScreen({super.key, this.dateRange});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvoiceBloc, InvoiceState>(
      builder: (context, state) {
        var customer = state.invoices;
        // Filter by Invoice Type
        customer = state.invoices
            .where((invoice) => invoice.type.name == 'sales')
            .toList();

        // Apply Date Range Filtering if Available
        if (dateRange != null) {
          customer = customer.where((invoice) {
            DateTime invoiceDate =
                DateTime.parse(invoice.invoiceDate.toString());
            return invoiceDate.isAfter(
                    dateRange!.start.subtract(const Duration(days: 1))) &&
                invoiceDate
                    .isBefore(dateRange!.end.add(const Duration(days: 1)));
          }).toList();
        }
        return customer.isEmpty
            ? const Center(child: NoDataWidget())
            : ListView.separated(
                itemBuilder: (context, index) {
                  return monthItemDetailWidget(
                    name: customer[index].partyName,
                    price:
                        '₹ ${customer[index].totalAmount.toStringAsFixed(2)}',
                    date: DateFormat('dd MMM yyyy').format(
                      DateTime.parse(customer[index].invoiceDate.toString()),
                    ),
                    iNumber: customer[index].invoiceNumber.toString(),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider(
                    color: AppColor.greyContainer,
                    thickness: 2.px,
                  );
                },
                itemCount: customer.length);
      },
    );
  }

  Widget monthItemDetailWidget(
      {required String name,
      required String price,
      required String date,
      required String iNumber}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: AppTextStyle.pw500
                    .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
              ),
              Text(
                price,
                style: AppTextStyle.pw600
                    .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
              )
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Text(
            '$date  |  #$iNumber',
            style: AppTextStyle.pw400
                .copyWith(color: AppColor.grey, fontSize: 12.px),
          ),
        ],
      ),
    );
  }
}
