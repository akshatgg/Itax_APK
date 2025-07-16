import 'package:flutter/material.dart';

class CustomYearDropdown extends StatelessWidget {
  final String? value;
  final List<String> options;
  final String hint;
  final ValueChanged<String?> onChanged;
  final bool wrapContent;

  const CustomYearDropdown({
    super.key,
    required this.value,
    required this.options,
    required this.onChanged,
    this.hint = 'Select',
    this.wrapContent = false,
  });

  @override
  Widget build(BuildContext context) {
    final dropdown = Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: !wrapContent,
          alignment: Alignment.center,
          dropdownColor: Colors.white,
          borderRadius: BorderRadius.circular(12),
          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
          hint: Text(
            hint,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          items: options.map((option) {
            return DropdownMenuItem<String>(
              value: option,
              alignment: Alignment.center,
              child: Text(
                option,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );

    return Center(
      child: wrapContent ? IntrinsicWidth(child: dropdown) : dropdown,
    );
  }
}
