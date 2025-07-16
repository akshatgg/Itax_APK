// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/loan/business_calc_ctrl.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class BusinessCalcView extends StatefulWidget {
  const BusinessCalcView({super.key});

  @override
  _BusinessCalcViewState createState() => _BusinessCalcViewState();
}

class _BusinessCalcViewState extends State<BusinessCalcView> {
  final TextEditingController loanCtrl = TextEditingController();
  final TextEditingController rateCtrl = TextEditingController();
  final TextEditingController timeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPreviousResult();
  }

  Future<void> _loadPreviousResult() async {
    final model = await BusinessLoanController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  Future<void> _onCalculate() async {
    if (loanCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final principal = double.tryParse(loanCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = BusinessLoanController.calculate(
      amount: principal,
      rate: rate,
      time: time,
    );

    await BusinessLoanController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  Future<void> _onClear() async {
    loanCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await BusinessLoanController.clear();
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
        title: 'Business Loan Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {}, // Add download logic
        onShare: () {}, // Add share logic
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 8,
                children: [
                  const Text(' Loan Amount', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    controller: loanCtrl,
                    hintText: 'Enter amount',
                    rightText: '₹',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  const Text(' Rate of Interest (P.A)',
                      style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    controller: rateCtrl,
                    hintText: 'Enter interest rate',
                    rightText: '%',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 12),
                  const Text(' Time Period', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    controller: timeCtrl,
                    hintText: 'Enter time in years',
                    rightText: 'Y',
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  if (model != null) ...[
                    ResultChart(
                      dataEntries: [
                        ChartData(
                          value: model.amount,
                          color: AppColor.secondary,
                          label: 'Loan Amount',
                        ),
                        ChartData(
                          value: model.result2 ?? 0.0,
                          color: AppColor.primary,
                          label: 'Interest Amount',
                        ),
                      ],
                      summaryRows: [
                        SummaryRowData(
                          label: 'Loan Amount',
                          value: model.amount,
                        ),
                        SummaryRowData(
                          label: 'EMI',
                          value: model.result1 ?? 0.0,
                        ),
                        SummaryRowData(
                          label: 'Interest Amount',
                          value: model.result2 ?? 0.0,
                        ),
                        SummaryRowData(
                          label: 'Total Amount Payable',
                          value: model.result3 ?? 0.0,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 80 + MediaQuery.of(context).padding.bottom,
                    ),
                  ],
                ],
              ),
            ),
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
}
