// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/loan/personal_calc_ctrl.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class PersonalCalcView extends StatefulWidget {
  const PersonalCalcView({super.key});

  @override
  _PersonalCalcViewState createState() => _PersonalCalcViewState();
}

class _PersonalCalcViewState extends State<PersonalCalcView> {
  final loanCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await PersonalLoanCtrl.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
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

    final result = PersonalLoanCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await PersonalLoanCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    loanCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await PersonalLoanCtrl.clear();
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
        title: 'Personal Loan Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
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
                  const Text(
                    ' Rate of Interest (P.A)',
                    style: AppTextStyle.body16,
                  ),
                  CustomTextFieldCalculator(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: '%',
                  ),
                  const SizedBox(height: 8),
                  const Text(' Loan Tenure', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Years',
                    controller: timeCtrl,
                    rightText: 'Y',
                  ),
                  const SizedBox(height: 8),
                  // Optional: You can add dropdown or radio buttons to change timeType if needed
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (model != null)
              ResultChart(
                dataEntries: [
                  ChartData(
                    value: model.amount,
                    color: AppColor.secondary,
                    label: 'Loan Amount',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0, // Interest Amount
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
              )
            else
              SizedBox(height: 80 + MediaQuery.of(context).padding.bottom),
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
