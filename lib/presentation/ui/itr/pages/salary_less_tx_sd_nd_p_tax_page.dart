import 'package:flutter/material.dart';

import '../widgets/amount_input_field.dart';
import '../widgets/gradient_app_bar.dart';

class SalaryLessSDPTaxPage extends StatefulWidget {
  const SalaryLessSDPTaxPage({super.key});

  @override
  State<SalaryLessSDPTaxPage> createState() => _SalaryLessSDPTaxPageState();
}

class _SalaryLessSDPTaxPageState extends State<SalaryLessSDPTaxPage> {
  final TextEditingController basicDAController = TextEditingController();
  final TextEditingController hraController = TextEditingController();
  final TextEditingController bonusController = TextEditingController();
  final TextEditingController otherController = TextEditingController();

  bool isBasicMonthly = true;
  bool isHRAMonthly = true;
  bool isBonusMonthly = true;
  bool isOtherMonthly = true;

  double totalSalary = 0.0;

  @override
  void initState() {
    super.initState();
    // Add listeners to update total when text changes
    basicDAController.addListener(_updateTotal);
    hraController.addListener(_updateTotal);
    bonusController.addListener(_updateTotal);
    otherController.addListener(_updateTotal);
  }

  @override
  void dispose() {
    basicDAController.dispose();
    hraController.dispose();
    bonusController.dispose();
    otherController.dispose();
    super.dispose();
  }

  void _updateTotal() {
    setState(() {
      totalSalary = _calculateTotalSalary();
    });
  }

  double _calculateTotalSalary() {
    double parse(String value) => double.tryParse(value) ?? 0.0;

    final double basic = isBasicMonthly
        ? parse(basicDAController.text) * 12
        : parse(basicDAController.text);
    final double hra = isHRAMonthly
        ? parse(hraController.text) * 12
        : parse(hraController.text);
    final double bonus = isBonusMonthly
        ? parse(bonusController.text) * 12
        : parse(bonusController.text);
    final double other = isOtherMonthly
        ? parse(otherController.text) * 12
        : parse(otherController.text);

    return basic + hra + bonus + other;
  }

  void _toggleAndRecalculate(String field, bool value) {
    setState(() {
      switch (field) {
        case 'basic':
          isBasicMonthly = value;
          break;
        case 'hra':
          isHRAMonthly = value;
          break;
        case 'bonus':
          isBonusMonthly = value;
          break;
        case 'other':
          isOtherMonthly = value;
          break;
      }
      totalSalary = _calculateTotalSalary();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: GradientAppBar(
        title: 'Salary Less SD & P Tax',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              AmountInputField(
                label: 'Basic + DA (Dearness Allowance)',
                controller: basicDAController,
                isMonthly: isBasicMonthly,
                onToggle: (val) => _toggleAndRecalculate('basic', val),
              ),
              AmountInputField(
                label: 'HRA (House Rent Allowance)',
                controller: hraController,
                isMonthly: isHRAMonthly,
                onToggle: (val) => _toggleAndRecalculate('hra', val),
              ),
              AmountInputField(
                label: 'Bonus Commission',
                controller: bonusController,
                isMonthly: isBonusMonthly,
                onToggle: (val) => _toggleAndRecalculate('bonus', val),
              ),
              AmountInputField(
                label: 'Other Allowance',
                controller: otherController,
                isMonthly: isOtherMonthly,
                onToggle: (val) => _toggleAndRecalculate('other', val),
              ),
              const SizedBox(height: 80),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Total = ₹ ${totalSalary.toStringAsFixed(2)}',
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Save logic here
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
