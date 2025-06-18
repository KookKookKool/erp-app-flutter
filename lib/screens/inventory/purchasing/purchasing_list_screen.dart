import 'package:flutter/material.dart';
import 'purchasing_form_screen.dart';

class PurchasingListScreen extends StatefulWidget {
  const PurchasingListScreen({super.key});
  @override
  State<PurchasingListScreen> createState() => _PurchasingListScreenState();
}

class _PurchasingListScreenState extends State<PurchasingListScreen> {
  List<Map<String, dynamic>> orders = [
    {
      "poNo": "PO-240001",
      "date": "2024-06-20",
      "supplier": "บริษัท สมาร์ทซัพพลาย จำกัด",
      "total": 15000,
      "status": "รอดำเนินการ",
      "remark": "",
    },
    {
      "poNo": "PO-240002",
      "date": "2024-06-18",
      "supplier": "รุ่งเรืองการค้า",
      "total": 6000,
      "status": "อนุมัติ",
      "remark": "เร่งด่วน",
    },
    {
      "poNo": "PO-240003",
      "date": "2024-06-17",
      "supplier": "บริษัท ทดสอบ จำกัด",
      "total": 9999,
      "status": "ยกเลิก",
      "remark": "ขอยกเลิกคำสั่งซื้อ",
    },
  ];

  final statusOptions = [
    {"value": null, "label": "ทั้งหมด"},
    {"value": "รอดำเนินการ", "label": "รอดำเนินการ"},
    {"value": "อนุมัติ", "label": "อนุมัติ"},
    {"value": "ยกเลิก", "label": "ยกเลิก"},
  ];

  String? filterStatus;
  String searchPoNo = "";

  @override
  Widget build(BuildContext context) {
    // กรองตามสถานะและค้นหา PO
    final filtered = orders.where((o) {
      final matchStatus = filterStatus == null || o["status"] == filterStatus;
      final matchPoNo = searchPoNo.isEmpty || o["poNo"].toString().contains(searchPoNo);
      return matchStatus && matchPoNo;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ใบสั่งซื้อ (Purchasing)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหาเลขที่ใบสั่งซื้อ (PO)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchPoNo = v),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: Row(
              children: [
                const Text(
                  "กรองสถานะ:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: filterStatus,
                    items: statusOptions
                        .map(
                          (s) => DropdownMenuItem(
                            value: s["value"],
                            child: Text(s["label"]!),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => filterStatus = val),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("ไม่พบใบสั่งซื้อในสถานะนี้"))
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final o = filtered[i];
                      Color color;
                      switch (o["status"]) {
                        case "อนุมัติ":
                          color = Colors.green;
                          break;
                        case "ยกเลิก":
                          color = Colors.red;
                          break;
                        default:
                          color = Colors.orange;
                      }
                      return Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.15),
                            child: Icon(Icons.shopping_cart_checkout, color: color),
                          ),
                          title: Text(
                            "${o["poNo"]} - ${o["supplier"]}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("วันที่: ${o["date"]}"),
                              Text("สถานะ: ${o["status"]}"),
                              Text("รวม: ${o["total"]} บาท"),
                              if ((o["remark"] ?? "").isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text("หมายเหตุ: ${o["remark"]}",
                                      style: const TextStyle(fontSize: 12)),
                                ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => PurchasingFormScreen(order: o),
                                ),
                              );
                              if (result == 'delete') {
                                setState(() {
                                  orders.removeWhere((x) => x["poNo"] == o["poNo"]);
                                });
                              } else if (result != null && result is Map<String, dynamic>) {
                                setState(() {
                                  final idx = orders.indexWhere((x) => x["poNo"] == o["poNo"]);
                                  if (idx != -1) orders[idx] = result;
                                });
                              }
                            },
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => PurchasingFormScreen(order: o),
                              ),
                            );
                            if (result == 'delete') {
                              setState(() {
                                orders.removeWhere((x) => x["poNo"] == o["poNo"]);
                              });
                            } else if (result != null && result is Map<String, dynamic>) {
                              setState(() {
                                final idx = orders.indexWhere((x) => x["poNo"] == o["poNo"]);
                                if (idx != -1) orders[idx] = result;
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
        label: const Text("สร้างใบสั่งซื้อ"),
        onPressed: () async {
          final newOrder = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const PurchasingFormScreen()),
          );
          if (newOrder != null) {
            setState(() => orders.add(newOrder));
          }
        },
      ),
    );
  }
}
