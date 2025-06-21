import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'sales_order_form_screen.dart';

class SalesOrderListScreen extends StatefulWidget {
  const SalesOrderListScreen({super.key});

  @override
  State<SalesOrderListScreen> createState() => _SalesOrderListScreenState();
}

class _SalesOrderListScreenState extends State<SalesOrderListScreen> {
  String searchText = "";
  String statusFilter = "all";

  // ตัวเลือกสถานะ
  final statusOptions = [
    {"value": "all", "label": "ทั้งหมด"},
    {"value": "รอดำเนินการ", "label": "รอดำเนินการ"},
    {"value": "สำเร็จ", "label": "สำเร็จ"},
    {"value": "ยกเลิก", "label": "ยกเลิก"},
  ];

  List<Map<String, dynamic>> get soList => mockSalesOrderList;

  @override
  Widget build(BuildContext context) {
    final filtered = soList.where((so) {
      final matchStatus = statusFilter == "all" || (so["status"] ?? "") == statusFilter;
      if (!matchStatus) return false;
      if (searchText.isEmpty) return true;
      final qText = searchText.toLowerCase();
      return [
        so["soNo"] ?? "",
        so["customer"] ?? "",
        so["status"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(qText));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ใบสั่งขาย (Sales Order)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (เลขที่/ลูกค้า/สถานะ)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: DropdownButtonFormField<String>(
              value: statusFilter,
              items: statusOptions
                  .map((s) => DropdownMenuItem(
                        value: s["value"],
                        child: Text(s["label"]!),
                      ))
                  .toList(),
              onChanged: (val) => setState(() => statusFilter = val ?? "all"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                labelText: "สถานะ",
              ),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูล"))
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final so = filtered[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.indigo,
                            child: Icon(Icons.assignment, color: Colors.white),
                          ),
                         // ...existing code...
                          title: Text(
                            "${so["soNo"] ?? ""} (${so["status"] ?? ""})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ลูกค้า: ${so["customerName"] ?? "-"}"),
                              Text("วันที่: ${so["date"] ?? "-"}"),
                              Text("ยอดรวม: ${so["total"]?.toStringAsFixed(2) ?? "-"} บาท"),
                              Text("จำนวนรายการ: ${(so["items"] as List?)?.length ?? 0}"),
                            ],
                          ),
                          // ...existing code...
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => SalesOrderFormScreen(order: so),
                              ),
                            );
                            if (result != null && result is Map<String, dynamic>) {
                              setState(() {
                                final idx = soList.indexOf(so);
                                soList[idx] = result;
                              });
                            }
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("สร้างใบสั่งขาย"),
        onPressed: () async {
          final newSO = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SalesOrderFormScreen()),
          );
          if (newSO != null) {
            setState(() => soList.add(newSO));
          }
        },
      ),
    );
  }
}
