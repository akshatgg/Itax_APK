import 'package:flutter/material.dart';

import '../widgets/custom_bottom_nav_itr.dart';
import '../widgets/gradient_app_bar.dart';

class IncomeTaxCalculatorScreen extends StatelessWidget {
  const IncomeTaxCalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final options = [
      'Advance & Assessment Tax',
      'TDS Details',
      'TDS Non Salary',
      'TDS On Salary',
    ];

    return Scaffold(
      appBar: GradientAppBar(
        title: 'Income Tax Calculator',
        onBack: () => Navigator.pop(context),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: options.length,
          separatorBuilder: (_, __) => const SizedBox(height: 16),
          itemBuilder: (context, index) {
            return ElevatedButton(
              onPressed: () {
                // Navigation or logic for each button
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAF2FF),
                foregroundColor: Colors.black,
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: const BorderSide(
                      color: Colors.blueAccent), // 👈 Added border color
                ),
                minimumSize: const Size.fromHeight(50),
                shadowColor: Colors.black12,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  options[index],
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            );
          },
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
