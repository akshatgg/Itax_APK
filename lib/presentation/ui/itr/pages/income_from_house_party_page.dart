import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../widgets/amount_input_field.dart';
import '../widgets/gradient_app_bar.dart'; // ✅ Import here

class IncomeFromHousePropertyPage extends StatefulWidget {
  const IncomeFromHousePropertyPage({super.key});

  @override
  State<IncomeFromHousePropertyPage> createState() =>
      _IncomeFromHousePropertyPageState();
}

class _IncomeFromHousePropertyPageState
    extends State<IncomeFromHousePropertyPage> {
  final loanController = TextEditingController();
  final annualValueController = TextEditingController();
  final municipalTaxController = TextEditingController();
  final unrealizedRentController = TextEditingController();
  final deductionController = TextEditingController();

  bool isLoanMonthly = true;
  bool isAnnualValueMonthly = true;
  bool isMunicipalMonthly = true;
  bool isUnrealizedMonthly = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Income from House Property',
        onBack: () => Navigator.pop(context),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AmountInputField(
                label: 'Interest Paid/Payable on Housing Loan',
                controller: loanController,
                isMonthly: isLoanMonthly,
                onToggle: (val) => setState(() => isLoanMonthly = val),
              ),
              const SizedBox(height: 10),
              Text('Income from Let-out Property',
                  style: TextStyle(
                      fontSize: 13.5.sp, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              AmountInputField(
                label: '1. Annual Letable Value/ Rent Received or Receivable',
                controller: annualValueController,
                isMonthly: isAnnualValueMonthly,
                onToggle: (val) => setState(() => isAnnualValueMonthly = val),
              ),
              AmountInputField(
                label: '2. Less Municipal Taxes Paid during the year',
                controller: municipalTaxController,
                isMonthly: isMunicipalMonthly,
                onToggle: (val) => setState(() => isMunicipalMonthly = val),
              ),
              AmountInputField(
                label: '3. Less Unrealized Rent',
                controller: unrealizedRentController,
                isMonthly: isUnrealizedMonthly,
                onToggle: (val) => setState(() => isUnrealizedMonthly = val),
              ),
              const SizedBox(height: 10),
              AmountInputField(
                label: '4. Net Annual Value (1 - (2 + 3))',
                controller: unrealizedRentController,
                isMonthly: isUnrealizedMonthly,
                onToggle: (val) => setState(() => isUnrealizedMonthly = val),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 12.0),
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Less Deduction from Net Annual Value',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        '!Standard Deduction @30% of Net',
                        style: TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 8.0),
                    ],
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
