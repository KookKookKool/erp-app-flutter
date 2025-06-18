import 'package:flutter/material.dart';

class ReportLowStockScreen extends StatelessWidget {
  const ReportLowStockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ตัวอย่างข้อมูล mockup (ปกติควรดึงจากฐานข้อมูลจริง)
    final lowStockList = [
      {"code": "P002", "name": "ปากกาเจล", "stock": 8, "unit": "ด้าม", "min": 10},
      {"code": "P003", "name": "น้ำดื่ม", "stock": 2, "unit": "ขวด", "min": 5},
      {"code": "P004", "name": "แฟ้มเอกสาร", "stock": 0, "unit": "เล่ม", "min": 3},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text("รายงานสินค้าต่ำกว่าขั้นต่ำ")),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        separatorBuilder: (_, __) => const Divider(height: 18),
        itemCount: lowStockList.length,
        itemBuilder: (context, i) {
          final row = lowStockList[i];
          return Card(
            color: Colors.red[50],
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              leading: const Icon(Icons.warning, color: Colors.red),
              title: Text(
                "${row["name"]} (คงเหลือ ${row["stock"]} ${row["unit"]})",
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              subtitle: Text(
                "รหัส: ${row["code"]} | ขั้นต่ำที่ตั้งไว้: ${row["min"]} ${row["unit"]}",
                style: const TextStyle(color: Colors.black87),
              ),
            ),
          );
        },
      ),
    );
  }
}
