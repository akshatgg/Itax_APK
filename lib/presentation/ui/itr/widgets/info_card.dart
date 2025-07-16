import 'package:flutter/material.dart';

class InfoCard extends StatelessWidget {
  final String label;
  final double value;
  final Color backgroundColor;
  final Color textColor;

  const InfoCard({
    super.key,
    required this.label,
    required this.value,
    this.backgroundColor = const Color(0xFFEFF5FF),
    this.textColor = Colors.black87,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent),
        boxShadow: [
          const BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            value.toStringAsFixed(1),
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
