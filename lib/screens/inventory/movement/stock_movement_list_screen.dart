import 'package:flutter/material.dart';
import 'stock_movement_form_screen.dart';
import 'issuing_form_screen.dart';
import 'transfer_form_screen.dart';
import 'package:erp_app/utils/stock_utils.dart'; // ใช้งาน movementLog

class StockMovementListScreen extends StatefulWidget {
  const StockMovementListScreen({super.key});
  @override
  State<StockMovementListScreen> createState() => _StockMovementListScreenState();
}

class _StockMovementListScreenState extends State<StockMovementListScreen> {
  String searchText = "";

  // ใช้ "" แทนค่า null ใน dropdown
  final typeOptions = [
    {"value": "", "label": "ทั้งหมด"},
    {"value": "IN", "label": "รับเข้า"},
    {"value": "OUT", "label": "จ่ายออก"},
    {"value": "TRANSFER", "label": "โอนคลัง"},
  ];
  String filterType = "";

  @override
  Widget build(BuildContext context) {
    // ดึง movementLog จาก stock_utils.dart
    final movements = List<Map<String, dynamic>>.from(movementLog);

    // ฟิลเตอร์ทั้งประเภทและค้นหา
    final filtered = movements.where((mv) {
      final matchType = filterType.isEmpty || mv["type"] == filterType;
      if (!matchType) return false;
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return mv.values.whereType<String>().any(
        (v) => v.toLowerCase().contains(q),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("รับ/จ่าย/โอนสินค้า")),
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
                    onChanged: (val) => setState(() => filterType = val ?? ""),
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: color.withOpacity(0.15),
                            child: Icon(iconData, color: color),
                          ),
                          title: Text(
                            "${mv["productName"] ?? mv["product"]}  (${mv["qty"]} ${mv["unit"] ?? ""})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "ประเภท: $label  |  เลขที่: ${mv["docNo"] ?? "-"}",
                              ),
                              Text(
                                "คลัง: ${mv["warehouse"] ?? "-"}  |  วันที่: ${mv["date"] ?? "-"}",
                              ),
                              if ((mv["remark"] ?? "").toString().isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 2),
                                  child: Text(
                                    "หมายเหตุ: ${mv["remark"]}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
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
                                      StockMovementFormScreen(movement: mv),
                                ),
                              );
                              setState(() {});
                            },
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    StockMovementFormScreen(movement: mv),
                              ),
                            );
                            setState(() {});
                          },
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton.extended(
            heroTag: "issue",
            icon: const Icon(Icons.remove_shopping_cart),
            label: const Text("จ่ายสินค้าออก"),
            backgroundColor: Colors.redAccent,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const IssuingFormScreen()),
              );
              setState(() {}); // refresh stock/log
            },
          ),
          const SizedBox(height: 14),
          FloatingActionButton.extended(
            heroTag: "transfer",
            icon: const Icon(Icons.compare_arrows),
            label: const Text("โอนสินค้า"),
            backgroundColor: Colors.blueAccent,
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StockTransferFormScreen(),
                ),
              );
              setState(() {});
            },
          ),
          const SizedBox(height: 14),
          FloatingActionButton.extended(
            heroTag: "add",
            icon: const Icon(Icons.add),
            label: const Text("รับ/จ่าย/โอนใหม่"),
            onPressed: () async {
              final newMv = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StockMovementFormScreen(),
                ),
              );
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
