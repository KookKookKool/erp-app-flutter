import 'package:flutter/material.dart';
import 'receiving_form_screen.dart';

class ReceivingListScreen extends StatefulWidget {
  const ReceivingListScreen({super.key});
  @override
  State<ReceivingListScreen> createState() => _ReceivingListScreenState();
}

class _ReceivingListScreenState extends State<ReceivingListScreen> {
  List<Map<String, dynamic>> receipts = [
    {
      "receiveNo": "RC-240001",
      "date": "2024-06-24",
      "poNo": "PO-240002",
      "supplier": "รุ่งเรืองการค้า",
      "warehouse": "คลังหลัก",
      "items": [
        {"code": "P001", "name": "สมุดโน๊ต A5", "qty": 20, "unit": "เล่ม"},
        {"code": "P002", "name": "ปากกาเจล", "qty": 15, "unit": "ด้าม"},
      ],
      "status": "รับครบ",
    },
    {
      "receiveNo": "RC-240002",
      "date": "2024-06-25",
      "poNo": "PO-240001",
      "supplier": "บริษัท สมาร์ทซัพพลาย จำกัด",
      "warehouse": "คลังสาขา 1",
      "items": [
        {"code": "P003", "name": "น้ำดื่ม", "qty": 5, "unit": "ขวด"},
      ],
      "status": "รับบางส่วน",
    },
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filtered = receipts.where((r) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return r.values
        .whereType<String>()
        .any((v) => v.toLowerCase().contains(q)) ||
        (r["items"] as List).any((item) =>
          item.values.whereType<String>().any((v) => v.toLowerCase().contains(q)));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("รับสินค้าเข้าคลัง (Receiving)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (เลขที่รับ, PO, Supplier, สินค้า ฯลฯ)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final r = filtered[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: r["status"] == "รับครบ"
                          ? Colors.green.withOpacity(0.18)
                          : Colors.orange.withOpacity(0.18),
                      child: Icon(
                        Icons.move_to_inbox,
                        color: r["status"] == "รับครบ" ? Colors.green : Colors.orange,
                      ),
                    ),
                    title: Text(
                      "${r["receiveNo"]} | PO: ${r["poNo"]}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("วันที่: ${r["date"]} | คลัง: ${r["warehouse"]}"),
                        Text("Supplier: ${r["supplier"]}"),
                        ...((r["items"] as List).map((item) => Text(
                          "- ${item["name"]} (${item["qty"]} ${item["unit"]})",
                          style: const TextStyle(fontSize: 13),
                        ))),
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "สถานะ: ${r["status"]}",
                            style: TextStyle(
                              color: r["status"] == "รับครบ" ? Colors.green : Colors.orange,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueGrey),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReceivingFormScreen(receipt: r),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() => receipts.removeAt(i));
                        } else if (result != null && result is Map<String, dynamic>) {
                          setState(() => receipts[i] = result);
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReceivingFormScreen(receipt: r),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() => receipts.removeAt(i));
                      } else if (result != null && result is Map<String, dynamic>) {
                        setState(() => receipts[i] = result);
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
        label: const Text("รับสินค้าเข้าใหม่"),
        onPressed: () async {
          final newR = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ReceivingFormScreen()),
          );
          if (newR != null) {
            setState(() => receipts.add(newR));
          }
        },
      ),
    );
  }
}
