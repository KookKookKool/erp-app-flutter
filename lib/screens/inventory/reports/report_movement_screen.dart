import 'package:flutter/material.dart';

class ReportMovementScreen extends StatelessWidget {
  const ReportMovementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movementList = [
      {"date": "2024-06-20", "type": "IN", "product": "สมุดโน๊ต A5", "qty": 50, "unit": "เล่ม"},
      {"date": "2024-06-20", "type": "OUT", "product": "น้ำดื่ม", "qty": 10, "unit": "ขวด"},
      {"date": "2024-06-21", "type": "TRANSFER", "product": "ปากกาเจล", "qty": 20, "unit": "ด้าม"},
    ];

    Color getTypeColor(String type) {
      switch (type) {
        case "IN": return Colors.green;
        case "OUT": return Colors.red;
        case "TRANSFER": return Colors.blue;
        default: return Colors.grey;
      }
    }

    String getTypeLabel(String type) {
      switch (type) {
        case "IN": return "รับเข้า";
        case "OUT": return "จ่ายออก";
        case "TRANSFER": return "โอนคลัง";
        default: return "-";
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("รายงานการเคลื่อนไหวสินค้า")),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        separatorBuilder: (_, __) => const Divider(height: 18),
        itemCount: movementList.length,
        itemBuilder: (context, i) {
          final m = movementList[i];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: getTypeColor(m["type"] as String).withOpacity(0.15),
              child: Icon(Icons.swap_horiz, color: getTypeColor(m["type"] as String)),
            ),
            title: Text(
              "${m["product"]} (${m["qty"]} ${m["unit"]})",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("วันที่: ${m["date"] as String} | ประเภท: ${getTypeLabel(m["type"] as String)}"),
          );
        },
      ),
    );
  }
}
