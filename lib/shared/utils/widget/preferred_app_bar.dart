// parties_app_bar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/data/apis/download/party_list_download_service.dart';
import '../../../presentation/features/parties/domain/parties/parties_bloc.dart';
import '../../../presentation/features/parties/screens/widget/customer_detail_download_widget.dart';
import '../../../presentation/router/router_helper.dart';
import '../../../presentation/router/routes.dart';
import 'change_detail_dialog.dart';

class PreferredAppBar extends StatelessWidget {
  final ValueNotifier<int> partyTypeNotifier;

  const PreferredAppBar({super.key, required this.partyTypeNotifier});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColor.appColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      toolbarHeight: 205.px,
      flexibleSpace: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => GoRouter.of(context).go(AppRoutes.dashboardView.path),
                  child: Icon(Icons.arrow_back_ios, color: AppColor.white, size: 25.px),
                ),
                SizedBox(width: 3.w),
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
                        commonBottomSheet(
                          context,
                          child: CustomerDetailDownloadWidget(
                            list: false,
                            type: 'customer',
                            onClickItem: (index) {
                              final allParties = state.customers + state.suppliers;
                              switch (index) {
                                case 0:
                                  PartyList().generateAndDownloadExcel(context, partyList: allParties);
                                  break;
                                case 1:
                                  PartyList().generateAndDownloadPDF(context, partyData: allParties);
                                  break;
                                case 2:
                                  PartyList().generateAndDownloadCSV(context, party: allParties);
                                  break;
                              }
                              RouterHelper.pop<void>(context);
                            },
                          ),
                        );
                      },
                      child: const Icon(Icons.more_horiz_outlined, color: Colors.white),
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
                _buildSegmentButton(text: 'Customers', index: 0, partyTypeNotifier: partyTypeNotifier),
                _buildSegmentButton(text: 'Suppliers', index: 1, partyTypeNotifier: partyTypeNotifier),
              ],
            ),
          ),
          SizedBox(height: 3.h),
          BlocBuilder<PartiesBloc, PartiesState>(
            builder: (context, state) {
              final receivablesAmount = state.customers.map((c) => c.outstandingBalance).fold(0.0, (a, b) => a + b);
              final payablesAmount = state.suppliers.map((s) => s.outstandingBalance).fold(0.0, (a, b) => a + b);
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildAmountInfo('₹ ${receivablesAmount.abs().toStringAsFixed(2)}', 'Receivables'),
                  Container(height: 5.h, width: 2, color: AppColor.white),
                  _buildAmountInfo('₹ ${payablesAmount.abs().toStringAsFixed(2)}', 'Payables'),
                ],
              );
            },
          )
        ],
      ),
    );
  }

  Widget _buildSegmentButton({required String text, required int index, required ValueNotifier<int> partyTypeNotifier}) {
    return GestureDetector(
      onTap: () => partyTypeNotifier.value = index,
      child: Column(
        children: [
          Text(
            text,
            style: TextStyle(
              color: partyTypeNotifier.value == index ? AppColor.white : AppColor.white.withOpacity(0.5),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 1.h),
          Container(
            height: 2,
            width: 40,
            color: partyTypeNotifier.value == index ? AppColor.white : Colors.transparent,
          ),
        ],
      ),
    );
  }

  Widget _buildAmountInfo(String amount, String label) {
    return Column(
      children: [
        Text(amount, style: TextStyle(fontSize: 14.sp, color: AppColor.white, fontWeight: FontWeight.w700)),
        SizedBox(height: 0.5.h),
        Text(label, style: TextStyle(fontSize: 12.sp, color: AppColor.white.withOpacity(0.8))),
      ],
    );
  }
}
