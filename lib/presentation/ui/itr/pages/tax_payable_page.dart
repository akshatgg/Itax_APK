import 'package:flutter/material.dart';

import '../widgets/gradient_app_bar.dart';
import 'exemptions_deductions_page.dart';

class TaxPayableScreen extends StatelessWidget {
  const TaxPayableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taxItems = [
      '234A :  Delay in Fill in the return of Income',
      '234B :  Delay in Advance Tax',
      '234C :  Interest on Tax',
      '234F :  Penalty Late Filling',
    ];

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Tax Payable',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: taxItems.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return InputField(
              label: taxItems[index],
              suffix: '', // no suffix shown in your UI
            );
          },
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                // Save logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3D73DD),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Save',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
