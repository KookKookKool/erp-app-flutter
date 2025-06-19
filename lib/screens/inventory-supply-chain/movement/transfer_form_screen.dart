import 'package:flutter/material.dart';
import 'package:erp_app/utils/stock_utils.dart'; // สมมติคุณมี utils stock

class StockTransferFormScreen extends StatefulWidget {
  const StockTransferFormScreen({super.key});

  @override
  State<StockTransferFormScreen> createState() =>
      _StockTransferFormScreenState();
}

class _StockTransferFormScreenState extends State<StockTransferFormScreen> {
  String? selectedProduct;
  String? sourceWarehouse = "คลังหลัก";
  String? destWarehouse = "คลังสาขา 1";
  int qtyToTransfer = 1;
  final _formKey = GlobalKey<FormState>();

  // mock warehouse list
  final List<String> warehouses = ["คลังหลัก", "คลังสาขา 1", "คลังสาขา 2"];

  @override
  Widget build(BuildContext context) {
    // ถ้าปลายทางซ้ำต้นทาง ป้องกันไม่ให้เลือกแบบนี้
    final destWarehouses = warehouses
        .where((w) => w != sourceWarehouse)
        .toList();

    return Scaffold(
      appBar: AppBar(title: const Text("โอนสินค้า (Transfer)")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: selectedProduct,
                decoration: const InputDecoration(
                  labelText: "เลือกสินค้า",
                  border: OutlineInputBorder(),
                ),
                items: productStock.map<DropdownMenuItem<String>>((p) {
                  return DropdownMenuItem(
                    value: p["code"],
                    child: Text(
                      "${p["name"]} (${p["code"]}) | คงเหลือ: ${p["qty"]}",
                    ),
                  );
                }).toList(),
                onChanged: (val) => setState(() => selectedProduct = val),
                validator: (val) => val == null ? "กรุณาเลือกสินค้า" : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: sourceWarehouse,
                      decoration: const InputDecoration(
                        labelText: "คลังต้นทาง",
                        border: OutlineInputBorder(),
                      ),
                      items: warehouses
                          .map(
                            (w) => DropdownMenuItem(value: w, child: Text(w)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() {
                        sourceWarehouse = val;
                        // รีเซ็ตคลังปลายทางถ้าเผลอเลือกซ้ำ
                        if (destWarehouse == sourceWarehouse) {
                          destWarehouse = null;
                        }
                      }),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.arrow_forward, size: 28),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: destWarehouse,
                      decoration: const InputDecoration(
                        labelText: "คลังปลายทาง",
                        border: OutlineInputBorder(),
                      ),
                      items: destWarehouses
                          .map(
                            (w) => DropdownMenuItem(value: w, child: Text(w)),
                          )
                          .toList(),
                      onChanged: (val) => setState(() => destWarehouse = val),
                      validator: (val) => val == null ? "เลือกปลายทาง" : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "จำนวนที่โอน",
                  border: OutlineInputBorder(),
                ),
                initialValue: qtyToTransfer.toString(),
                keyboardType: TextInputType.number,
                onChanged: (v) => qtyToTransfer = int.tryParse(v) ?? 1,
                validator: (v) {
                  if (v == null || v.isEmpty) return "ระบุจำนวน";
                  final stock = getStock(selectedProduct ?? "");
                  final num = int.tryParse(v) ?? 0;
                  if (num < 1) return "จำนวนต้องมากกว่า 0";
                  if (num > stock) return "คงเหลือไม่พอ (stock: $stock)";
                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.compare_arrows),
                  label: const Text("บันทึกการโอน"),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedProduct != null &&
                        sourceWarehouse != null &&
                        destWarehouse != null) {
                      // สมมติ function นี้อัปเดตสต็อก
                      final ok = transferStock(
                        selectedProduct!,
                        qtyToTransfer,
                        sourceWarehouse!,
                        destWarehouse!,
                      );
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("โอนสินค้าสำเร็จ!")),
                        );
                        Navigator.pop(context, {
                          "code": selectedProduct,
                          "qty": qtyToTransfer,
                          "from": sourceWarehouse,
                          "to": destWarehouse,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("โอนสินค้าไม่สำเร็จ (stock ไม่พอ)"),
                          ),
                        );
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
