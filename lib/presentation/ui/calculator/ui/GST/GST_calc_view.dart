// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/GST/GST_calc_ctrl.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_dropdown_calculator.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class GSTcalcView extends StatefulWidget {
  const GSTcalcView({super.key});

  @override
  _GSTcalcViewState createState() => _GSTcalcViewState();
}

class _GSTcalcViewState extends State<GSTcalcView> {
  final amountCtrl = TextEditingController();
  String selectedGST = 'Select GST Type';
  String gstRate = 'Select GST Rate';

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await GSTController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
    }
  }

  void _onCalculate() async {
    if (amountCtrl.text.isEmpty ||
        gstRate == 'Select GST Rate' ||
        selectedGST == 'Select GST Type') {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final amount = double.tryParse(amountCtrl.text) ?? 0;
    final rate = double.tryParse(gstRate.replaceAll('%', '')) ?? 0;

    final result = GSTController.calculate(amount: amount, rate: rate);

    await GSTController.save(result);
    context.read<BaseCalculatorProvider>().setModel(result);
  }

  void _onClear() async {
    amountCtrl.clear();
    setState(() {
      gstRate = 'Select GST Rate';
      selectedGST = 'Select GST Type';
    });

    await GSTController.clear();
    context.read<BaseCalculatorProvider>().clear();

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Fields cleared')));
  }

  @override
  Widget build(BuildContext context) {
    final model = context.watch<BaseCalculatorProvider>().model;

    return Scaffold(
      backgroundColor: AppColor.white,
      appBar: CustomAppBarCalculator(
        title: 'GST Calculator',
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
                  const Text(' Amount', style: AppTextStyle.body16),
                  CustomTextFieldCalculator(
                    hintText: 'Enter amount in Rupees',
                    controller: amountCtrl,
                    // rightText: '₹',
                  ),
                  const SizedBox(height: 12),
                  const Text(' GST Type', style: AppTextStyle.body16),
                  CustomDropdownCalculator(
                    height: 52,
                    items: ['Regular', 'Composition'],
                    initialValue: selectedGST,
                    onChanged: (val) {
                      setState(() => selectedGST = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  const Text(' GST Rate (%)', style: AppTextStyle.body16),
                  CustomDropdownCalculator(
                    height: 52,
                    items: ['0%', '5%', '8%', '12%', '18%', '28%'],
                    initialValue: gstRate,
                    onChanged: (val) {
                      setState(() => gstRate = val);
                    },
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
                    label: 'Actual Amount',
                  ),
                  ChartData(
                    value: model.result1 ?? 0.0,
                    color: AppColor.primary,
                    label: 'GST Amount',
                  ),
                ],
                summaryRows: [
                  SummaryRowData(label: 'Actual Amount', value: model.amount),
                  SummaryRowData(
                    label: 'GST Amount',
                    value: model.result1 ?? 0.0,
                  ),
                  SummaryRowData(
                    label: 'Post GST Amount',
                    value: model.result2 ?? 0.0,
                  ),
                ],
              )
            else
              const SizedBox(height: 80),
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
