import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class InventoryPieChart extends StatelessWidget {
  final int inStock;
  final int lowStock;
  const InventoryPieChart({super.key, required this.inStock, required this.lowStock});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: PieChart(
        PieChartData(
          sections: [
            PieChartSectionData(
              value: lowStock.toDouble(),
              color: Colors.redAccent,
              title: 'ต่ำ (${lowStock})',
              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              radius: 52,
            ),
            PieChartSectionData(
              value: inStock.toDouble(),
              color: Colors.lightGreen,
              title: 'ปกติ (${inStock})',
              titleStyle: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              radius: 52,
            ),
          ],
          centerSpaceRadius: 30,
          sectionsSpace: 2,
        ),
      ),
    );
  }
}
