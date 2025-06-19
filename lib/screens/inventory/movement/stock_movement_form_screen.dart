import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class StockMovementFormScreen extends StatefulWidget {
  final Map<String, dynamic>? movement;
  const StockMovementFormScreen({super.key, this.movement});

  @override
  State<StockMovementFormScreen> createState() => _StockMovementFormScreenState();
}

class _StockMovementFormScreenState extends State<StockMovementFormScreen> {
  final _formKey = GlobalKey<FormState>();

  String type = "IN";
  String? selectedWarehouse;
  String? selectedProduct;
  final _dateController = TextEditingController();
  final _docNoController = TextEditingController();
  final _qtyController = TextEditingController();
  final _unitController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.movement != null) {
      final m = widget.movement!;
      type = m["type"] ?? "IN";
      _dateController.text = m["date"] ?? "";
      _docNoController.text = m["docNo"] ?? "";

      // set dropdown values as code
      selectedWarehouse = getWarehouseCodeByName(m["warehouse"]);
      selectedProduct = getProductCodeByName(m["product"]);

      _qtyController.text = m["qty"]?.toString() ?? "";
      _unitController.text = m["unit"] ?? "";
      _remarkController.text = m["remark"] ?? "";
    } else {
      // New movement - generate docNo
      type = "IN";
      _dateController.text = DateTime.now().toIso8601String().substring(0, 10);
      _docNoController.text = generateDocNo("IN");
      selectedWarehouse = null;
      selectedProduct = null;
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _docNoController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  // Helper for warehouse
  String? getWarehouseCodeByName(String? name) {
    if (name == null) return null;
    final found = mockWarehouseList.firstWhere(
      (w) => w["name"] == name,
      orElse: () => {},
    );
    return found["code"];
  }

  // Helper for product
  String? getProductCodeByName(String? name) {
    if (name == null) return null;
    final found = mockProductList.firstWhere(
      (p) => p["name"] == name,
      orElse: () => {},
    );
    return found["code"];
  }

  String? getWarehouseNameByCode(String? code) {
    if (code == null) return null;
    final found = mockWarehouseList.firstWhere(
      (w) => w["code"] == code,
      orElse: () => {},
    );
    return found["name"];
  }

  String? getProductNameByCode(String? code) {
    if (code == null) return null;
    final found = mockProductList.firstWhere(
      (p) => p["code"] == code,
      orElse: () => {},
    );
    return found["name"];
  }

  // DocNo generator
  String generateDocNo(String t) {
    // t = IN / OUT / TRANSFER
    final prefix = t == "IN"
        ? "IN"
        : t == "OUT"
            ? "OUT"
            : "TRF";
    // Year in short (eg. 24)
    final y = DateTime.now().year % 100;
    // หาเลขล่าสุด
    final all = mockMovementList
        .where((m) => (m["docNo"] ?? "").toString().startsWith(prefix + "-$y"))
        .toList();
    final nums = all
        .map((m) => int.tryParse(m["docNo"]?.toString().split('-').last ?? "0") ?? 0)
        .toList();
    final next = nums.isEmpty ? 1 : (nums.reduce((a, b) => a > b ? a : b) + 1);
    final docNo = "$prefix-$y${next.toString().padLeft(4, '0')}";
    // เช็คซ้ำ
    final exists = mockMovementList.any((m) => m["docNo"] == docNo);
    return exists ? "$prefix-$y${(next + 1).toString().padLeft(4, '0')}" : docNo;
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      final whName = getWarehouseNameByCode(selectedWarehouse);
      final pName = getProductNameByCode(selectedProduct);
      final result = {
        "type": type,
        "date": _dateController.text,
        "docNo": _docNoController.text,
        "warehouse": whName ?? "",
        "product": pName ?? "",
        "qty": int.tryParse(_qtyController.text) ?? 0,
        "unit": _unitController.text,
        "remark": _remarkController.text,
      };
      Navigator.pop(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.movement != null ? "แก้ไขรายการ" : "รับ/จ่าย/โอนใหม่"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(labelText: "ประเภท"),
                items: const [
                  DropdownMenuItem(value: "IN", child: Text("รับเข้า")),
                  DropdownMenuItem(value: "OUT", child: Text("จ่ายออก")),
                  DropdownMenuItem(value: "TRANSFER", child: Text("โอนคลัง")),
                ],
                onChanged: (v) {
                  setState(() {
                    type = v ?? "IN";
                    _docNoController.text = generateDocNo(type);
                  });
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "วันที่ (YYYY-MM-DD)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _docNoController,
                decoration: const InputDecoration(labelText: "เลขที่เอกสาร"),
                enabled: false,
              ),
              DropdownButtonFormField<String>(
                value: selectedWarehouse,
                isExpanded: true,
                decoration: const InputDecoration(labelText: "คลัง/โกดัง"),
                items: mockWarehouseList
                    .where((w) => w["code"] != null && w["name"] != null)
                    .map(
                      (w) => DropdownMenuItem<String>(
                        value: w["code"],
                        child: Text("${w["name"]} (${w["code"]})"),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedWarehouse = v),
                validator: (v) => v == null || v.isEmpty ? "เลือกคลัง/โกดัง" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedProduct,
                isExpanded: true,
                decoration: const InputDecoration(labelText: "สินค้า"),
                items: mockProductList
                    .where((p) => p["code"] != null && p["name"] != null)
                    .map(
                      (p) => DropdownMenuItem<String>(
                        value: p["code"],
                        child: Text("${p["name"]} (${p["code"]})"),
                      ),
                    )
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    selectedProduct = v;
                    // fill unit if exists
                    final found = mockProductList.firstWhere(
                        (p) => p["code"] == v,
                        orElse: () => {});
                    _unitController.text = found["unit"] ?? "";
                  });
                },
                validator: (v) => v == null || v.isEmpty ? "เลือกสินค้า" : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: "จำนวน"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: "หน่วย"),
              ),
              TextFormField(
                controller: _remarkController,
                decoration: const InputDecoration(labelText: "หมายเหตุ"),
                maxLines: 2,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text("บันทึก"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
