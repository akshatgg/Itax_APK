// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';
import '../../controller/income_tax_ctrls/capital_gain_ctrl.dart';
import '../../providers/base_calculator_provider.dart';
import '../../widgets/clear_calculate_buttons.dart';
import '../../widgets/custom_app_bar_calc.dart';
import '../../widgets/custom_text_field_calc.dart';
import '../../widgets/result_chart.dart';

class CapitalGainCalcView extends StatefulWidget {
  const CapitalGainCalcView({super.key});

  @override
  _CapitalGainCalcViewState createState() => _CapitalGainCalcViewState();
}

class _CapitalGainCalcViewState extends State<CapitalGainCalcView> {
  final purchaseCtrl = TextEditingController();
  final saleCtrl = TextEditingController();
  final capitalGainCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadResult();
  }

  Future<void> _loadResult() async {
    final model = await CapitalGainController.load();
    if (model != null) {
      context.read<BaseCalculatorProvider>().setModel(model);
      purchaseCtrl.text = model.amount.toStringAsFixed(2);
      saleCtrl.text = model.rate.toStringAsFixed(2);
      capitalGainCtrl.text = model.result1?.toStringAsFixed(2) ?? '';
    }
  }

  void _onCalculate() async {
    final purchase = double.tryParse(purchaseCtrl.text);
    final sale = double.tryParse(saleCtrl.text);

    if (purchase == null || sale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter valid numeric values')),
      );
      return;
    }

    final model = CapitalGainController.calculate(
      purchasePrice: purchase,
      salePrice: sale,
    );

    capitalGainCtrl.text = model.result1?.toStringAsFixed(2) ?? '';

    context.read<BaseCalculatorProvider>().setModel(model);
    await CapitalGainController.save(model);
  }

  void _onClear() async {
    purchaseCtrl.clear();
    saleCtrl.clear();
    capitalGainCtrl.clear();
    await CapitalGainController.clear();
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
        title: 'Capital Gain Calculator',
        onBack: () => Navigator.pop(context),
        onDownload: () {},
        onShare: () {},
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  spacing: 6,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(' Purchase Price', style: AppTextStyle.body16),
                    CustomTextFieldCalculator(
                      hintText: 'Amount in Rupees',
                      controller: purchaseCtrl,
                      // rightText: '₹',
                    ),
                    const SizedBox(height: 12),
                    const Text(' Sale Price', style: AppTextStyle.body16),
                    CustomTextFieldCalculator(
                      hintText: 'Sale Rate in Rupees',
                      controller: saleCtrl,
                      // rightText: '₹',
                    ),
                    const SizedBox(height: 12),
                    const Text(' Capital Gain', style: AppTextStyle.body16),
                    CustomTextFieldCalculator(
                      hintText: 'Gain in Rupees',
                      controller: capitalGainCtrl,
                      // rightText: '₹',
                    ),
                    const SizedBox(height: 20),
                    (model != null)
                        ? ResultChart(
                            dataEntries: [
                              ChartData(
                                value: model.amount,
                                color: AppColor.secondary,
                                label: 'Purchase Price',
                              ),
                              ChartData(
                                value: model.result1 ?? 0.0,
                                color: AppColor.primary,
                                label: 'Capital Gain',
                              ),
                            ],
                            summaryRows: [
                              SummaryRowData(
                                label: 'Purchase Price',
                                value: model.amount,
                              ),
                              SummaryRowData(
                                label: 'Capital Gain',
                                value: model.result1 ?? 0.0,
                              ),
                              SummaryRowData(
                                label: 'Sale Price',
                                value: model.rate,
                              ),
                            ],
                          )
                        : SizedBox(
                            height: 80 + MediaQuery.of(context).padding.bottom,
                          ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
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
