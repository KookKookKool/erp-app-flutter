import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';


class ReportMovementScreen extends StatelessWidget {
  const ReportMovementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movements = List<Map<String, dynamic>>.from(mockMovementList);
    return Scaffold(
      appBar: AppBar(title: const Text("รายงานการเคลื่อนไหวสินค้า")),
      body: movements.isEmpty
          ? const Center(child: Text("ไม่มีข้อมูลการเคลื่อนไหว"))
          : ListView.builder(
              itemCount: movements.length,
              itemBuilder: (context, i) {
                final m = movements[i];
                String typeLabel;
                Color typeColor;
                switch (m["type"]) {
                  case "IN":
                    typeLabel = "รับเข้า";
                    typeColor = Colors.green;
                    break;
                  case "OUT":
                    typeLabel = "จ่ายออก";
                    typeColor = Colors.red;
                    break;
                  case "TRANSFER":
                  default:
                    typeLabel = "โอน";
                    typeColor = Colors.blue;
                }
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
                  child: ListTile(
                    leading: Icon(Icons.swap_horiz, color: typeColor),
                    title: Text(
                        "${m["productName"] ?? m["product"]} ($typeLabel) - ${m["qty"]}"),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("วันที่: ${m["date"] ?? "-"}"),
                        Text("คลัง: ${m["warehouse"] ?? "-"}"),
                        if ((m["remark"] ?? "").toString().isNotEmpty)
                          Text("หมายเหตุ: ${m["remark"]}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
