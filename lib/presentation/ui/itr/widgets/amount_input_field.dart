import 'package:flutter/material.dart';

import 'monthly_year_toggle.dart';

class AmountInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool isMonthly;
  final ValueChanged<bool> onToggle;

  const AmountInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.isMonthly,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: '0',
            ),
            // No need to use onChanged here because the controller already has a listener in the main file
          ),
          const SizedBox(height: 8),
          MonthlyYearlyToggle(
            isMonthly: isMonthly,
            onChanged: onToggle,
          ),
        ],
      ),
    );
  }
}
