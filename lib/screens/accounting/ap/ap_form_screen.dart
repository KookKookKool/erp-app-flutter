import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class APFormScreen extends StatefulWidget {
  final Map<String, dynamic>? ap;
  const APFormScreen({super.key, this.ap});
  @override
  State<APFormScreen> createState() => _APFormScreenState();
}

class _APFormScreenState extends State<APFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _apNoController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();
  final _poNoController = TextEditingController();

  String? selectedSupplierCode;
  String status = "ค้างจ่าย";

  bool get isEdit => widget.ap != null;

  @override
  void initState() {
    super.initState();
    if (widget.ap != null) {
      _apNoController.text = widget.ap!["apNo"] ?? "";
      _dateController.text = widget.ap!["date"] ?? "";
      selectedSupplierCode = widget.ap!["supplier"] ?? "";
      _amountController.text = widget.ap!["amount"]?.toString() ?? "";
      _dueDateController.text = widget.ap!["dueDate"] ?? "";
      status = widget.ap!["status"] ?? "ค้างจ่าย";
      _poNoController.text = widget.ap!["poNo"] ?? "";
    }
  }

  @override
  void dispose() {
    _apNoController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _poNoController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "apNo": _apNoController.text,
        "date": _dateController.text,
        "supplier": selectedSupplierCode, // <-- รหัส supplier
        "amount": double.tryParse(_amountController.text) ?? 0.0,
        "dueDate": _dueDateController.text,
        "status": status,
        "poNo": _poNoController.text,
        // ...อื่นๆ
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขเจ้าหนี้" : "เพิ่มเจ้าหนี้"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _apNoController,
                decoration: const InputDecoration(labelText: "เลขที่ AP"),
                enabled: !isEdit,
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "วันที่ (YYYY-MM-DD)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedSupplierCode,
                decoration: const InputDecoration(labelText: "ซัพพลายเออร์"),
                items: mockSupplierList
                    .map((s) => DropdownMenuItem<String>(
                          value: s["code"],
                          child: Text(s["name"]),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => selectedSupplierCode = v),
                validator: (v) => v == null || v.isEmpty ? "เลือกซัพพลายเออร์" : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "ยอดเงิน (บาท)"),
                keyboardType: TextInputType.number,
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: "ครบกำหนด (YYYY-MM-DD)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _poNoController,
                decoration: const InputDecoration(labelText: "เลขที่ PO (ถ้ามี)"),
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: "สถานะ"),
                items: const [
                  DropdownMenuItem(value: "ค้างจ่าย", child: Text("ค้างจ่าย")),
                  DropdownMenuItem(value: "จ่ายแล้ว", child: Text("จ่ายแล้ว")),
                ],
                onChanged: (v) => setState(() => status = v ?? "ค้างจ่าย"),
              ),
              const SizedBox(height: 32),
              ElevatedButton(onPressed: _save, child: const Text("บันทึก")),
            ],
          ),
        ),
      ),
    );
  }
}
