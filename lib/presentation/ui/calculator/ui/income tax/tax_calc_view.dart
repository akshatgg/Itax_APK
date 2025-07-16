// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, non_constant_identifier_names

//pendding

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/income_tax_ctrls/HRA_ctrlr.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_dropdown_calculator.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class TaxtCalcView extends StatefulWidget {
  const TaxtCalcView({super.key});

  @override
  _TaxtCalcViewState createState() => _TaxtCalcViewState();
}

class _TaxtCalcViewState extends State<TaxtCalcView> {
  final totalInvstCtrl = TextEditingController();
  final HRA_ReceivedCtrl = TextEditingController();
  final DearnessCtrl = TextEditingController();
  final totalRentCtrl = TextEditingController();

  String timeType = 'Yearly';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await HRAController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (totalInvstCtrl.text.isEmpty ||
        HRA_ReceivedCtrl.text.isEmpty ||
        DearnessCtrl.text.isEmpty ||
        totalRentCtrl.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final totalInvestment = double.tryParse(totalInvstCtrl.text) ?? 0;
    final hraReceived = double.tryParse(HRA_ReceivedCtrl.text) ?? 0;
    final dearnessAllowance = double.tryParse(DearnessCtrl.text) ?? 0;
    final totalRentPaid = double.tryParse(totalRentCtrl.text) ?? 0;

    // Perform HRA calculation
    final hraExempted = HRAController.calculate(
      timeType: timeType,
      amount: totalInvestment,
      hraReceived: hraReceived,
      da: dearnessAllowance,
      rentPaid: totalRentPaid,
    );

    await HRAController.save(hraExempted);
    context.read<BaseCalculatorProvider>().setModel(hraExempted);
  }

  void _onClear() async {
    totalInvstCtrl.clear();
    HRA_ReceivedCtrl.clear();
    DearnessCtrl.clear();
    totalRentCtrl.clear();
    await HRAController.clear();
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
        title: 'Tax Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('PAN NO.', style: AppTextStyle.body16),
                      CustomTextFieldCalculator(
                        hintText: 'Amount in Rupees',
                        controller: totalInvstCtrl,
                        // rightText: '₹',
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 8),
                      const Text('Tax Payer', style: AppTextStyle.body16),
                      CustomDropdownCalculator(
                        initialValue: 'Select',
                        items: [
                          'Salaried',
                          'Self-employed',
                          'Other',
                        ], // ✅ Avoid empty list
                        onChanged: (String value) {},
                      ),
                      const SizedBox(height: 8),
                      const Text('Dearness Allowance',
                          style: AppTextStyle.body16),
                      CustomTextFieldCalculator(
                        hintText: 'Amount in Rupees',
                        controller: DearnessCtrl,
                        // rightText: '₹',
                      ),
                      const SizedBox(height: 8),
                      const Text('Total Rent Paid', style: AppTextStyle.body16),
                      CustomTextFieldCalculator(
                        hintText: 'Amount in Rupees',
                        controller: totalRentCtrl,
                        // rightText: '₹',
                      ),
                      const SizedBox(height: 20),
                      if (model != null)
                        ResultChart(
                          dataEntries: [
                            ChartData(
                              value: model.result1 ?? 0.0,
                              color: AppColor.primary,
                              label: 'HRA Exempted',
                            ),
                            ChartData(
                              value: model.result2 ?? 0.0,
                              color: AppColor.secondary,
                              label: 'HRA Taxable',
                            ),
                          ],
                          summaryRows: [
                            SummaryRowData(label: 'HRA', value: model.rate),
                            SummaryRowData(
                              label: 'Exemption',
                              value: model.result1 ?? 0.0,
                            ),
                            SummaryRowData(
                              label: '50 % Basic',
                              value: model.result3 ?? 0.0,
                            ),
                            SummaryRowData(
                              label: 'Salary',
                              value: model.result4 ?? 0.0,
                            ),
                          ],
                        )
                      else
                        SizedBox(
                            height: 80 + MediaQuery.of(context).padding.bottom),
                    ]),
              ),
            ],
          ),
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
