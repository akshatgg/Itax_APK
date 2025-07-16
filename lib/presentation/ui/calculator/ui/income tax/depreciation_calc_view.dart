// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/income_tax_ctrls/depreciation_ctrl.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class DepreciationCalcView extends StatefulWidget {
  const DepreciationCalcView({super.key});

  @override
  _DepreciationCalcViewState createState() => _DepreciationCalcViewState();
}

class _DepreciationCalcViewState extends State<DepreciationCalcView> {
  final PPriceCtrl = TextEditingController();
  final scrapValueCtrl = TextEditingController();
  final usefulLifeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await DepreciationController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (PPriceCtrl.text.isEmpty ||
        scrapValueCtrl.text.isEmpty ||
        usefulLifeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final principal = double.tryParse(PPriceCtrl.text) ?? 0;
    final scrapValue =
        double.tryParse(scrapValueCtrl.text) ?? 0; // Fixed variable name
    final usefulLife =
        double.tryParse(usefulLifeCtrl.text) ?? 0; // Added useful life parsing

    // Perform depreciation calculation
    final result = DepreciationController.calculate(
      purchasePrice: principal,
      scrapValue: scrapValue,
      usefulLife: usefulLife,
    );

    await DepreciationController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    PPriceCtrl.clear();
    scrapValueCtrl.clear();
    usefulLifeCtrl.clear();

    await DepreciationController.clear();
    context.read<BaseCalculatorProvider>().clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fields cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BaseCalculatorProvider>().model;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColor.white,
      appBar: CustomAppBarCalculator(
        title: 'Depreciation Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          spacing: 6,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Input Fields
            const SizedBox(height: 8),
            const Text(' Purchase Price', style: AppTextStyle.body16),
            CustomTextFieldCalculator(
              hintText: 'Amount in Rupees',
              controller: PPriceCtrl,
              // rightText: '₹',
            ),
            const SizedBox(height: 8),
            const Text(' Scrap Value', style: AppTextStyle.body16),
            CustomTextFieldCalculator(
              hintText: 'Value in Percentage',
              controller: scrapValueCtrl,
              // rightText: '%',
            ),
            const SizedBox(height: 8),
            const Text(' Estimated Useful Life', style: AppTextStyle.body16),
            CustomTextFieldCalculator(
              hintText: 'Years',
              controller: usefulLifeCtrl,
              // rightText: 'Y',
            ),
            const SizedBox(height: 20),

            /// Output Section (Chart + Table)
            if (model != null)
              Column(
                children: [
                  ResultChart(
                    dataEntries: [
                      ChartData(
                        value: model.amount,
                        color: AppColor.secondary,
                        label: 'Cost of Asset',
                      ),
                      ChartData(
                        value: model.result1 ?? 0.0,
                        color: AppColor.primary,
                        label: 'Depreciation (P.A)',
                      ),
                    ],
                    summaryRows: [
                      SummaryRowData(
                        label: 'Depreciation (P.A)',
                        value: model.result1 ?? 0.0,
                      ),
                      SummaryRowData(
                        label: 'Depreciation Percentage %',
                        value: model.result2 ?? 0.0,
                      ),
                      SummaryRowData(
                        label: 'Cost of Assets',
                        value: model.amount,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Text('Calculation', style: AppTextStyle.heading20),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border:
                          Border.all(color: AppColor.primary.withOpacity(0.3)),
                    ),
                    child: Table(
                      columnWidths: const {
                        0: FlexColumnWidth(1),
                        1: FlexColumnWidth(2),
                        2: FlexColumnWidth(2),
                        3: FlexColumnWidth(2),
                      },
                      border: TableBorder(
                        horizontalInside: BorderSide(
                            color: AppColor.primary.withOpacity(0.1), width: 1),
                      ),
                      children: [
                        // Header Row
                        TableRow(
                          decoration: BoxDecoration(
                            color: AppColor.primary.withOpacity(0.1),
                          ),
                          children: [
                            _tableCell('Year',
                                style: AppTextStyle.body16
                                    .copyWith(fontWeight: FontWeight.bold)),
                            _tableCell('Opening Value',
                                style: AppTextStyle.body16
                                    .copyWith(fontWeight: FontWeight.bold)),
                            _tableCell('Depreciation',
                                style: AppTextStyle.body16
                                    .copyWith(fontWeight: FontWeight.bold)),
                            _tableCell('Closing Value',
                                style: AppTextStyle.body16
                                    .copyWith(fontWeight: FontWeight.bold)),
                          ],
                        ),
                        // Data Rows
                        for (var row in model.table ?? [])
                          TableRow(
                            decoration: const BoxDecoration(
                              color: AppColor.white,
                            ),
                            children: [
                              _tableCell('${row[0]}',
                                  style: AppTextStyle.body16),
                              _tableCell((row[1] as num).toStringAsFixed(2),
                                  style: AppTextStyle.body16),
                              _tableCell((row[2] as num).toStringAsFixed(2),
                                  style: AppTextStyle.body16),
                              _tableCell((row[3] as num).toStringAsFixed(2),
                                  style: AppTextStyle.body16),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 100), // Leave space for bottom buttons
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: ClearCalculateButtons(
          onClearPressed: _onClear,
          onCalculatePressed: _onCalculate,
        ),
      ),
    );
  }

  Widget _tableCell(String text, {required TextStyle style}) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: style,
        ),
      );
}
