import 'package:flutter/material.dart';

class ReportStockSummaryScreen extends StatelessWidget {
  const ReportStockSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final stockList = [
      {"code": "P001", "name": "สมุดโน๊ต A5", "stock": 120, "unit": "เล่ม"},
      {"code": "P002", "name": "ปากกาเจล", "stock": 10, "unit": "ด้าม"},
      {"code": "P003", "name": "น้ำดื่ม", "stock": 2, "unit": "ขวด"},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text("รายงานสรุปสินค้าคงคลัง")),
      body: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          DataTable(
            columns: const [
              DataColumn(label: Text("รหัสสินค้า")),
              DataColumn(label: Text("ชื่อสินค้า")),
              DataColumn(label: Text("คงเหลือ")),
              DataColumn(label: Text("หน่วย")),
            ],
            rows: stockList
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row["code"].toString())),
                      DataCell(Text(row["name"].toString())),
                      DataCell(Text(row["stock"].toString())),
                      DataCell(Text(row["unit"].toString())),
                    ],
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}
