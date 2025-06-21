// lib/screens/dashboard/widgets/sales_bar_chart.dart

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class SalesBarChart extends StatelessWidget {
  final List<String> months;
  final Map<int, double> salesData;
  final Map<int, double> purchaseData;

  const SalesBarChart({
    super.key,
    required this.months,
    required this.salesData,
    required this.purchaseData,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "[บาท]",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 230,
          child: BarChart(
            BarChartData(
              gridData: FlGridData(
                show: true,
                drawHorizontalLine: true,
                horizontalInterval: 5000,
              ),
              titlesData: FlTitlesData(
                show: true,
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, meta) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 8),
                      ),
                    ),
                    interval: 5000,
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      int idx = value.toInt() - 1;
                      return idx >= 0 && idx < months.length
                          ? Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(
                                months[idx],
                                style: const TextStyle(fontSize: 11),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ),
                rightTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              barGroups: List.generate(months.length, (i) {
                return BarChartGroupData(
                  x: i + 1,
                  barRods: [
                    BarChartRodData(
                      toY: salesData[i + 1] ?? 0,
                      color: Colors.blue,
                      width: 10,
                      borderRadius: BorderRadius.circular(3),
                      // No label on bar
                    ),
                    BarChartRodData(
                      toY: purchaseData[i + 1] ?? 0,
                      color: Colors.orange,
                      width: 10,
                      borderRadius: BorderRadius.circular(3),
                      // No label on bar
                    ),
                  ],
                );
              }),
              barTouchData: BarTouchData(
                enabled: true,
                touchTooltipData: BarTouchTooltipData(
                  //tooltipBgColor: Colors.black87,
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final isSales = rodIndex == 0;
                    final value = rod.toY;
                    return BarTooltipItem(
                      (isSales ? 'Sales: ' : 'Purchases: ') +
                          value.toInt().toString(),
                      const TextStyle(color: Colors.white),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
