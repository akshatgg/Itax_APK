import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_status.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/date_utility.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/custom_elevated_button.dart';
import '../../../../shared/utils/widget/custom_textfield.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../router/router_helper.dart';
import '../domain/invoice/invoice_bloc.dart';

class UnpaidInvoiceScreen extends StatefulWidget {
  const UnpaidInvoiceScreen({
    super.key,
    required this.partyModel,
    required this.invoices,
    this.selectOnlyOne = false,
  });

  final PartyModel partyModel;
  final List<String> invoices;
  final bool selectOnlyOne;

  @override
  State<UnpaidInvoiceScreen> createState() => _UnpaidInvoiceScreenState();
}

class _UnpaidInvoiceScreenState extends State<UnpaidInvoiceScreen> {
  @override
  Widget build(BuildContext context) {
    final invoiceBloc = context.watch<InvoiceBloc>();
    final invoices = invoiceBloc.partyWiseInvoices[widget.partyModel.id] ?? [];
    final unpaidInvoices = invoices
        .where((element) => element.status == InvoiceStatus.unpaid)
        .toList();
    final amountControllers = List.generate(
      unpaidInvoices.length,
      (index) => TextEditingController(),
    );
    unpaidInvoices.removeWhere(
        (element) => widget.invoices.contains(element.id.toString()));
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: const CustomAppBar(title: 'Unpaid Invoices'),
        bottomNavigationBar: widget.selectOnlyOne
            ? const SizedBox.shrink()
            : BottomAppBar(
                color: AppColor.white,
                shadowColor: AppColor.black,
                elevation: 1.0,
                child: CustomElevatedButton(
                  height: 40.px,
                  text: 'Proceed',
                  buttonColor: AppColor.appColor,
                  textColor: AppColor.white,
                  onTap: () {
                    final isAllAmountFilled = amountControllers.every(
                        (element) =>
                            element.text.isNotEmpty && element.text != '0');
                    if (!isAllAmountFilled) {
                      return;
                    }
                    final invoiceAmounts = amountControllers
                        .map((e) => double.tryParse(e.text) ?? 0.0)
                        .toList();
                    Map<String, double> invoiceAmountsMap = {};
                    for (var i = 0; i < invoiceAmounts.length; i++) {
                      invoiceAmountsMap[unpaidInvoices[i].id] =
                          invoiceAmounts[i];
                    }
                    RouterHelper.pop<Map<String, double>>(
                      context,
                      data: invoiceAmountsMap,
                    );
                  },
                ),
              ),
        body: SafeArea(
          child: Container(
            color: AppColor.white,
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: ListView.separated(
              itemCount: unpaidInvoices.length,
              separatorBuilder: (context, index) {
                return Divider(
                  thickness: 3.px,
                  color: AppColor.greyContainer,
                );
              },
              itemBuilder: (context, index) {
                final invoice = unpaidInvoices[index];
                final invoiceAmount = invoice.totalAmount.toString();
                final remainingBalance = invoice.remainingBalance.toString();
                return unPaidItemDetailWidget(
                  controller: amountControllers[index],
                  iNumber: '# ${invoice.invoiceNumber}',
                  price: invoiceAmount,
                  date: invoice.invoiceDate.convertToDisplay(),
                  invoiceAmount: '₹ $invoiceAmount',
                  remainingBalance: '₹ $remainingBalance',
                  invoiceId: invoice.id,
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget unPaidItemDetailWidget({
    required String iNumber,
    required String price,
    required String date,
    required String invoiceAmount,
    required String remainingBalance,
    required TextEditingController controller,
    required String invoiceId,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: Column(
        spacing: 1.w,
        children: [
          Row(
            spacing: 2.w,
            children: [
              Expanded(
                child: Text(
                  iNumber,
                  style: AppTextStyle.pw600.copyWith(
                    color: AppColor.darkGrey,
                    fontSize: 14.px,
                  ),
                ),
              ),
              Expanded(
                child: CustomTextfield(
                  controller: controller,
                  hint: '₹ 0',
                  lable: '',
                  keyboardType: TextInputType.number,
                ),
              ),
              Expanded(
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColor.appColor),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: AppColor.appColor),
                      borderRadius: BorderRadius.circular(
                        10.px,
                      ),
                    ),
                  ),
                  onPressed: () {
                    controller.text = price;
                    if (widget.selectOnlyOne) {
                      RouterHelper.pop<String>(context, data: invoiceId);
                    }
                  },
                  child: Text(
                    widget.selectOnlyOne ? 'Select' : 'Pay in Full',
                    style: AppTextStyle.pw600.copyWith(
                      color: AppColor.appColor,
                      fontSize: 14.px,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              segmentWidget(title: 'Date', desc: date),
              segmentWidget(title: 'Total', desc: invoiceAmount),
              segmentWidget(title: 'Balance', desc: remainingBalance),
            ],
          )
        ],
      ),
    );
  }

  Widget segmentWidget({required String title, required String desc}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyle.pw400
              .copyWith(color: AppColor.grey, fontSize: 12.px),
        ),
        SizedBox(
          height: 1.h,
        ),
        Text(
          desc,
          style: AppTextStyle.pw500
              .copyWith(color: AppColor.grey, fontSize: 14.px),
        )
      ],
    );
  }
}
