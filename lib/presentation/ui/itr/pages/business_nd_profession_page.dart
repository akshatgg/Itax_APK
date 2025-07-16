import 'package:flutter/material.dart';

import '../widgets/amount_input_field.dart';
import '../widgets/custom_bottom_nav_itr.dart';
import '../widgets/gradient_app_bar.dart';

class BusinessNdProfessionPage extends StatefulWidget {
  const BusinessNdProfessionPage({super.key});

  @override
  State<BusinessNdProfessionPage> createState() =>
      _BusinessNdProfessionPageState();
}

class _BusinessNdProfessionPageState extends State<BusinessNdProfessionPage> {
  final fdInterestController = TextEditingController();
  final businessController = TextEditingController();

  bool isFdMonthly = false;
  bool businessMonthly = false;

  @override
  void dispose() {
    fdInterestController.dispose();
    businessController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Business & Profession',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            AmountInputField(
              label: 'Business',
              controller: businessController,
              isMonthly: businessMonthly,
              onToggle: (val) => setState(() => isFdMonthly = val),
            ),
            AmountInputField(
              label: 'Profession',
              controller: businessController,
              isMonthly: businessMonthly,
              onToggle: (val) => setState(() => businessMonthly = val),
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
