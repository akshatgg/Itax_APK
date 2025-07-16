import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/download/download_inactive_customer.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_image.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/search_field.dart';
import '../../../../shared/utils/widget/sort_by_bottom_model_sheet.dart';
import '../../../router/router_helper.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';
import '../../parties/domain/parties/parties_bloc.dart';
import 'widget/amount_info_widget.dart';
import 'widget/date_sorter.dart';
import 'widget/report_inactive_customer_item_widget.dart';

class ReportInactiveCustomerScreen extends StatefulHookWidget {
  const ReportInactiveCustomerScreen({super.key});

  @override
  State<ReportInactiveCustomerScreen> createState() =>
      _ReportInactiveCustomerScreenState();
}

class _ReportInactiveCustomerScreenState
    extends State<ReportInactiveCustomerScreen> {
  @override
  void initState() {
    super.initState();
    context.read<PartiesBloc>().add(const OnGetParties());
  }

  ValueNotifier<int> inActiveCustomer = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    final searchTextNotifier = useState('');
    final sortingTypeNotifier = useState(0);
    return GradientContainer(
        child: Scaffold(
      backgroundColor: Colors.transparent,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.px),
        child: Column(children: [
          SizedBox(
            height: 5.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => RouterHelper.pop<void>(context),
                      child: const Icon(Icons.arrow_back_ios,
                          color: AppColor.white),
                    ),
                    const SizedBox(width: 10),
                    // Add spacing between icon and text
                    Text('Inactive Customers',
                        style:
                            AppTextStyle.pw600.copyWith(color: AppColor.white)),
                  ],
                ),
                BlocBuilder<PartiesBloc, PartiesState>(
                  builder: (context, state) {
                    return InkWell(
                      onTap: () {
                        InActiveCustomer().generateAndDownloadPDF(
                            partyData: state.customers + state.suppliers);
                      },
                      child: Container(
                        height: 25.px,
                        width: 25.px,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(7.px),
                            color: AppColor.white),
                        child: Icon(
                          Icons.picture_as_pdf,
                          color: AppColor.red,
                          size: 15.px,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
          SizedBox(
            height: 3.h,
          ),
          BlocBuilder<InvoiceBloc, InvoiceState>(
            builder: (context, state) {
              final invoices = state.invoices;
              final receivables = invoices
                  .where((invoice) => invoice.type == InvoiceType.sales)
                  .toList();

              final receivablesAmount = receivables
                  .map((invoice) => invoice.totalAmount)
                  .fold(0.0, (sum, amount) => sum + amount);

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildAmountInfo(
                    '₹ ${receivablesAmount.toStringAsFixed(2)}',
                    'Receivables',
                  ),
                  Container(
                    height: 5.h,
                    width: 2,
                    color: AppColor.white,
                  ),
                  buildAmountInfo(
                    inActiveCustomer.value.toString(),
                    'Inactive Customers',
                  ),
                ],
              );
            },
          ),
        ]),
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
                child: SearchField(
                  hint: 'Search',
                  onSearchChanged: (p0) => searchTextNotifier.value = p0,
                  onSort: () => commonBottomSheet(
                    context,
                    child: SortByDayBottomSheet(
                      onClickItem: (index) {
                        sortingTypeNotifier.value = index;
                        RouterHelper.pop<void>(context);
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              BlocBuilder<PartiesBloc, PartiesState>(
                builder: (context, state) {
                  List<PartyModel> customers =
                      state.customers + state.suppliers;

                  if (searchTextNotifier.value.isNotEmpty) {
                    customers = customers
                        .where((test) => test.partyName
                            .toLowerCase()
                            .contains(searchTextNotifier.value.toLowerCase()))
                        .toList();
                  }

                  customers = sortDate(customers, sortingTypeNotifier.value);

                  // Filter customers whose last sales date is before 30 days
                  DateTime today = DateTime.now();
                  customers = customers.where((customer) {
                    if (customer.invoices.isNotEmpty) {
                      DateTime lastSalesDate = customer.invoices
                          .map((invoice) => invoice.invoiceDate)
                          .reduce((a, b) => a.isAfter(b) ? a : b);
                      logger.d(lastSalesDate);
                      // Only include customers whose last sale is more than 30 days ago
                      return today.difference(lastSalesDate).inDays > 30;
                    }
                    return true; // Include customers with no sales history
                  }).toList();
                  inActiveCustomer.value = customers.length;
                  logger.d(customers);
                  return Expanded(
                    child: customers.isEmpty
                        ? Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CustomImageView(
                                  imagePath: 'assets/images/no-data.png',
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  'No Data Available',
                                  style: AppTextStyle.pw500
                                      .copyWith(fontSize: 16.px),
                                ),
                                Text(
                                  'No data available. Please try again after making relevant changes.',
                                  style: AppTextStyle.pw400.copyWith(),
                                  textAlign: TextAlign.center,
                                )
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: customers.length,
                            itemBuilder: (context, index) {
                              String inactive = '';
                              DateTime lastSalesDate = DateTime.now();

                              if (customers[index].invoices.isNotEmpty) {
                                lastSalesDate = customers[index]
                                    .invoices
                                    .map((invoice) => invoice.invoiceDate)
                                    .reduce((a, b) => a.isAfter(b) ? a : b);

                                Duration difference =
                                    today.difference(lastSalesDate);

                                inactive = difference.inDays < 30
                                    ? '${difference.inDays} days'
                                    : '${(difference.inDays / 30).floor()} months';
                              } else {
                                inactive = 'No Sales';
                              }

                              return CustomerDetailWidget(
                                type: 'customer',
                                name: customers[index].partyName,
                                phone: customers[index].phone,
                                inactive: inactive,
                                receivable: '₹ ${customers[index].totalCredit}',
                                lastSales: DateFormat('dd MMM yy')
                                    .format(lastSalesDate),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return const Divider(
                                thickness: 3,
                                color: AppColor.greyContainer,
                              );
                            },
                          ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    ));
  }
}
