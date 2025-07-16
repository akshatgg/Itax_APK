// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/investment_ctrls/post_office_ctrls.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class PostOfficeMISView extends StatefulWidget {
  const PostOfficeMISView({super.key});

  @override
  _PostOfficeMISViewState createState() => _PostOfficeMISViewState();
}

class _PostOfficeMISViewState extends State<PostOfficeMISView> {
  final investmentCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await PostOfficeMISController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (investmentCtrl.text.isEmpty ||
        rateCtrl.text.isEmpty ||
        timeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final amount = double.tryParse(investmentCtrl.text) ?? 0;
    final rate = double.tryParse(rateCtrl.text) ?? 0;
    final time = double.tryParse(timeCtrl.text) ?? 0;

    final result = PostOfficeMISController.calculate(
      amount: amount,
      rate: rate,
      time: time,
    );

    await PostOfficeMISController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    investmentCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();

    await PostOfficeMISController.clear();
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
        title: 'Post Office (Monthly Income Schedule) Calculator',
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
                  const Text(' Investment Amount', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Amount',
                    controller: investmentCtrl,
                    rightText: '₹',
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    ' Expected return rate (P.A)',
                    style: AppTextStyle.body16,
                  ),
                  CustomTextFieldCalculator(
                    hintText: 'Interest Rate',
                    controller: rateCtrl,
                    rightText: '%',
                  ),
                  const SizedBox(height: 2),
                  const Text(' Time Period', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Years',
                    controller: timeCtrl,
                    rightText: 'Y',
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
                    label: 'Invested Amount',
                  ),
                  ChartData(
                    value: model.result2 ?? 0.0,
                    color: AppColor.primary,
                    label: 'Total Interest',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(
                    label: 'Monthly Interest',
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: 'Total Interest',
                    value: (model.result2 ?? 0.0),
                  ),
                  SummaryRowData(
                    label: 'Total Amount Payable',
                    value: (model.result3 ?? 0.0),
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
