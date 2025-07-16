import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_text_style.dart';
import '../../../../../core/constants/color_constants.dart';

class SalesReceiptChart extends StatelessWidget {
  final List<FlSpot> salesData;
  final List<FlSpot> receiptData;
  final List<String> xAxisTitles; // Dynamic X-axis labels

  const SalesReceiptChart({
    super.key,
    required this.salesData,
    required this.xAxisTitles, // Required for dynamic labels
    required this.receiptData,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: LineChart(
          LineChartData(
            titlesData: FlTitlesData(
              topTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles:
                  const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      '${value.toInt()}K', // Example: 100K, 200K
                      style: AppTextStyle.pw400.copyWith(color: AppColor.grey),
                    );
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    int index = value.toInt();
                    if (index >= 0 && index < xAxisTitles.length) {
                      return Text(
                        xAxisTitles[index],
                        style:
                            AppTextStyle.pw400.copyWith(color: AppColor.grey),
                      ); // Dynamic title from the list
                    }
                    return const Text('');
                  },
                ),
              ),
            ),
            gridData: const FlGridData(show: false, drawVerticalLine: false),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                  left: BorderSide(
                    color: AppColor.grey,
                  ),
                  bottom: BorderSide(
                    color: AppColor.grey,
                  )),
            ),
            lineBarsData: [
              _lineChartBarData(salesData, AppColor.appColor),
              _lineChartBarData(receiptData, const Color(0XFFA7BFE4)),
            ],
          ),
        ),
      ),
    );
  }

  /// Helper function to create a LineChartBarData
  LineChartBarData _lineChartBarData(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 3,
      isStrokeCapRound: true,
      belowBarData: BarAreaData(show: true, color: AppColor.lightAppColor),
    );
  }
}
