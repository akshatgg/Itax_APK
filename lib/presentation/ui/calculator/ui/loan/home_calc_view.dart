// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/loan/home_calc_ctrl.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class HomeCalcView extends StatefulWidget {
  const HomeCalcView({super.key});

  @override
  _HomeCalcViewState createState() => _HomeCalcViewState();
}

class _HomeCalcViewState extends State<HomeCalcView> {
  final loanCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await HomeLoanCtrl.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);

      // Populate text fields with saved values
      loanCtrl.text = model.amount.toStringAsFixed(2);
      rateCtrl.text = model.rate.toStringAsFixed(2);
      timeCtrl.text = model.time.toStringAsFixed(2);
    }
  }

  void _onCalculate() async {
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

    final result = HomeLoanCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: 'Yearly', // fixed since controller uses years
    );

    await HomeLoanCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    loanCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await HomeLoanCtrl.clear();
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
        title: 'Home Loan Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                spacing: 8,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(' Loan Amount', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Amount',
                    controller: loanCtrl,
                    rightText: '₹',
                  ),
                  const SizedBox(height: 8),
                  const Text(' Rate of Interest (P.A)',
                      style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: '%',
                  ),
                  const SizedBox(height: 8),
                  const Text(' Loan Tenure (Years)',
                      style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Years',
                    controller: timeCtrl,
                    rightText: 'Y',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            model == null
                ? SizedBox(height: 80 + MediaQuery.of(context).padding.bottom)
                : ResultChart(
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
                      SummaryRowData(label: 'Loan Amount', value: model.amount),
                      SummaryRowData(label: 'EMI', value: model.result1 ?? 0.0),
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
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: ClearCalculateButtons(
          onCalculatePressed: _onCalculate,
          onClearPressed: _onClear,
        ),
      ),
    );
  }
}
