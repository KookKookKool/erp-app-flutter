import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  const SummaryCard({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 120,
        height: 65,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value.toStringAsFixed(0), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              Text(label, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
