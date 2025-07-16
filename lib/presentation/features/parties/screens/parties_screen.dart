import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/constants/image_constants.dart';
import '../../../../core/data/apis/download/party_list_download_service.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../../shared/utils/widget/custom_floating_button.dart';
import '../../../../shared/utils/widget/gradient_widget.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../../shared/utils/widget/search_field.dart';
import '../../../../shared/utils/widget/sort_by_bottom_model_sheet.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';
import '../../invoice/domain/notes/notes_bloc.dart';
import '../../invoice/domain/receipt/receipt_bloc.dart';
import '../domain/parties/parties_bloc.dart';
import '../domain/utils/parties_sorter.dart';
import 'widget/customer_detail_download_widget.dart';
import 'widget/party_detail.dart';

class PartiesView extends StatefulHookWidget {
  const PartiesView({super.key});

  @override
  State<PartiesView> createState() => _PartiesViewState();
}

class _PartiesViewState extends State<PartiesView> {
  final partyTypeNotifier = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    context.read<PartiesBloc>().add(const OnGetParties());
    context.read<InvoiceBloc>().add(const GetAllInvoices());
    context.read<ReceiptBloc>().add(const OnGetReceipt());
    context.read<NotesBloc>().add(const GetAllNotes());
  }

  @override
  Widget build(BuildContext context) {
    final searchTextNotifier = useState('');
    final sortingTypeNotifier = useState(0);

    return BlocListener<PartiesBloc, PartiesState>(
      listener: (context, state) {
        logger.d('PartiesBloc state: $state');


      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: GradientContainer(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            resizeToAvoidBottomInset: false,
            appBar: PreferredSize(
              preferredSize: Size.fromHeight(220.px),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            GoRouter.of(context).go(AppRoutes
                                .dashboardView.path); // Direct navigation
                          },
                          child: Icon(
                            Icons.arrow_back_ios,
                            color: AppColor.white,
                            size: 25.px,
                          ),
                        ),
                        SizedBox(
                          width: 3.w,
                        ),
                        Expanded(
                          child: Text(
                            'Parties',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        BlocBuilder<PartiesBloc, PartiesState>(
                          builder: (context, state) {
                            return GestureDetector(
                              onTap: () {
                                final combinedList = state.customers + state.suppliers;

                                commonBottomSheet(context,
                                    child: CustomerDetailDownloadWidget(
                                      list: false,
                                      type: 'customer',
                                      onClickItem: (index) {
                                        if (index == 0) {
                                          PartyList().generateAndDownloadExcel(
                                            context, partyList: combinedList,
                                          );
                                        }
                                        if (index == 1) {
                                          PartyList().generateAndDownloadPDF(
                                            context,
                                            partyData: combinedList,
                                          );
                                        }
                                        if (index == 2) {
                                          PartyList().generateAndDownloadCSV(
                                            context,
                                            party: combinedList,
                                          );
                                        }

                                        RouterHelper.pop<void>(context);
                                      },
                                    ));
                              },
                              child: const Icon(
                                Icons.more_horiz_outlined,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  ValueListenableBuilder(
                    valueListenable: partyTypeNotifier,
                    builder: (context, value, child) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildSegmentButton(text: 'Customers', index: 0),
                        _buildSegmentButton(text: 'Suppliers', index: 1),
                      ],
                    ),
                  ),
                  SizedBox(height: 3.h),
                  BlocBuilder<PartiesBloc, PartiesState>(
                    builder: (context, state) {
                      final receivablesAmount = state.customers
                          .map((customer) => customer.outstandingBalance)
                          .fold(0.0, (sum, amount) => sum + amount);
                      final payablesAmount = state.suppliers
                          .map((supplier) => supplier.outstandingBalance)
                          .fold(0.0, (sum, amount) => sum + amount);
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildAmountInfo(
                            '₹ ${receivablesAmount.abs().toStringAsFixed(2)}',
                            'Receivables',
                          ),
                          Container(
                            height: 5.h,
                            width: 2,
                            color: AppColor.white,
                          ),
                          _buildAmountInfo(
                            '₹ ${payablesAmount.abs().toStringAsFixed(2)}',
                            'Payables',
                          ),
                        ],
                      );
                    },
                  )
                ],
              ),
            ),
            floatingActionButton: CustomFloatingButton(
              tag: 'party-tag',
              title: 'Add Parties',
              imagePath: ImageConstants.addPartyIcon,
              onTap: () => RouterHelper.push(
                context,
                AppRoutes.addParty.name,
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
                      child: SearchField(
                        hint: 'Search',
                        onSearchChanged: (p0) => searchTextNotifier.value = p0,
                        onSort: () => showModalBottomSheet<void>(
                          backgroundColor: Colors.transparent,
                          context: context,
                          builder: (context) {
                            return SafeArea(
                              child: SortByBottomSheet(
                                onClickItem: (index) {
                                  sortingTypeNotifier.value = index;
                                  RouterHelper.pop<void>(context);
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 1.h),
                    const Divider(
                      color: AppColor.greyContainer,
                    ),
                    SizedBox(height: 2.h),
                    ValueListenableBuilder(
                      valueListenable: partyTypeNotifier,
                      builder: (context, value, child) {
                        return BlocBuilder<PartiesBloc, PartiesState>(
                          builder: (context, state) {
                            final List<PartyModel> customers = state.customers;
                            final suppliers = state.suppliers;
                            List<PartyModel> parties =
                                partyTypeNotifier.value == 0
                                    ? customers
                                    : suppliers;

                            if (searchTextNotifier.value.isNotEmpty) {
                              parties = parties
                                  .where(
                                    (test) =>
                                        test.partyName.toLowerCase().contains(
                                              searchTextNotifier.value
                                                  .toLowerCase(),
                                            ),
                                  )
                                  .toList();
                            }
                            parties =
                                sortParties(parties, sortingTypeNotifier.value);
                            return parties.isEmpty
                                ? const Center(child: NoDataWidget())
                                : Expanded(
                                    child: ListView.separated(
                                      separatorBuilder: (context, index) {
                                        return Divider(
                                          color: Colors.grey.shade300, // or any color you want
                                          thickness: 0.5,              // line thickness
                                          height: 2.h,                 // vertical spacing between items
                                        );
                                      },
                                      itemCount: parties.length,
                                      itemBuilder: (context, index) {
                                        return PartyDetail(
                                            partyModel: parties[index]);
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
        ),
      ),
    );
  }

  Widget _buildSegmentButton({required String text, required int index}) {
    return GestureDetector(
      onTap: () => partyTypeNotifier.value = index,
      child: Container(
        height: 40.px,
        width: 164.px,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: partyTypeNotifier.value == index
              ? Colors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(30.px),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            color: partyTypeNotifier.value == index
                ? AppColor.appColor
                : Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildAmountInfo(String amount, String label) {
    return Column(
      children: [
        Text(
          amount,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget customerDetailWidget(
      {String? name,
      String? letter,
      String? price,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Container(
            height: 30.px,
            width: 30.px,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                color: AppColor.greyContainer, shape: BoxShape.circle),
            child: Text(
              letter ?? '',
              style: AppTextStyle.pw500
                  .copyWith(color: AppColor.black, fontSize: 14.px),
            ),
          ),
          SizedBox(
            width: 2.w,
          ),
          Expanded(
              child: Text(
            name ?? '',
            style: AppTextStyle.pw500
                .copyWith(color: AppColor.black, fontSize: 14.px),
          )),
          Text(
            '₹ $price',
            style: AppTextStyle.pw700
                .copyWith(color: AppColor.black, fontSize: 15.px),
          )
        ],
      ),
    );
  }
}
