import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart'; // ต้องชี้ให้ถูก
import 'quotation_form_screen.dart';

class QuotationListScreen extends StatefulWidget {
  const QuotationListScreen({super.key});

  @override
  State<QuotationListScreen> createState() => _QuotationListScreenState();
}

class _QuotationListScreenState extends State<QuotationListScreen> {
  String searchText = "";
  String statusFilter = "all";

  // ตัวเลือกสถานะ
  final statusOptions = [
    {"value": "all", "label": "ทั้งหมด"},
    {"value": "รอดำเนินการ", "label": "รอดำเนินการ"},
    {"value": "สำเร็จ", "label": "สำเร็จ"},
    {"value": "ยกเลิก", "label": "ยกเลิก"},
  ];

  List<Map<String, dynamic>> get quotationList => mockQuotationList;

  @override
  Widget build(BuildContext context) {
    final filtered = quotationList.where((q) {
      final matchStatus =
          statusFilter == "all" || (q["status"] ?? "") == statusFilter;
      if (!matchStatus) return false;
      if (searchText.isEmpty) return true;
      final qText = searchText.toLowerCase();
      return [
        q["quotationNo"] ?? "",
        q["customer"] ?? "",
        q["status"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(qText));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ใบเสนอราคา (Quotation)")),
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
                  .map(
                    (s) => DropdownMenuItem(
                      value: s["value"],
                      child: Text(s["label"]!),
                    ),
                  )
                  .toList(),
              onChanged: (val) => setState(() => statusFilter = val ?? "all"),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
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
                      final q = filtered[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.request_quote, color: Colors.white),
                          ),
                          title: Text(
                            "${q["quotationNo"] ?? ""} (${q["status"] ?? ""})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ลูกค้า: ${q["customerName"] ?? "-"}"),
                              Text("วันที่: ${q["date"] ?? "-"}"),
                              Text(
                                "ยอดรวม: ${q["total"]?.toStringAsFixed(2) ?? "-"} บาท",
                              ),
                              Text(
                                "จำนวนรายการ: ${(q["items"] as List?)?.length ?? 0}",
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      QuotationFormScreen(quotation: q),
                                ),
                              );
                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                setState(() {
                                  final idx = quotationList.indexOf(q);
                                  quotationList[idx] = result;
                                });
                              }
                            },
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    QuotationFormScreen(quotation: q),
                              ),
                            );
                            if (result != null &&
                                result is Map<String, dynamic>) {
                              setState(() {
                                final idx = quotationList.indexOf(q);
                                quotationList[idx] = result;
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
        label: const Text("สร้างใบเสนอราคา"),
        onPressed: () async {
          final newQ = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const QuotationFormScreen()),
          );
          if (newQ != null) {
            setState(() => quotationList.add(newQ));
          }
        },
      ),
    );
  }
}
