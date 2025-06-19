import 'package:flutter/material.dart';
import 'purchasing_form_screen.dart';
import 'package:erp_app/utils/mock_data.dart';

class PurchasingListScreen extends StatefulWidget {
  const PurchasingListScreen({super.key});

  @override
  State<PurchasingListScreen> createState() => _PurchasingListScreenState();
}

class _PurchasingListScreenState extends State<PurchasingListScreen> {
  String searchText = "";
  String statusFilter = "all";

  List<Map<String, dynamic>> get poList => mockPOList;

  // ตัวเลือกสถานะ PO (รองรับทุกสถานะที่ใช้ในระบบ)
  final statusOptions = [
    {"value": "all", "label": "ทั้งหมด"},
    {"value": "รอดำเนินการ", "label": "รอดำเนินการ"},
    {"value": "อนุมัติ", "label": "อนุมัติ"},
    {"value": "รับบางส่วน", "label": "รับบางส่วน"},
    {"value": "รับครบ", "label": "รับครบ"},
    {"value": "ยกเลิก", "label": "ยกเลิก"},
  ];

  @override
  Widget build(BuildContext context) {
    // ฟิลเตอร์ search และ status
    final filtered = poList.where((po) {
      final matchStatus =
          statusFilter == "all" || (po["status"] ?? "") == statusFilter;
      if (!matchStatus) return false;
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return [
        po["poNo"] ?? "",
        po["supplier"] ?? "",
        po["warehouse"] ?? "",
        po["status"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("รายการสั่งซื้อ/PO")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (PO/ซัพพลายเออร์/สถานะ/คลัง)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "สถานะ:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: statusFilter,
                    items: statusOptions
                        .map(
                          (s) => DropdownMenuItem(
                            value: s["value"],
                            child: Text(s["label"]!),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => statusFilter = val ?? "all"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final po = filtered[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      child: const Icon(Icons.receipt_long, color: Colors.blue),
                    ),
                    title: Text(
                      "${po["poNo"]} (${po["status"] ?? ""})",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Supplier: ${po["supplier"] ?? "-"}"),
                        Text("คลังรับเข้า: ${po["warehouse"] ?? "-"}"),
                        Text(
                          "จำนวนรายการ: ${(po["items"] as List?)?.length ?? 0}",
                        ),
                        Text("วันที่: ${po["date"] ?? "-"}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PurchasingFormScreen(po: po),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() {
                            poList.remove(po);
                          });
                        } else if (result != null &&
                            result is Map<String, dynamic>) {
                          setState(() {
                            final idx = poList.indexOf(po);
                            poList[idx] = result;
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => PurchasingFormScreen(po: po),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() {
                          poList.remove(po);
                        });
                      } else if (result != null &&
                          result is Map<String, dynamic>) {
                        setState(() {
                          final idx = poList.indexOf(po);
                          poList[idx] = result;
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
        label: const Text("สร้าง PO"),
        onPressed: () async {
          final newPO = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PurchasingFormScreen(po: {}),
            ),
          );
          if (newPO != null) {
            setState(() {
              poList.add(newPO);
            });
          }
        },
      ),
    );
  }
}
