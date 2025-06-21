import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class IssuingFormScreen extends StatefulWidget {
  const IssuingFormScreen({super.key});

  @override
  State<IssuingFormScreen> createState() => _IssuingFormScreenState();
}

class _IssuingFormScreenState extends State<IssuingFormScreen> {
  String? selectedProduct;
  int qtyToIssue = 1;
  String warehouse = "คลังหลัก"; // สมมติ
  String issueRef = "";
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("จ่ายสินค้าออก (Issuing)")),
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
                items: mockProductList.map<DropdownMenuItem<String>>((p) {
                  return DropdownMenuItem<String>(
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
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "จำนวนที่จ่ายออก",
                  border: OutlineInputBorder(),
                ),
                initialValue: qtyToIssue.toString(),
                keyboardType: TextInputType.number,
                onChanged: (v) => qtyToIssue = int.tryParse(v) ?? 1,
                validator: (v) {
                  if (v == null || v.isEmpty) return "ระบุจำนวน";
                  final stock = getStock(selectedProduct ?? "");
                  final num = int.tryParse(v) ?? 0;
                  if (num < 1) return "จำนวนต้องมากกว่า 0";
                  if (num > stock) return "คงเหลือไม่พอ (stock: $stock)";
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: "อ้างอิงใบเบิก (Ref/เหตุผล)",
                  border: OutlineInputBorder(),
                ),
                onChanged: (v) => issueRef = v,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.save),
                  label: const Text("บันทึกการจ่ายออก"),
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        selectedProduct != null) {
                      final ok = issueProduct(
                        selectedProduct!,
                        qtyToIssue,
                        warehouse,
                        issueRef,
                      );
                      if (ok) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("จ่ายออกสำเร็จ!")),
                        );
                        Navigator.pop(context, {
                          "code": selectedProduct,
                          "qty": qtyToIssue,
                          "warehouse": warehouse,
                          "ref": issueRef,
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("จ่ายออกไม่สำเร็จ (stock ไม่พอ)"),
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
