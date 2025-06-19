import 'package:flutter/material.dart';
import 'receiving_form_screen.dart';
import 'package:erp_app/utils/mock_data.dart';

class ReceivingListScreen extends StatefulWidget {
  const ReceivingListScreen({super.key});

  @override
  State<ReceivingListScreen> createState() => _ReceivingListScreenState();
}

class _ReceivingListScreenState extends State<ReceivingListScreen> {
  String searchText = "";

  // PO ที่ “รับครบ” หรือ “รับบางส่วน” เท่านั้น = มีประวัติรับเข้า
  List<Map<String, dynamic>> get receiptList => mockPOList
      .where((po) => po["status"] == "รับบางส่วน" || po["status"] == "รับครบ")
      .toList();

  // PO ที่รับยังไม่ครบ (เอาไว้ให้เลือกตอนจะ “รับสินค้าเข้าใหม่”)
  List<Map<String, dynamic>> get receivablePOs => mockPOList
      .where(
        (po) =>
            po["status"] == "อนุมัติ" ||
            (po["status"] == "รับบางส่วน" &&
                (po["items"] as List).any(
                  (item) => (item["received"] ?? 0) < item["qty"],
                )),
      )
      .toList();

  void _startReceivingNew() async {
    if (receivablePOs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("ไม่มีใบสั่งซื้อที่สามารถรับเข้าได้")),
      );
      return;
    }
    // Popup ให้เลือก PO ก่อน
    Map<String, dynamic>? selectedPO = await showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text("เลือก PO ที่จะรับเข้า"),
        children: receivablePOs
            .map(
              (po) => SimpleDialogOption(
                onPressed: () => Navigator.pop(context, po),
                child: Text(
                  "${po["poNo"]} - ${po["supplier"]} (${po["status"]})",
                ),
              ),
            )
            .toList(),
      ),
    );
    if (selectedPO != null) {
      final result = await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => ReceivingFormScreen(po: selectedPO)),
      );
      if (result != null && result is Map<String, dynamic>) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = receiptList.where((rc) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return [
        rc["poNo"] ?? "",
        rc["supplier"] ?? "",
        rc["warehouse"] ?? "",
        rc["status"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("รับสินค้าเข้าคลัง (Receiving)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (เลขที่รับเข้า/PO, Supplier, คลัง ฯลฯ)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
          ),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูล"))
                : ListView.builder(
                    padding: const EdgeInsets.all(18),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final rc = filtered[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 14),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.deepPurple,
                            child: Icon(Icons.inventory_2, color: Colors.white),
                          ),
                          title: Text(
                            "PO: ${rc["poNo"]} (${rc["status"] ?? ""})",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Supplier: ${rc["supplier"] ?? "-"}"),
                              Text("คลัง: ${rc["warehouse"] ?? "-"}"),
                              Text("วันที่: ${rc["date"] ?? "-"}"),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReceivingFormScreen(po: rc),
                                ),
                              );
                              if (result != null &&
                                  result is Map<String, dynamic>) {
                                setState(() {}); // อัปเดตสถานะจาก mockPOList
                              }
                            },
                          ),
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ReceivingFormScreen(po: rc),
                              ),
                            );
                            if (result != null &&
                                result is Map<String, dynamic>) {
                              setState(() {});
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
        onPressed: _startReceivingNew,
      ),
    );
  }
}
