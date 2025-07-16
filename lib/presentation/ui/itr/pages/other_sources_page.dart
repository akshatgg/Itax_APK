import 'package:flutter/material.dart';

import '../widgets/amount_input_field.dart';
import '../widgets/custom_bottom_nav_itr.dart';
import '../widgets/gradient_app_bar.dart';

class OtherSourcesPage extends StatefulWidget {
  const OtherSourcesPage({super.key});

  @override
  State<OtherSourcesPage> createState() => _OtherSourcesPageState();
}

class _OtherSourcesPageState extends State<OtherSourcesPage> {
  final fdInterestController = TextEditingController();
  final sbInterestController = TextEditingController();
  final otherSourceController = TextEditingController();

  bool isFdMonthly = false;
  bool isSbMonthly = false;
  bool isOtherMonthly = false;

  @override
  void dispose() {
    fdInterestController.dispose();
    sbInterestController.dispose();
    otherSourceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Other Sources',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            AmountInputField(
              label: 'Interest from Fixed Deposit',
              controller: fdInterestController,
              isMonthly: isFdMonthly,
              onToggle: (val) => setState(() => isFdMonthly = val),
            ),
            AmountInputField(
              label: 'Interest from Saving Bank Account',
              controller: sbInterestController,
              isMonthly: isSbMonthly,
              onToggle: (val) => setState(() => isSbMonthly = val),
            ),
            AmountInputField(
              label: 'Other Sources',
              controller: otherSourceController,
              isMonthly: isOtherMonthly,
              onToggle: (val) => setState(() => isOtherMonthly = val),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Save logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
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
      bottomNavigationBar: SafeArea(
        child: CustomBottomNavBarItr(
          currentIndex: 0,
          onItemSelected: (index) {
            // Handle bottom nav item if needed
          },
        ),
      ),
    );
  }
}
