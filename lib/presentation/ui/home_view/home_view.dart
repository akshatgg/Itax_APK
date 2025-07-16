import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constants/app_text_style.dart';
import '../../../core/constants/color_constants.dart';
import '../../../core/constants/enums/invoice_type.dart';
import '../../../core/constants/image_constants.dart';
import '../../../core/data/apis/models/dashboard/dashboard_data_model.dart';
import '../../../core/data/repos/company_repo.dart';
import '../../../core/data/repos/dashboard_data_repo.dart';
import '../../../core/utils/get_it_instance.dart';
import '../../../shared/utils/widget/change_detail_dialog.dart';
import '../../../shared/utils/widget/custom_app_bar_more.dart';
import '../../../shared/utils/widget/custom_floating_button.dart';
import '../../../shared/utils/widget/custom_image.dart';
import '../../features/company/domain/company_bloc.dart';
import '../../features/company/select_company_bottomsheet.dart';
import '../../features/items/domain/item/item_bloc.dart';
import '../../features/parties/domain/parties/parties_bloc.dart';
import '../../features/parties/screens/widget/overview_item_widget.dart';
import '../../router/router_helper.dart';
import '../../router/routes.dart';
import 'widget/banner_slider.dart';
import 'widget/select_option_widget.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ValueNotifier<String> selectDuration = ValueNotifier<String>('');
  ValueNotifier<String> staticSelectOption = ValueNotifier<String>('This Year');
  ValueNotifier<String> overViewSelectOption =
      ValueNotifier<String>('This Year');

  late DashboardDataModel dashboardData;
  late DashboardDataRepo dashboardDataRepo;

  final List<String> imageList = [
    'assets/images/Banner_1.svg',
    'assets/images/Banner_2.svg',
  ];
  List<Invoice> listInvoice = [
    Invoice(
      title: 'Sales',
      image: ImageConstants.salesIcon,
      path: AppRoutes.createSalesInvoice.name,
      invoiceType: InvoiceType.sales,
    ),
    Invoice(
      title: 'Purchase',
      image: ImageConstants.purchaseIcon,
      path: AppRoutes.createSalesInvoice.name,
      invoiceType: InvoiceType.purchase,
    ),
    Invoice(
      title: 'Receipt',
      image: ImageConstants.receiptIcon,
      path: AppRoutes.createReceiptInvoice.name,
      invoiceType: InvoiceType.receipt,
    ),
    Invoice(
      title: 'Payment',
      image: ImageConstants.paymentIcon,
      path: AppRoutes.createReceiptInvoice.name,
      invoiceType: InvoiceType.payment,
    ),
    Invoice(
      title: 'Debit Note',
      image: ImageConstants.debitNoteIcon,
      path: AppRoutes.createNoteInvoice.name,
      invoiceType: InvoiceType.debitNote,
    ),
    Invoice(
      title: 'Credit note',
      image: ImageConstants.creditNoteIcon,
      path: AppRoutes.createNoteInvoice.name,
      invoiceType: InvoiceType.creditNote,
    ),
  ];

  @override
  void initState() {
    super.initState();
    final companyBloc = context.read<CompanyBloc>();

    final companyRepo = getIt.get<CompanyRepo>();
    companyRepo.getAllCompany(); // ensure currentCompany is filled
    final companyId = companyRepo.currentCompany?.id;

    if (companyId != null) {
      context.read<ItemBloc>().add(const OnGetItem());
      context.read<PartiesBloc>().add(const OnGetParties());
    }
    dashboardDataRepo = getIt.get<DashboardDataRepo>();
    dashboardData = dashboardDataRepo.dashboardData ?? DashboardDataModel();
    dashboardDataRepo.addListener(_onDashboardDataUpdate);
  }

  void _onDashboardDataUpdate() {
    setState(() {
      dashboardData = dashboardDataRepo.dashboardData ?? DashboardDataModel();
    });
  }

  @override
  void dispose() {
    dashboardDataRepo.removeListener(_onDashboardDataUpdate);
    super.dispose();
  }

  List<FlSpot> _getSalesData() {
    final List<FlSpot> salesData = List.empty(growable: true);

    if (staticSelectOption.value == 'This Year') {
      final salesAmount = dashboardData.currentYearSalesAmount;

      for (int i = 0; i <= 11; i++) {
        final value = salesAmount[i + 1] ?? 0;
        salesData.add(FlSpot(i.toDouble(), value));
      }
    } else if (staticSelectOption.value == 'Previous Year') {
      final salesAmount = dashboardData.previousYearSalesAmount;

      for (int i = 0; i <= 11; i++) {
        final value = salesAmount[i + 1] ?? 0;
        salesData.add(FlSpot(i.toDouble(), value));
      }
    } else if (staticSelectOption.value == 'This Month') {
      final salesAmount = dashboardData.currentMonthSalesAmount;

      for (int i = 0; i <= 30; i++) {
        final value = salesAmount[i + 1] ?? 0;
        salesData.add(FlSpot(i.toDouble(), value));
      }
    } else if (staticSelectOption.value == 'This Week') {
      final salesAmount = dashboardData.currentWeekSalesAmount;

      for (int i = 0; i <= 6; i++) {
        final value = salesAmount[i + 1] ?? 0;
        salesData.add(FlSpot(i.toDouble(), value));
      }
    }

    return salesData;
  }

  List<FlSpot> _getPurchaseData() {
    final List<FlSpot> salesData = List.empty(growable: true);
    if (staticSelectOption.value == 'This Year') {
      final purchaseAmount = dashboardData.currentYearPurchaseAmount;
      for (int i = 0; i <= 11; i++) {
        salesData.add(FlSpot(i.toDouble(), purchaseAmount[i + 1] ?? 0));
      }
      return salesData;
    } else if (staticSelectOption.value == 'Previous Year') {
      final purchaseAmount = dashboardData.previousYearPurchaseAmount;
      for (int i = 0; i <= 11; i++) {
        salesData.add(FlSpot(i.toDouble(), purchaseAmount[i + 1] ?? 0));
      }
      return salesData;
    } else if (staticSelectOption.value == 'This Month') {
      final purchaseAmount = dashboardData.currentMonthPurchaseAmount;
      for (int i = 0; i <= 30; i++) {
        salesData.add(FlSpot(i.toDouble(), purchaseAmount[i + 1] ?? 0));
      }
      return salesData;
    } else if (staticSelectOption.value == 'This Week') {
      final purchaseAmount = dashboardData.currentWeekPurchaseAmount;
      for (int i = 0; i <= 6; i++) {
        salesData.add(FlSpot(i.toDouble(), purchaseAmount[i + 1] ?? 0));
      }
      return salesData;
    }
    return [];
  }

  double getSalesAmount() {
    if (staticSelectOption.value == 'This Year') {
      return dashboardData.currentYearSalesAmountTotal;
    } else if (staticSelectOption.value == 'Previous Year') {
      return dashboardData.previousYearSalesAmountTotal;
    } else if (staticSelectOption.value == 'This Month') {
      return dashboardData.currentMonthSalesAmountTotal;
    } else if (staticSelectOption.value == 'This Week') {
      return dashboardData.currentWeekSalesAmountTotal;
    }
    return 0;
  }

  double getPurchaseAmount() {
    if (staticSelectOption.value == 'This Year') {
      return dashboardData.currentYearPurchaseAmountTotal;
    } else if (staticSelectOption.value == 'Previous Year') {
      return dashboardData.previousYearPurchaseAmountTotal;
    } else if (staticSelectOption.value == 'This Month') {
      return dashboardData.currentMonthPurchaseAmountTotal;
    } else if (staticSelectOption.value == 'This Week') {
      return dashboardData.currentWeekPurchaseAmountTotal;
    }
    return 0;
  }

  double getOverViewAmount(InvoiceType invoiceType) {
    if (overViewSelectOption.value == 'This Year') {
      return dashboardData.currentYearVolume[invoiceType] ?? 0;
    } else if (overViewSelectOption.value == 'Previous Year') {
      return dashboardData.previousYearVolume[invoiceType] ?? 0;
    } else if (overViewSelectOption.value == 'This Month') {
      return dashboardData.currentMonthVolume[invoiceType] ?? 0;
    } else if (overViewSelectOption.value == 'This Week') {
      return dashboardData.currentWeekVolume[invoiceType] ?? 0;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final List<FlSpot> salesData = _getSalesData();
    final List<FlSpot> purchaseData = _getPurchaseData();
    final companyBloc = context.watch<CompanyBloc>();
    final company = companyBloc.currentCompany;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBarMore(
          titleWidget: BlocBuilder<CompanyBloc, CompanyState>(
            builder: (context, state) {
              return TextButton(
                onPressed: () {
                  commonBottomSheet(context,
                      child: SelectBusinessScreen(
                        companyModel: state.company,
                      ));
                },
                child: Row(
                  children: [
                    Text(
                      company?.companyName ?? 'No Company',
                      style: AppTextStyle.pw600.copyWith(
                        color: AppColor.black,
                        fontSize: 16.px,
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down_outlined),
                  ],
                ),
              );
            },
          ),
          onCompany: () {},
          arrow: false,
          showBackButton: true,
          onBack: () {
            GoRouter.of(context).go(AppRoutes.dashboardView.path);
          },
          // title: 'Shai Enterprises',
          child: Padding(
            padding: EdgeInsets.only(right: 5.w),
            // child: CustomImageView(
            //   width: 60.px,
            //   height: 24.px,
            //   fit: BoxFit.cover,
            //   imagePath: ImageConstants.splashLogo,
            // ),
          ),
        ),
        floatingActionButton: CustomFloatingButton(
          tag: 'create-invoice',
          title: 'Create Invoice',
          imagePath: ImageConstants.createInvoiceIcon,
          onTap: () {
            createInvoiceBottomSheet(context);
          },
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              BannerSlider(imageList: imageList),
              SizedBox(
                height: 2.h,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Statistics',
                      style: AppTextStyle.pw600
                          .copyWith(fontSize: 16.px, color: AppColor.black),
                    ),
                    Container(
                      // width: 140.px,
                      height: 30.px,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          boxShadow: [
                            const BoxShadow(
                                color: Colors.black54,
                                spreadRadius: 0.5,
                                offset: Offset(1, 1))
                          ],
                          borderRadius: BorderRadius.circular(5.px),
                          border: Border.all(color: AppColor.grey)),
                      child: GestureDetector(
                        onTap: () {
                          commonBottomSheet(context,
                              child: SelectOptionWidget(onClickItem: (data) {
                            staticSelectOption.value = data;
                            RouterHelper.pop<void>(context);
                          }));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                                valueListenable: staticSelectOption,
                                builder: (context, value, child) {
                                  return Text(staticSelectOption.value,
                                      style: AppTextStyle.pw500.copyWith(
                                          color: AppColor.darkGrey,
                                          fontSize: 12.px));
                                }),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor.grey,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2.h,
              ),
              Container(
                height: 200,
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false)),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20000,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${(value / 1000).toInt()}K',
                              style: const TextStyle(
                                  fontSize: 12, color: Colors.black),
                            );
                          },
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (staticSelectOption.value == 'This Year' ||
                                staticSelectOption.value == 'Previous Year') {
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
                            } else if (staticSelectOption.value ==
                                'This Week') {
                              const days = [
                                'Mon',
                                'Tue',
                                'Wed',
                                'Thu',
                                'Fri',
                                'Sat',
                                'Sun'
                              ];
                              return Text(
                                days[value.toInt()],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.black,
                                ),
                              );
                            } else {
                              return Text(
                                value.toInt().toString(),
                                style: const TextStyle(
                                  fontSize: 8,
                                  color: Colors.black,
                                ),
                              );
                            }
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
                          spots: salesData,
                          isCurved: true,
                          color: AppColor.appColor),
                      LineChartBarData(
                          spots: purchaseData,
                          isCurved: true,
                          color: AppColor.red),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 2.h),
              Container(
                height: 60.px,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 5.w),
                padding: EdgeInsets.symmetric(vertical: 1.h),
                decoration: BoxDecoration(
                  color: AppColor.greyContainer,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    summaryCard(
                      title: 'Sales',
                      amount: '₹ ${getSalesAmount()}',
                      color: Colors.blue,
                    ),
                    Container(
                      width: 1,
                      height: 60, // adjust this height as needed
                      color: Colors.grey,
                    ),
                    summaryCard(
                      title: 'Purchase',
                      amount: '₹ ${getPurchaseAmount()}',
                      color: Colors.red,
                    ),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Divider(
                thickness: 3.px,
                color: AppColor.greyContainer,
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  children: [
                    CustomImageView(
                      width: 4.w,
                      imagePath: ImageConstants.vectorIcon,
                    ),
                    SizedBox(
                      width: 2.w,
                    ),
                    Text('Quick Create',
                        style: AppTextStyle.pw600
                            .copyWith(color: AppColor.darkGrey)),
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  quickCreateWidget(
                    imagePath: ImageConstants.salesInvoiceIcon,
                    label: 'Sales\nInvoice',
                    onTap: () {
                      RouterHelper.push(
                        context,
                        AppRoutes.createSalesInvoice.name,
                        extra: {
                          'type': InvoiceType.sales,
                        },
                      );
                    },
                  ),
                  quickCreateWidget(
                    imagePath: ImageConstants.newCustomerIcon,
                    label: 'New\nCustomer',
                    onTap: () {
                      RouterHelper.push(context, AppRoutes.addParty.name);
                    },
                  ),
                  quickCreateWidget(
                    imagePath: ImageConstants.newItemIcon,
                    label: 'New\nItem',
                    onTap: () {
                      RouterHelper.push(context, AppRoutes.addEditItem.name);
                    },
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Divider(
                thickness: 3.px,
                color: AppColor.greyContainer,
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'OverView',
                      style: AppTextStyle.pw600
                          .copyWith(fontSize: 16.px, color: AppColor.black),
                    ),
                    Container(
                      height: 30.px,
                      padding: EdgeInsets.symmetric(horizontal: 3.w),
                      decoration: BoxDecoration(
                        color: AppColor.white,
                        boxShadow: [
                          const BoxShadow(
                              color: Colors.black54,
                              spreadRadius: 0.5,
                              offset: Offset(1, 1))
                        ],
                        borderRadius: BorderRadius.circular(10.px),
                        border: Border.all(
                          color: AppColor.grey,
                        ),
                      ),
                      child: GestureDetector(
                        onTap: () {
                          commonBottomSheet(
                            context,
                            child: SelectOptionWidget(
                              onClickItem: (data) {
                                overViewSelectOption.value = data;
                                RouterHelper.pop<void>(context);
                              },
                            ),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ValueListenableBuilder(
                              valueListenable: overViewSelectOption,
                              builder: (context, value, child) {
                                return Text(
                                  overViewSelectOption.value,
                                  style: AppTextStyle.pw500.copyWith(
                                    color: AppColor.darkGrey,
                                    fontSize: 12.px,
                                  ),
                                );
                              },
                            ),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColor.grey,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              OverviewItemWidget(
                value: '${getOverViewAmount(InvoiceType.receipt)}',
                title: 'Receipt',
                image: ImageConstants.receiptIcon,
              ),
              SizedBox(height: 2.h),
              OverviewItemWidget(
                value: '${getOverViewAmount(InvoiceType.payment)}',
                title: 'Payment',
                image: ImageConstants.paymentIcon,
              ),
              SizedBox(height: 2.h),
              OverviewItemWidget(
                value: '${getOverViewAmount(InvoiceType.sales)}',
                title: 'Sales',
                image: ImageConstants.salesIcon,
              ),
              SizedBox(height: 2.h),
              OverviewItemWidget(
                value: '${getOverViewAmount(InvoiceType.purchase)}',
                title: 'Purchase',
                image: ImageConstants.purchaseIcon,
              ),
              SizedBox(height: 2.h),
              OverviewItemWidget(
                value: '${getOverViewAmount(InvoiceType.creditNote)}',
                title: 'Credit Note',
                image: ImageConstants.creditNoteIcon,
              ),
              SizedBox(height: 2.h),
              OverviewItemWidget(
                value: '${getOverViewAmount(InvoiceType.debitNote)}',
                title: 'Debit Note',
                image: ImageConstants.debitNoteIcon,
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget quickCreateWidget({
    required String label,
    String? imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 100.px,
            padding: EdgeInsets.all(5.w),
            decoration: BoxDecoration(
              color: AppColor.lightAppColor,
              borderRadius: BorderRadius.circular(20.px),
            ),
            child: Image.asset(
              imagePath!,
              height: 40,
              width: 40,
            ),
          ),
          SizedBox(height: 1.h),
          Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyle.pw500.copyWith(
              color: AppColor.black,
              fontSize: 14.px,
            ),
          ),
        ],
      ),
    );
  }

  Widget summaryCard({
    required final String title,
    required final String amount,
    required final Color color,
  }) {
    return Row(
      children: [
        Container(
          height: 32.px,
          width: 4.px,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(20.px)),
        ),
        SizedBox(
          width: 2.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              amount,
              style: AppTextStyle.pw700
                  .copyWith(color: AppColor.darkGrey, fontSize: 14.px),
            ),
            Text(
              title,
              style: AppTextStyle.pw400
                  .copyWith(color: AppColor.grey, fontSize: 14.px),
            ),
          ],
        ),
      ],
    );
  }

  void createInvoiceBottomSheet(BuildContext context) {
    commonBottomSheet(context,
        child: Container(
          decoration: const BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 2.h,
              ),
              const Text(
                'Create Invoice',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 210.px,
                width: MediaQuery.of(context).size.width,
                child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: listInvoice.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          RouterHelper.pop<void>(context);
                          RouterHelper.push(
                            context,
                            listInvoice[index].path,
                            extra: {
                              'type': listInvoice[index].invoiceType,
                            },
                          );
                        },
                        child: Column(
                          children: [
                            Container(
                              height: 55.px,
                              width: 55.px,
                              decoration: const BoxDecoration(
                                  color: Color(0XFFEAF9EA),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: CustomImageView(
                                  imagePath: listInvoice[index].image,
                                  height: 28.px,
                                  width: 28.px,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ),
                            Text(
                              listInvoice[index].title,
                              style: AppTextStyle.pw500.copyWith(
                                  color: AppColor.darkGrey, fontSize: 12.px),
                            )
                          ],
                        ),
                      );
                    }),
              ),
              SizedBox(
                height: 2.h,
              ),
            ],
          ),
        ));
  }
}

class Invoice {
  String image;
  String path;
  String title;
  InvoiceType invoiceType;

  Invoice({
    required this.image,
    required this.path,
    required this.title,
    required this.invoiceType,
  });
}
