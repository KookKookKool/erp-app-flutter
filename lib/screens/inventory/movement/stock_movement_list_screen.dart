import 'package:flutter/material.dart';
import 'stock_movement_form_screen.dart';

class StockMovementListScreen extends StatefulWidget {
  const StockMovementListScreen({super.key});
  @override
  State<StockMovementListScreen> createState() => _StockMovementListScreenState();
}

class _StockMovementListScreenState extends State<StockMovementListScreen> {
  List<Map<String, dynamic>> movements = [
    {
      "type": "IN",
      "date": "2024-06-19",
      "docNo": "IN-240001",
      "warehouse": "คลังหลัก",
      "product": "สมุดโน๊ต A5",
      "qty": 50,
      "unit": "เล่ม",
      "remark": "รับเข้า (สั่งซื้อ)",
    },
    {
      "type": "OUT",
      "date": "2024-06-18",
      "docNo": "OUT-240001",
      "warehouse": "คลังสาขา 1",
      "product": "น้ำดื่ม 600ml",
      "qty": 10,
      "unit": "ขวด",
      "remark": "เบิกใช้งานกิจกรรม",
    },
    {
      "type": "TRANSFER",
      "date": "2024-06-17",
      "docNo": "TRF-240001",
      "warehouse": "คลังหลัก → คลังสาขา 1",
      "product": "ปากกาเจล",
      "qty": 20,
      "unit": "ด้าม",
      "remark": "โอนย้ายคลัง",
    },
  ];

  String searchText = "";

  final typeOptions = [
    {"value": null, "label": "ทั้งหมด"},
    {"value": "IN", "label": "รับเข้า"},
    {"value": "OUT", "label": "จ่ายออก"},
    {"value": "TRANSFER", "label": "โอนคลัง"},
  ];
  String? filterType;

  @override
  Widget build(BuildContext context) {
    // ฟิลเตอร์ทั้ง search และ type
    final filtered = movements.where((mv) {
      final matchType = filterType == null || mv["type"] == filterType;
      if (!matchType) return false;

      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return mv.values
        .whereType<String>()
        .any((v) => v.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("รับ/จ่าย/โอนสินค้า"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (ทุกฟิลด์)",
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
                  "ประเภท:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: filterType,
                    items: typeOptions
                        .map(
                          (t) => DropdownMenuItem(
                            value: t["value"],
                            child: Text(t["label"]!),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => filterType = val),
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
                ? const Center(child: Text("ไม่พบข้อมูล"))
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final mv = filtered[i];
                      Color color;
                      IconData iconData;
                      String label;
                      switch (mv["type"]) {
                        case "IN":
                          color = Colors.green;
                          iconData = Icons.call_received;
                          label = "รับเข้า";
                          break;
                        case "OUT":
                          color = Colors.red;
                          iconData = Icons.call_made;
                          label = "จ่ายออก";
                          break;
                        case "TRANSFER":
                        default:
                          color = Colors.blue;
                          iconData = Icons.compare_arrows;
                          label = "โอนคลัง";
                      }
                      return Card(
                        elevation: 3,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.15),
                            child: Icon(iconData, color: color),
                          ),
                          title: Text(
                            "${mv["product"]}  (${mv["qty"]} ${mv["unit"]})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ประเภท: $label  |  เลขที่: ${mv["docNo"]}"),
                              Text("คลัง: ${mv["warehouse"]}  |  วันที่: ${mv["date"]}"),
                              if ((mv["remark"] ?? "").toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text("หมายเหตุ: ${mv["remark"]}",
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
                                  builder: (_) => StockMovementFormScreen(movement: mv),
                                ),
                              );
                              if (result == 'delete') {
                                setState(() {
                                  movements.removeAt(i);
                                });
                              } else if (result != null && result is Map<String, dynamic>) {
                                setState(() {
                                  movements[i] = result;
                                });
                              }
                            },
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => StockMovementFormScreen(movement: mv),
                              ),
                            );
                            if (result == 'delete') {
                              setState(() {
                                movements.removeAt(i);
                              });
                            } else if (result != null && result is Map<String, dynamic>) {
                              setState(() {
                                movements[i] = result;
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
        label: const Text("รับ/จ่าย/โอนใหม่"),
        onPressed: () async {
          final newMv = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const StockMovementFormScreen()),
          );
          if (newMv != null) {
            setState(() => movements.add(newMv));
          }
        },
      ),
    );
  }
}
