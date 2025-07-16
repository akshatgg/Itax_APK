import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/download/download_inactive_item.dart';
import '../../../../core/data/apis/models/items/item_model.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../../shared/utils/widget/search_field.dart';
import '../../../../shared/utils/widget/sort_by_bottom_model_sheet.dart';
import '../../../router/router_helper.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';
import '../../items/domain/item/item_bloc.dart';
import 'widget/amount_info_widget.dart';
import 'widget/date_sorter.dart';
import 'widget/report_inactive_customer_item_widget.dart';

class ReportInactiveItemScreen extends StatefulHookWidget {
  const ReportInactiveItemScreen({super.key});

  @override
  State<ReportInactiveItemScreen> createState() =>
      _ReportInactiveItemScreenState();
}

class _ReportInactiveItemScreenState extends State<ReportInactiveItemScreen> {
  @override
  void initState() {
    super.initState();
    context.read<ItemBloc>().add(const OnGetItem());
    context.read<InvoiceBloc>().add(const GetAllInvoices());
  }

  @override
  Widget build(BuildContext context) {
    ValueNotifier<int> inActiveItem = ValueNotifier(0);
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
                      Text('Inactive Items',
                          style: AppTextStyle.pw600
                              .copyWith(color: AppColor.white)),
                    ],
                  ),
                  BlocBuilder<ItemBloc, ItemState>(
                    builder: (context, state) {
                      var item = state.items;
                      return BlocBuilder<InvoiceBloc, InvoiceState>(
                        builder: (context, state) {
                          return InkWell(
                            onTap: () {
                              InActiveItem().generateInactiveItemsPDF(
                                  invoiceData: state.invoices, itemData: item);
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
                      inActiveItem.value.toString(),
                      'Inactive Items',
                    ),
                  ],
                );
              },
            ),
          ]),
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
                BlocBuilder<ItemBloc, ItemState>(
                  builder: (context, itemState) {
                    var items = itemState.items;
                    if (searchTextNotifier.value.isNotEmpty) {
                      items = items
                          .where((test) => test.itemName
                              .toLowerCase()
                              .contains(searchTextNotifier.value.toLowerCase()))
                          .toList();
                    }
                    return BlocBuilder<InvoiceBloc, InvoiceState>(
                      builder: (context, invoiceState) {
                        var invoices = invoiceState
                            .invoices; // Get invoices from InvoiceBloc

                        DateTime today = DateTime.now();
                        logger.d(invoices);
                        // Map item ID to its latest invoice date
                        Map<String, DateTime> latestInvoiceDates = {};

                        for (var invoice in invoices) {
                          for (var invoiceItem in invoice.invoiceItems) {
                            String itemId = (invoiceItem.itemId.toString());
                            DateTime invoiceDate = invoice.invoiceDate;

                            if (!latestInvoiceDates.containsKey(itemId) ||
                                invoiceDate
                                    .isAfter(latestInvoiceDates[itemId]!)) {
                              latestInvoiceDates[itemId] = invoiceDate;
                            }
                          }
                        }

                        // Filter items where last sale was before 30 days
                        List<ItemModel> filteredItems = items.where((item) {
                          if (latestInvoiceDates.containsKey(item.id)) {
                            return today
                                    .difference(latestInvoiceDates[item.id]!)
                                    .inDays ==
                                0;
                          }
                          return true; // If no invoice exists for the item, keep it
                        }).toList();
                        filteredItems = sortItemByInvoiceDate(
                            items, invoices, sortingTypeNotifier.value);

                        inActiveItem.value = filteredItems.length;
                        return Expanded(
                          child: filteredItems.isEmpty
                              ? const Center(child: NoDataWidget())
                              : ListView.separated(
                                  itemCount: filteredItems.length,
                                  itemBuilder: (context, index) {
                                    var item = filteredItems[index];
                                    String lastSalesDate = 'No Sales';
                                    String inactive = 'No Sales';

                                    if (latestInvoiceDates
                                        .containsKey(item.id)) {
                                      DateTime lastSales =
                                          latestInvoiceDates[item.id]!;
                                      lastSalesDate = DateFormat('dd MMM yy')
                                          .format(lastSales);
                                      int daysSinceLastSale =
                                          today.difference(lastSales).inDays;
                                      inactive = daysSinceLastSale < 30
                                          ? '$daysSinceLastSale days'
                                          : '${(daysSinceLastSale / 30).floor()} months';
                                    }

                                    return CustomerDetailWidget(
                                      type: 'customer1',
                                      name: item.itemName,
                                      phone: '',
                                      inactive: inactive,
                                      receivable: item.closingStock.toString(),
                                      lastSales: lastSalesDate,
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
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
