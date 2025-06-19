import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ReceivingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? po; // ต้องส่ง po object มาตรงๆ
  const ReceivingFormScreen({super.key, this.po});

  @override
  State<ReceivingFormScreen> createState() => _ReceivingFormScreenState();
}

class _ReceivingFormScreenState extends State<ReceivingFormScreen> {
  Map<String, dynamic>? selectedPO;
  final List<TextEditingController> qtyControllers = [];

  @override
  void initState() {
    super.initState();
    // มองหา PO object จริงใน mockPOList ด้วย poNo ทุกครั้ง (เพื่ออัปเดตข้ามหน้า)
    if (widget.po != null) {
      final poNo = widget.po!["poNo"];
      selectedPO = mockPOList.firstWhere((po) => po["poNo"] == poNo, orElse: () => {});
      qtyControllers.clear();
      for (final item in selectedPO!["items"]) {
        int maxCanReceive = item["qty"] - (item["received"] ?? 0);
        qtyControllers.add(
          TextEditingController(text: maxCanReceive.toString()),
        );
      }
    }
  }

  @override
  void dispose() {
    for (final c in qtyControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void save() {
    if (selectedPO == null) return;

    bool receivedAll = true;

    for (int i = 0; i < selectedPO!["items"].length; i++) {
      final item = selectedPO!["items"][i];
      final maxCanReceive = item["qty"] - (item["received"] ?? 0);
      final receiveNow = int.tryParse(qtyControllers[i].text) ?? 0;

      // Validate
      if (receiveNow < 0 || receiveNow > maxCanReceive) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("จำนวนรับของ ${item["name"]} ไม่ถูกต้อง")),
        );
        return;
      }
      item["received"] = (item["received"] ?? 0) + receiveNow;
      if (item["received"] < item["qty"]) receivedAll = false;
    }

    // --- Update PO status ---
    selectedPO!["status"] = receivedAll ? "รับครบ" : "รับบางส่วน";

    Navigator.pop(context, selectedPO);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedPO == null) {
      return Scaffold(
        appBar: AppBar(title: const Text("รับสินค้าเข้าคลัง")),
        body: const Center(child: Text("ไม่พบข้อมูล PO")),
      );
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("รับสินค้า (PO: ${selectedPO!["poNo"]})"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("ซัพพลายเออร์: ${selectedPO!["supplier"]}"),
            Text("คลังรับเข้า: ${selectedPO!["warehouse"]}"),
            Text("สถานะเดิม: ${selectedPO!["status"]}"),
            const Divider(),
            const Text(
              "รับสินค้าเข้า (กรอกจำนวนที่ต้องการรับ)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...List.generate(selectedPO!["items"].length, (i) {
              final item = selectedPO!["items"][i];
              final already = item["received"] ?? 0;
              final maxCanReceive = item["qty"] - already;
              return Card(
                child: ListTile(
                  title: Text("${item["name"]} (${item["qty"]} ${item["unit"]})"),
                  subtitle: Text("รับแล้ว $already/${item["qty"]} | เหลือรับอีก $maxCanReceive"),
                  trailing: SizedBox(
                    width: 80,
                    child: TextFormField(
                      controller: qtyControllers[i],
                      decoration: const InputDecoration(
                        labelText: "รับเข้า",
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ),
              );
            }),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.save),
              label: const Text("บันทึก"),
              onPressed: save,
            ),
          ],
        ),
      ),
    );
  }
}
