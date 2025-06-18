import 'package:flutter/material.dart';
import 'package:erp_app/utils/stock_utils.dart';

class ReceivingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? receipt; // (สำหรับ edit) ส่ง receipt เดิมมา
  const ReceivingFormScreen({super.key, this.receipt});

  @override
  State<ReceivingFormScreen> createState() => _ReceivingFormScreenState();
}

class _ReceivingFormScreenState extends State<ReceivingFormScreen> {
  // Mock PO list (จะ move ไป global หรือ provider/db ได้ในอนาคต)
  final List<Map<String, dynamic>> poList = [
    {
      "poNo": "PO-240001",
      "supplier": "บริษัท สมาร์ทซัพพลาย จำกัด",
      "warehouse": "คลังหลัก",
      "items": [
        {
          "code": "P001",
          "name": "สมุดโน๊ต A5",
          "qty": 10,
          "unit": "เล่ม",
          "received": 2,
        },
        {
          "code": "P002",
          "name": "ปากกาเจล",
          "qty": 20,
          "unit": "ด้าม",
          "received": 5,
        },
      ],
      "status": "อนุมัติ",
    },
    {
      "poNo": "PO-240002",
      "supplier": "รุ่งเรืองการค้า",
      "warehouse": "คลังสาขา 1",
      "items": [
        {
          "code": "P003",
          "name": "น้ำดื่ม",
          "qty": 50,
          "unit": "ขวด",
          "received": 0,
        },
      ],
      "status": "อนุมัติ",
    },
  ];

  String? selectedPoNo;
  Map<String, dynamic>? selectedPO;
  List<TextEditingController> qtyControllers = [];

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      selectedPoNo = widget.receipt!["poNo"];
      selectedPO = poList.firstWhere(
        (po) => po["poNo"] == selectedPoNo,
        orElse: () => {},
      );
      qtyControllers = [];
      if (widget.receipt!["items"] != null &&
          (widget.receipt!["items"] as List).isNotEmpty) {
        for (var item in widget.receipt!["items"]) {
          final receiveNow = item["receivedNow"] ?? 0;
          qtyControllers.add(
            TextEditingController(text: receiveNow.toString()),
          );
        }
      } else if (selectedPO != null) {
        // fallback: กรณีข้อมูล receipt ไม่มี items หรือแก้ไขข้อมูล PO
        for (var item in selectedPO!["items"]) {
          final remaining = item["qty"] - (item["received"] ?? 0);
          qtyControllers.add(TextEditingController(text: remaining.toString()));
        }
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

  void selectPO(String? poNo) {
    setState(() {
      selectedPoNo = poNo;
      selectedPO = poList.firstWhere((po) => po["poNo"] == poNo);
      for (var c in qtyControllers) {
        c.dispose();
      }
      qtyControllers = [];
      for (var item in selectedPO!["items"]) {
        final remaining = item["qty"] - (item["received"] ?? 0);
        qtyControllers.add(TextEditingController(text: remaining.toString()));
      }
    });
  }

  void save() {
    if (selectedPO == null) return;
    final items = <Map<String, dynamic>>[];
    bool receivedAll = true;
    for (int i = 0; i < selectedPO!["items"].length; i++) {
      final item = selectedPO!["items"][i];
      final maxCanReceive = item["qty"] - (item["received"] ?? 0);
      final receiveNow = int.tryParse(qtyControllers[i].text) ?? 0;
      if (receiveNow > maxCanReceive || receiveNow < 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("จำนวนรับของ ${item["name"]} ไม่ถูกต้อง")),
        );
        return;
      }
      items.add({
        "code": item["code"],
        "name": item["name"],
        "qty": item["qty"],
        "unit": item["unit"],
        "received": (item["received"] ?? 0) + receiveNow,
        "receivedNow": receiveNow,
      });
      if ((item["received"] ?? 0) + receiveNow < item["qty"]) {
        receivedAll = false;
      }
    }
    // สถานะรับครบ/ไม่ครบ
    String status = receivedAll ? "รับครบ" : "รับบางส่วน";
    final data = {
      "poNo": selectedPO!["poNo"],
      "supplier": selectedPO!["supplier"],
      "warehouse": selectedPO!["warehouse"],
      "items": items,
      "status": status,
      "date": DateTime.now().toIso8601String().substring(0, 10),
    };
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("รับสินค้าเข้าคลังตาม PO")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            DropdownButtonFormField<String>(
              value: selectedPoNo,
              hint: const Text("เลือกใบสั่งซื้อ (PO) ที่อนุมัติ"),
              items: poList
                  .map(
                    (po) => DropdownMenuItem<String>(
                      value: po["poNo"],
                      child: Text("${po["poNo"]} - ${po["supplier"]}"),
                    ),
                  )
                  .toList(),
              onChanged: selectPO,
              decoration: const InputDecoration(
                labelText: "เลือก PO",
                border: OutlineInputBorder(),
              ),
            ),
            if (selectedPO != null) ...[
              const SizedBox(height: 16),
              Text("Supplier: ${selectedPO!["supplier"]}"),
              Text("คลังรับเข้า: ${selectedPO!["warehouse"]}"),
              const Divider(),
              const Text(
                "รายการสินค้า",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...List.generate(selectedPO!["items"].length, (i) {
                final item = selectedPO!["items"][i];
                final already = item["received"] ?? 0;
                final maxCanReceive = item["qty"] - already;
                return Card(
                  child: ListTile(
                    title: Text(
                      "${item["name"]} (${item["qty"]} ${item["unit"]})",
                    ),
                    subtitle: Text(
                      "รับแล้ว $already/${item["qty"]} | เหลือรับอีก $maxCanReceive",
                    ),
                    trailing: SizedBox(
                      width: 80,
                      child: TextFormField(
                        controller: qtyControllers.length > i
                            ? qtyControllers[i]
                            : TextEditingController(text: "0"),
                        decoration: const InputDecoration(labelText: "รับเข้า"),
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
          ],
        ),
      ),
    );
  }
}
