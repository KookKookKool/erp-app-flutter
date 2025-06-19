import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ReportLowStockScreen extends StatelessWidget {
  const ReportLowStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final lowStock = mockProductList.where((p) => p["qty"] < p["min"]).toList();
    return Scaffold(
      appBar: AppBar(title: const Text("รายงานสินค้าใกล้หมด (Low Stock)")),
      body: lowStock.isEmpty
          ? const Center(child: Text("ไม่มีสินค้าคงเหลือต่ำกว่าขั้นต่ำ"))
          : ListView.builder(
              itemCount: lowStock.length,
              itemBuilder: (context, i) {
                final p = lowStock[i];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 6,
                    horizontal: 14,
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    title: Text("${p["name"]} (${p["code"]})"),
                    subtitle: Text("เหลือ: ${p["qty"]} (ขั้นต่ำ: ${p["min"]})"),
                  ),
                );
              },
            ),
    );
  }
}
