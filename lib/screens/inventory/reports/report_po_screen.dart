import 'package:flutter/material.dart';

class ReportPOScreen extends StatelessWidget {
  const ReportPOScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final poList = [
      {"poNo": "PO-240001", "date": "2024-06-20", "supplier": "สมาร์ทซัพพลาย", "total": 15000, "status": "รอดำเนินการ"},
      {"poNo": "PO-240002", "date": "2024-06-18", "supplier": "รุ่งเรือง", "total": 6000, "status": "อนุมัติ"},
      {"poNo": "PO-240003", "date": "2024-06-17", "supplier": "บริษัททดสอบ", "total": 9999, "status": "ยกเลิก"},
    ];

    Color getStatusColor(String status) {
      switch (status) {
        case "อนุมัติ": return Colors.green;
        case "ยกเลิก": return Colors.red;
        default: return Colors.orange;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("รายงานใบสั่งซื้อ (PO)")),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        separatorBuilder: (_, __) => const Divider(height: 18),
        itemCount: poList.length,
        itemBuilder: (context, i) {
          final po = poList[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: getStatusColor(po["status"] as String).withOpacity(0.15),
              child: Icon(Icons.receipt, color: getStatusColor(po["status"] as String)),
            ),
            title: Text(
              "${po["poNo"]} - ${po["supplier"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("วันที่: ${po["date"]} | สถานะ: ${po["status"]} | รวม: ${po["total"]} บาท"),
          );
        },
      ),
    );
  }
}
