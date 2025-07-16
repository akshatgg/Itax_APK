import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/constants/app_text_style.dart';
import '../../../../core/constants/color_constants.dart';
import '../../../../core/data/apis/models/dashboard/dashboard_data_model.dart';
import '../../../../core/data/apis/models/party/party_model.dart';
import '../../../../core/data/repos/dashboard_data_repo.dart';
import '../../../../core/utils/get_it_instance.dart';
import '../../../../shared/utils/widget/no_data_widget.dart';
import '../../../router/router_helper.dart';
import '../../../router/routes.dart';
import '../../invoice/domain/invoice/invoice_bloc.dart';
import '../../parties/domain/parties/parties_bloc.dart';

class SalesCustomerScreen extends StatefulWidget {
  final DateTimeRange? dateRange;

  const SalesCustomerScreen({super.key, this.dateRange});

  @override
  State<SalesCustomerScreen> createState() => _SalesCustomerScreenState();
}

class _SalesCustomerScreenState extends State<SalesCustomerScreen> {
  late final DashboardDataModel dashboardData;
  late final DashboardDataRepo dashboardDataRepo;

  @override
  void initState() {
    super.initState();
    dashboardDataRepo = getIt.get<DashboardDataRepo>();
    dashboardData = dashboardDataRepo.dashboardData ?? DashboardDataModel();
    dashboardDataRepo.addListener(_onDashboardDataUpdate);
  }

  void _onDashboardDataUpdate() {
    setState(() {
      dashboardData = dashboardDataRepo.dashboardData ?? DashboardDataModel();
    });
  }

  List<FlSpot> _getSalesData() {
    final List<FlSpot> salesData = [];
    final salesAmount = dashboardData.currentYearSalesAmount;
    for (int i = 0; i <= 11; i++) {
      salesData.add(FlSpot(i.toDouble(), salesAmount[i + 1] ?? 0));
    }
    return salesData;
  }

  List<FlSpot> _getPurchaseData() {
    final List<FlSpot> purchaseData = [];
    final purchaseAmount = dashboardData.currentYearPurchaseAmount;
    for (int i = 0; i <= 11; i++) {
      purchaseData.add(FlSpot(i.toDouble(), purchaseAmount[i + 1] ?? 0));
    }
    return purchaseData;
  }

  double getSalesAmount() {
    return dashboardData.currentYearSalesAmountTotal;
  }

  double getPurchaseAmount() {
    return dashboardData.currentYearPurchaseAmountTotal;
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> salesData = _getSalesData();
    final List<FlSpot> purchaseData = _getPurchaseData();
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              chartIndicatorWidget(title: 'Sales', color: AppColor.appColor),
              SizedBox(
                width: 3.w,
              ),
              chartIndicatorWidget(
                  title: 'Purchase', color: const Color(0XFFA7BFE4)),
            ],
          ),
        ),
        SizedBox(
          height: 1.h,
        ),
        Container(
          height: 200,
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: LineChart(
            LineChartData(
              titlesData: FlTitlesData(
                rightTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                topTitles:
                    const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 20000,
                    getTitlesWidget: (value, meta) {
                      return Text(
                        '${(value / 1000).toInt()}K',
                        style:
                            const TextStyle(fontSize: 12, color: Colors.black),
                      );
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      const months = [
                        'Jan',
                        'Feb',
                        'Mar',
                        'Apr',
                        'May',
                        'Jun',
                        'Jul',
                        'Aug',
                        'Sep',
                        'Oct',
                        'Nov',
                        'Dec'
                      ];
                      return Text(
                        months[value.toInt()],
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      );
                    },
                    interval: 1, // Show every month
                  ),
                ),
              ),
              gridData: FlGridData(
                show: true,
                drawVerticalLine: false,
                // Show X-axis grid lines
                drawHorizontalLine: false,
                getDrawingHorizontalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  // Light grey horizontal lines
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: Colors.grey.shade300,
                  // Light grey vertical lines
                  strokeWidth: 1,
                ),
              ),
              borderData: FlBorderData(
                show: true,
                border: const Border(
                    left: BorderSide(color: AppColor.black),
                    bottom: BorderSide(color: AppColor.black)),
              ),
              lineBarsData: [
                LineChartBarData(
                    spots: salesData, isCurved: true, color: AppColor.appColor),
                LineChartBarData(
                    spots: purchaseData, isCurved: true, color: AppColor.red),
              ],
            ),
          ),
        ),
        dividerWidget(),
        BlocBuilder<PartiesBloc, PartiesState>(
          builder: (context, partiesState) {
            List<PartyModel> customers = partiesState.customers;

            return BlocBuilder<InvoiceBloc, InvoiceState>(
              builder: (context, invoiceState) {
                var invoices = invoiceState.invoices;

                // Filter customers based on invoices, but also allow customers with no invoices
                customers = customers.where((customer) {
                  // Include customer if they have any invoices or if their invoices list is empty
                  return invoices
                          .any((invoice) => invoice.partyId == customer.id) ||
                      customer.invoices.isEmpty;
                }).toList();
                // logger.d(customers);
                // Check if there are no customers to display
                if (customers.isEmpty) {
                  return const Center(child: NoDataWidget());
                }
                // Return the ListView with the filtered customers
                return Expanded(
                  child: ListView.separated(
                    itemCount: customers.length,
                    itemBuilder: (context, index) {
                      final customer = customers[index];
                      return customerDetailItemWidget(
                        name: customer.partyName,
                        price: '₹ ${customer.outstandingBalance}',
                        onTap: () {
                          RouterHelper.push(
                            context,
                            AppRoutes.salesCustomerDetailScreen.name,
                            extra: {
                              'party': customer.toJson(),
                            },
                          );
                        },
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        color: AppColor.greyContainer,
                        thickness: 2.px,
                      );
                    },
                  ),
                );
              },
            );
          },
        )
      ],
    );
  }

  Widget chartIndicatorWidget({required String title, required Color color}) {
    return Row(
      children: [
        Container(
          height: 15.px,
          width: 15.px,
          color: color,
        ),
        SizedBox(
          width: 3.w,
        ),
        Text(
          title,
          style: AppTextStyle.pw400.copyWith(color: AppColor.darkGrey),
        )
      ],
    );
  }

  Widget customerDetailItemWidget(
      {required String name,
      required String price,
      required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              name,
              style: AppTextStyle.pw400
                  .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
            ),
            Text(
              price,
              style: AppTextStyle.pw600
                  .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
            )
          ],
        ),
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
