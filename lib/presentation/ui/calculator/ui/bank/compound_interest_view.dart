// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/bank_ctrls/compound_interest_controller.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_dropdown_calculator.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class CompoundInterestView extends StatefulWidget {
  const CompoundInterestView({super.key});

  @override
  _CompoundInterestViewState createState() => _CompoundInterestViewState();
}

class _CompoundInterestViewState extends State<CompoundInterestView> {
  final principalCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await CompoundInterestCtrl.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (principalCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final principal = double.tryParse(principalCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = CompoundInterestCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await CompoundInterestCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    principalCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await CompoundInterestCtrl.clear();
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
        title: 'Compound Interest Calculator',
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
                  const Text(' Principal Amount', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Amount',
                    controller: principalCtrl,
                    rightText: '₹',
                  ),
                  const SizedBox(height: 2),
                  const Text(' Rate of Interest(P.A)',
                      style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: '%',
                  ),
                  const SizedBox(height: 2),
                  const Text(' Time Period', style: AppTextStyle.body16),
                  Row(
                    children: [
                      SizedBox(
                        width: 150,
                        child: CustomTextFieldCalculator(
                          hintText: 'Time',
                          controller: timeCtrl,
                        ),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 126,
                        height: 52,
                        child: CustomDropdownCalculator(
                          height: 44,
                          items: ['Yearly', 'Monthly', 'Quarterly'],
                          initialValue: 'Yearly',
                          onChanged: (val) {
                            setState(() => timeType = val);
                          },
                        ),
                      ),
                    ],
                  ),
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
                    label: 'Principal Amount',
                  ),
                  ChartData(
                    value: model.result1 ?? 0.0,
                    color: AppColor.primary,
                    label: 'Interest Amount',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(
                    label: 'Principle Amount',
                    value: double.tryParse(principalCtrl.text) ?? 0.0,
                  ),
                  SummaryRowData(
                    label: 'Total Earned',
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: 'Total Amount',
                    value: (model.amount + (model.result1 ?? 0.0)),
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
