import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ReportPOScreen extends StatelessWidget {
  const ReportPOScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รายงานใบสั่งซื้อ/PO")),
      body: ListView.builder(
        itemCount: mockPOList.length,
        itemBuilder: (context, i) {
          final po = mockPOList[i];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 14),
            child: ListTile(
              leading: const Icon(Icons.receipt_long, color: Colors.blue),
              title: Text("${po["poNo"]} (${po["status"] ?? ""})"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Supplier: ${po["supplier"] ?? "-"}"),
                  Text("คลังรับเข้า: ${po["warehouse"] ?? "-"}"),
                  Text("วันที่: ${po["date"] ?? "-"}"),
                  Text("จำนวนรายการ: ${(po["items"] as List?)?.length ?? 0}"),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
