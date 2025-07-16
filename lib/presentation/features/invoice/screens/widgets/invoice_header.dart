import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import 'edit_invoice_header_bottom_sheet.dart';

class InvoiceHeader extends StatelessWidget {
  const InvoiceHeader({
    super.key,
    required this.invoiceDateNotifier,
    required this.invoiceNoNotifier,
    required this.dueDateNotifier,
  });

  final ValueNotifier<DateTime> invoiceDateNotifier;
  final ValueNotifier<int> invoiceNoNotifier;
  final ValueNotifier<DateTime> dueDateNotifier;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Invoice #${invoiceNoNotifier.value}',
                style: AppTextStyle.pw600
                    .copyWith(color: AppColor.appColor, fontSize: 14.px),
              ),
              SizedBox(height: 1.h),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_month,
                    color: AppColor.darkGrey,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '${DateFormat("d MMM yy").format(invoiceDateNotifier.value)}  |  Due : '
                      '${DateFormat("d MMM yy").format(dueDateNotifier.value)}',
                      style: AppTextStyle.pw400
                          .copyWith(fontSize: 14.px, color: AppColor.grey),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet<EditInvoiceHeaderBottomSheet>(
              backgroundColor: Colors.transparent,
              context: context,
              builder: (context) => SafeArea(
                child: EditInvoiceHeaderBottomSheet(
                  onSave: (invoiceDate, invoiceNumber, dueDate) {
                    invoiceDateNotifier.value = invoiceDate;
                    invoiceNoNotifier.value = invoiceNumber;
                    dueDateNotifier.value = dueDate;
                  },
                  initialInvoiceDate: invoiceDateNotifier.value,
                  initialInvoiceNumber: invoiceNoNotifier.value,
                  initialDueDate: dueDateNotifier.value,
                ),
              ),
            );
          },
          child: Text(
            'Edit',
            style: AppTextStyle.pw500.copyWith(
              color: AppColor.appColor,
              fontSize: 14.px,
            ),
          ),
        ),
      ],
    );
  }
}
