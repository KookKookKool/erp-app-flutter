import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ReportStockSummaryScreen extends StatelessWidget {
  const ReportStockSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายงานคงเหลือสินค้า")),
      body: ListView.builder(
        itemCount: mockProductList.length,
        itemBuilder: (context, i) {
          final p = mockProductList[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            child: ListTile(
              leading: CircleAvatar(child: Text('${i + 1}')),
              title: Text("${p["name"]} (${p["code"]})"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("คงเหลือ: ${p["qty"]}"),
                  Text("ขั้นต่ำ: ${p["min"]}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
