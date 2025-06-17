import 'package:flutter/material.dart';
import 'stock_movement_form_screen.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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

  bool selectMode = false;
  Set<int> selectedIndexes = {};

  Future<void> _exportSelectedPDF() async {
    final pdf = pw.Document();
    final selected = selectedIndexes.isEmpty
        ? movements
        : [for (var i in selectedIndexes) movements[i]];

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("รายงานรับ/จ่าย/โอนสินค้า (เลือกหลายรายการ)",
                style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 12),
            pw.Table.fromTextArray(
              headers: [
                'วันที่',
                'เลขที่',
                'ประเภท',
                'คลัง',
                'สินค้า',
                'จำนวน',
                'หน่วย',
                'หมายเหตุ'
              ],
              data: selected
                  .map((mv) => [
                        mv['date'] ?? '',
                        mv['docNo'] ?? '',
                        mv['type'] == 'IN'
                            ? 'รับเข้า'
                            : mv['type'] == 'OUT'
                                ? 'จ่ายออก'
                                : 'โอนคลัง',
                        mv['warehouse'] ?? '',
                        mv['product'] ?? '',
                        mv['qty']?.toString() ?? '',
                        mv['unit'] ?? '',
                        mv['remark'] ?? '',
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              cellStyle: const pw.TextStyle(fontSize: 11),
              cellAlignment: pw.Alignment.centerLeft,
              cellHeight: 22,
            ),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
    // หลังส่งออก เสร็จสิ้นกลับโหมดปกติ
    setState(() {
      selectMode = false;
      selectedIndexes.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("รับ/จ่าย/โอนสินค้า"),
        actions: [
          if (!selectMode)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              tooltip: "เลือกหลายรายการเพื่อส่งออก PDF",
              onPressed: () {
                setState(() {
                  selectMode = true;
                  selectedIndexes.clear();
                });
              },
            ),
          if (selectMode)
            IconButton(
              icon: const Icon(Icons.close),
              tooltip: "ยกเลิกโหมดเลือก",
              onPressed: () {
                setState(() {
                  selectMode = false;
                  selectedIndexes.clear();
                });
              },
            ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: movements.length,
        itemBuilder: (context, i) {
          final mv = movements[i];
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
              leading: selectMode
                  ? Checkbox(
                      value: selectedIndexes.contains(i),
                      onChanged: (val) {
                        setState(() {
                          if (val == true) {
                            selectedIndexes.add(i);
                          } else {
                            selectedIndexes.remove(i);
                          }
                        });
                      },
                    )
                  : CircleAvatar(
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
              trailing: selectMode
                  ? null
                  : IconButton(
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
              onTap: selectMode
                  ? () {
                      setState(() {
                        if (selectedIndexes.contains(i)) {
                          selectedIndexes.remove(i);
                        } else {
                          selectedIndexes.add(i);
                        }
                      });
                    }
                  : () async {
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
      floatingActionButton: selectMode
          ? FloatingActionButton.extended(
              icon: const Icon(Icons.picture_as_pdf),
              label: Text("ส่งออก PDF (${selectedIndexes.length})"),
              backgroundColor: Colors.red,
              onPressed:
                  selectedIndexes.isEmpty ? null : _exportSelectedPDF,
            )
          : FloatingActionButton.extended(
              icon: const Icon(Icons.add),
              label: const Text("รับ/จ่าย/โอนใหม่"),
              onPressed: () async {
                final newMv = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const StockMovementFormScreen()),
                );
                if (newMv != null) {
                  setState(() => movements.add(newMv));
                }
              },
            ),
    );
  }
}
