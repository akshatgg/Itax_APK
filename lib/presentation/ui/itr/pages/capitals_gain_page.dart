import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_itr.dart';
import '../widgets/gradient_app_bar.dart';
import '../widgets/labeled_input_field.dart'; // ← import reusable widget

class CapitalGainsPage extends StatefulWidget {
  const CapitalGainsPage({super.key});

  @override
  State<CapitalGainsPage> createState() => _CapitalGainsPageState();
}

class _CapitalGainsPageState extends State<CapitalGainsPage> {
  final stcg15Controller = TextEditingController();
  final stcgNoTaxController = TextEditingController();
  final ltcg10Controller = TextEditingController();
  final ltcg20Controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GradientAppBar(
        title: 'Capital Gains',
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            LabeledInputField(
              label: 'Short Term Capital Gain - Taxable @ 15%',
              controller: stcg15Controller,
            ),
            LabeledInputField(
              label: 'Short Term Capital Gain - Taxable at No',
              controller: stcgNoTaxController,
            ),
            LabeledInputField(
              label: 'Long Term Capital Gain - Taxable @ 10%',
              controller: ltcg10Controller,
            ),
            LabeledInputField(
              label: 'Long Term Capital Gain - Taxable @ 20%',
              controller: ltcg20Controller,
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle save logic here
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
