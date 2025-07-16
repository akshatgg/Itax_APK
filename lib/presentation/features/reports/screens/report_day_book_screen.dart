import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/enums/invoice_type.dart';
import '../../../../core/data/apis/download/item_list_download_service.dart';
import '../../../../core/utils/date_utility.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_app_bar.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../router/router_helper.dart';
import '../../parties/screens/widget/customer_detail_download_widget.dart';
import '../data/day_book_invoice.dart';
import '../domain/day_book/day_book_bloc.dart';
import 'widget/item_detail_widget.dart';

class ReportDayBookScreen extends StatefulHookWidget {
  const ReportDayBookScreen({super.key});

  @override
  State<ReportDayBookScreen> createState() => _ReportDayBookScreenState();
}

class _ReportDayBookScreenState extends State<ReportDayBookScreen> {
  final ValueNotifier<int> _selectedListTypeIndex = ValueNotifier(0);
  final ValueNotifier<DateTime> _selectedDate = ValueNotifier(DateTime.now());
  final ValueNotifier<bool> _isSortAsc = ValueNotifier(true);
  final ValueNotifier<String> _searchText = ValueNotifier('');
  final ValueNotifier<bool> _showSearchBar = ValueNotifier(false);
  List<String> option = ['Show All', 'Sales', 'Purchase', 'Receipt', 'Payment'];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<DayBookBloc>().add(const OnLoadDayBooks());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GradientContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: CustomAppBar(
          title: 'Day Book',
          onBackTap: () => RouterHelper.pop<void>(context),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => _showSearchBar.value = !_showSearchBar.value,
                child: ValueListenableBuilder<bool>(
                  valueListenable: _showSearchBar,
                  builder: (context, isShown, _) {
                    return Icon(
                      isShown ? Icons.cancel : Icons.search,
                      color: AppColor.white,
                      size: 25.px,
                    );
                  },
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: () {
                  _isSortAsc.value = !_isSortAsc.value;
                },
                child: ValueListenableBuilder<bool>(
                  valueListenable: _isSortAsc,
                  builder: (context, value, child) {
                    return Icon(
                      value ? CupertinoIcons.sort_up : CupertinoIcons.sort_down,
                      color: AppColor.white,
                      size: 25.px,
                    );
                  },
                ),
              ),
              SizedBox(width: 3.w),
              GestureDetector(
                onTap: () {
                  commonBottomSheet(context,
                      child: CustomerDetailDownloadWidget(
                        list: false,
                        type: 'customer',
                        onClickItem: (index) {
                          if (index == 0) {
                           
                          }
                          if (index == 1) {

                          }
                          if (index == 2) {}

                          RouterHelper.pop<void>(context);
                        },
                      ));
                },
                child: const Icon(
                  Icons.more_horiz_outlined,
                  color: AppColor.white,
                ),
              ),
              SizedBox(width: 5.w),
            ],
          ),
        ),
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: AppColor.white,
            child: Column(
              children: [
                ValueListenableBuilder<bool>(
                  valueListenable: _showSearchBar,
                  builder: (context, showSearch, _) {
                    return showSearch
                        ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: Container(
                        height: 40.px,
                        margin: EdgeInsets.only(top: 2.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(8.px),
                        ),
                        child: FocusScope(
                          node: FocusScopeNode(),
                          child: TextField(
                            controller: _searchController,
                            onChanged: (value) => _searchText.value = value,
                            autofocus: false, // prevents auto keyboard popup
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 10.px),
                              border: InputBorder.none,
                              hintText: 'Search',
                              hintStyle: AppTextStyle.pw400.copyWith(fontSize: 10.px),
                              suffixIcon: Icon(Icons.search, size: 16.px, color: AppColor.grey),
                            ),
                          ),
                        ),
                      ),
                    )
                        : SizedBox.shrink();
                  },
                ),
                SizedBox(height: 2.h),
                ValueListenableBuilder(
                  valueListenable: _selectedListTypeIndex,
                  builder: (context, value, child) {
                    return Container(
                      height: 40.px,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 5.w),
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: option.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              _selectedListTypeIndex.value = index;
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 2.w),
                              width: 100.px,
                              height: 40.px,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30.px),
                                border: Border.all(
                                  color: index == _selectedListTypeIndex.value
                                      ? AppColor.appColor
                                      : Colors.transparent,
                                ),
                                color: index == _selectedListTypeIndex.value
                                    ? AppColor.lightAppColor
                                    : AppColor.greyContainer,
                              ),
                              child: Text(
                                option[index],
                                style: AppTextStyle.pw500.copyWith(
                                  color: index == _selectedListTypeIndex.value
                                      ? AppColor.appColor
                                      : AppColor.darkGrey,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
                SizedBox(height: 3.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.calendar_month, color: AppColor.appColor),
                          Text('  Today', style: AppTextStyle.pw400.copyWith(fontSize: 12.px)),
                          ValueListenableBuilder<DateTime>(
                            valueListenable: _selectedDate,
                            builder: (context, value, child) {
                              return Text(
                                ' (${value.convertToDisplay()})',
                                style: AppTextStyle.pw400.copyWith(
                                  fontSize: 10.px,
                                  color: AppColor.grey,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () => _pickDate(_selectedDate),
                        child: Text(
                          'Change',
                          style: AppTextStyle.pw400.copyWith(
                            fontSize: 12.px,
                            color: AppColor.appColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 1.h),
                const Divider(color: AppColor.greyContainer, thickness: 3),
                SizedBox(height: 1.h),
                ValueListenableBuilder(
                  valueListenable: _selectedListTypeIndex,
                  builder: (context, value, child) {
                    return BlocBuilder<DayBookBloc, DayBookState>(
                      builder: (context, state) {
                        var dayBook = state.dayBooks;
                        DateTime today = _selectedDate.value;
                        InvoiceType? selectedType;

                        switch (_selectedListTypeIndex.value) {
                          case 1:
                            selectedType = InvoiceType.sales;
                            break;
                          case 2:
                            selectedType = InvoiceType.purchase;
                            break;
                          case 3:
                            selectedType = InvoiceType.receipt;
                            break;
                          case 4:
                            selectedType = InvoiceType.payment;
                            break;
                          default:
                            selectedType = null;
                        }

                        List<DayBookInvoice> allInvoices = dayBook
                            .expand((e) => e.invoices)
                            .toList();

                        List<DayBookInvoice> filteredInvoices = _filterAndSortInvoices(
                          allInvoices,
                          today,
                          selectedType,
                          _isSortAsc.value,
                          _searchText.value,
                        );

                        return filteredInvoices.isEmpty
                            ? const Center(child: NoDataWidget())
                            : Expanded(
                          child: ListView.separated(
                            itemCount: filteredInvoices.length,
                            itemBuilder: (context, index) {
                              var inv = filteredInvoices[index];
                              return ItemWidget(
                                id: inv.invoiceNumber.toString(),
                                price: inv.totalAmount.toString(),
                                date: inv.date.toString(),
                                name: inv.partyName.toString(),
                                type: getInvoiceTypeName(inv.invoiceType),
                              );
                            },
                            separatorBuilder: (context, index) => Column(
                              children: [
                                SizedBox(height: 1.h),
                                const Divider(color: AppColor.greyContainer, thickness: 2),
                                SizedBox(height: 1.h),
                              ],
                            ),
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

  List<DayBookInvoice> _filterAndSortInvoices(
      List<DayBookInvoice> all,
      DateTime today,
      InvoiceType? selectedType,
      bool isAsc,
      String search,
      ) {
    return all
        .where((invoice) {
      DateTime invoiceDate = DateTime.parse(invoice.date.toString());
      bool isSameDay = invoiceDate.year == today.year &&
          invoiceDate.month == today.month &&
          invoiceDate.day == today.day;

      bool matchesType = selectedType == null || invoice.invoiceType == selectedType;

      bool matchesSearch = search.isEmpty ||
          invoice.partyName.toLowerCase().contains(search.toLowerCase());

      return isSameDay && matchesType && matchesSearch;
    })
        .toList()
      ..sort((a, b) => isAsc
          ? a.totalAmount.compareTo(b.totalAmount)
          : b.totalAmount.compareTo(a.totalAmount));
  }

  void _pickDate(ValueNotifier<DateTime> date) async {
    var dateTime = date.value;
    var selectedDate = await showDatePicker(
      context: context,
      initialDate: dateTime,
      firstDate: DateTime(dateTime.getCenturyStartYear()),
      lastDate: DateTime(dateTime.getCenturyEndYear()),
    );
    if (selectedDate != null) {
      date.value = selectedDate;
      _selectedDate.value = selectedDate;
      context.read<DayBookBloc>().add(const OnLoadDayBooks());
    }
  }

  String getInvoiceTypeName(InvoiceType type) {
    switch (type) {
      case InvoiceType.sales:
        return 'Sales';
      case InvoiceType.purchase:
        return 'Purchase';
      case InvoiceType.receipt:
        return 'Receipt';
      case InvoiceType.payment:
        return 'Payment';
      default:
        return type.toString().split('.').last;
    }
  }
}
