import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class MonthlyYearlyToggle extends StatefulWidget {
  final bool isMonthly;
  final ValueChanged<bool> onChanged;

  const MonthlyYearlyToggle({
    super.key,
    required this.isMonthly,
    required this.onChanged,
  });

  @override
  State<MonthlyYearlyToggle> createState() => _MonthlyYearlyToggleState();
}

class _MonthlyYearlyToggleState extends State<MonthlyYearlyToggle> {
  late bool isMonthly;
  double dragPercent = 0.0;

  @override
  void initState() {
    super.initState();
    isMonthly = widget.isMonthly;
    dragPercent = isMonthly ? 0.0 : 1.0;
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      dragPercent += details.primaryDelta! / 170;
      dragPercent = dragPercent.clamp(0.0, 1.0);
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    setState(() {
      isMonthly = dragPercent < 0.5;
      dragPercent = isMonthly ? 0.0 : 1.0;
    });
    widget.onChanged(isMonthly);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Container(
        height: 36,
        width: 170,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F0F0),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.blue),
        ),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.lerp(
                  Alignment.centerLeft, Alignment.centerRight, dragPercent)!,
              child: Container(
                width: 85,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F2FF),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blue, width: 1.2),
                ),
              ),
            ),
            Row(
              children: [
                _buildOption('Monthly', true),
                _buildOption('Yearly', false),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(String label, bool value) {
    final selected = value == (dragPercent < 0.5);
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            isMonthly = value;
            dragPercent = isMonthly ? 0.0 : 1.0;
          });
          widget.onChanged(value);
        },
        child: Container(
          alignment: Alignment.center,
          height: double.infinity,
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13.5.px,
              color: selected ? Colors.blue.shade800 : Colors.black87,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
