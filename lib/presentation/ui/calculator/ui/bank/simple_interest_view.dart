// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/bank_ctrls/simple_interest_controller.dart';
import '../../providers/base_calculator_provider.dart';
import '../../services/export_helper.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_dropdown_calculator.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/export_result_ui.dart';
import '../../widgets/result_chart.dart';

class SimpleInterestView extends StatefulWidget {
  const SimpleInterestView({super.key});

  @override
  _SimpleInterestViewState createState() => _SimpleInterestViewState();
}

class _SimpleInterestViewState extends State<SimpleInterestView> {
  final principalCtrl = TextEditingController();
  final rateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();
  String timeType = 'Yearly';
  final GlobalKey exportKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await SimpleInterestCtrl.load();
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

    final result = SimpleInterestCtrl.calculate(
      amount: principal,
      rate: rate,
      time: time,
      timeType: timeType,
    );

    await SimpleInterestCtrl.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    principalCtrl.clear();
    rateCtrl.clear();
    timeCtrl.clear();
    await SimpleInterestCtrl.clear();
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
        title: 'Simple Interest Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () async {
          await ExportHelper.exportAsImage(
            exportKey,
            'Simple interest calculator',
          );
          showDialog<void>(
            context: context,
            builder: (_) => Dialog(
              child: result(), // Use your result() widget here
            ),
          );
        },
        onShare: () {},
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        spacing: 8,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            ' Principal Amount',
                            style: AppTextStyle.body16,
                          ),
                          CustomTextFieldCalculator(
                            hintText: 'Amount',
                            controller: principalCtrl,
                            rightText: '₹',
                          ),
                          const SizedBox(height: 2),
                          const Text(
                            ' Rate of Interest(P.A)',
                            style: AppTextStyle.body16,
                          ),
                          CustomTextFieldCalculator(
                            hintText: 'Interest Rate',
                            controller: rateCtrl,
                            rightText: '%',
                          ),
                          SizedBox(height: 2),
                          Text(' Time Period', style: AppTextStyle.body16),
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: CustomTextFieldCalculator(
                                  hintText: 'Time',
                                  controller: timeCtrl,
                                ),
                              ),
                              Spacer(),
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
                      SizedBox(height: 80),
                  ],
                ),
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

  Widget result() {
    final model = context.read<BaseCalculatorProvider>().model;

    return RepaintBoundary(
      key: exportKey,
      child: ExportResultUI(
        title: 'Simple Interest Result',
        inputData: {
          'Principal Amount': principalCtrl.text,
          'Rate of Interest (P.A)': rateCtrl.text,
          'Time Period': timeCtrl.text,
          'Time Type': timeType,
        },
        chartData: {
          'Principal Amount': double.tryParse(principalCtrl.text) ?? 0.0,
          'Interest Amount': model?.result1 ?? 0.0,
        },
        resultData: {
          'Interest Amount': (model?.result1 ?? 0.0).toStringAsFixed(2),
          'Total Amount': (model != null
              ? (model.amount + (model.result1 ?? 0.0)).toStringAsFixed(2)
              : '0.00'),
        },
      ),
    ); // ✅ Your actual home screen
  }
}
