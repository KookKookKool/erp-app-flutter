import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class PurchasingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? po;
  const PurchasingFormScreen({super.key, this.po}); // po อาจเป็น null

  @override
  State<PurchasingFormScreen> createState() => _PurchasingFormScreenState();
}

class _PurchasingFormScreenState extends State<PurchasingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _poNoController = TextEditingController();
  final _dateController = TextEditingController();
  final _totalController = TextEditingController();
  final _remarkController = TextEditingController();

  String status = "รอดำเนินการ";
  String? selectedSupplier;

  bool get isEdit => widget.po != null;

  @override
  void initState() {
    super.initState();
    if (widget.po != null) {
      _poNoController.text = widget.po!["poNo"] ?? "";
      _dateController.text = widget.po!["date"] ?? "";
      selectedSupplier = widget.po!["supplier"];
      _totalController.text = widget.po!["total"]?.toString() ?? "";
      // ตรวจสอบว่า status ตรงกับรายการใน dropdown
      final validStatuses = [
        "รอดำเนินการ",
        "อนุมัติ",
        "รับบางส่วน",
        "รับครบ",
        "ยกเลิก",
      ];
      final poStatus = widget.po!["status"] ?? "รอดำเนินการ";
      status = validStatuses.contains(poStatus) ? poStatus : "รอดำเนินการ";
      _remarkController.text = widget.po!["remark"] ?? "";
    }
  }

  @override
  void dispose() {
    _poNoController.dispose();
    _dateController.dispose();
    _totalController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "poNo": _poNoController.text,
        "date": _dateController.text,
        "supplier": selectedSupplier,
        "total": int.tryParse(_totalController.text) ?? 0,
        "status": status,
        "remark": _remarkController.text,
        // เพิ่ม fields อื่นๆที่จำเป็น เช่น items, warehouse
      });
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบใบสั่งซื้อ"),
        content: const Text("ต้องการลบใช่หรือไม่?"),
        actions: [
          TextButton(
            child: const Text("ยกเลิก"),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text("ลบ", style: TextStyle(color: Colors.red)),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirm == true) {
      Navigator.pop(context, 'delete');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขใบสั่งซื้อ" : "สร้างใบสั่งซื้อ"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบใบสั่งซื้อนี้",
                  onPressed: _delete,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _poNoController,
                decoration: const InputDecoration(
                  labelText: "เลขที่ใบสั่งซื้อ",
                ),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                enabled: !isEdit, // แก้ไขเลขที่ไม่ได้ถ้าแก้ไข
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "วันที่ (YYYY-MM-DD)",
                ),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedSupplier,
                decoration: const InputDecoration(labelText: "ซัพพลายเออร์"),
                isExpanded: true,
                items: mockSupplierList.map((s) {
                  return DropdownMenuItem<String>(
                    value: s["name"],
                    child: Text(s["name"]),
                  );
                }).toList(),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                onChanged: (val) => setState(() => selectedSupplier = val),
              ),
              TextFormField(
                controller: _totalController,
                decoration: const InputDecoration(labelText: "ยอดรวม (บาท)"),
                keyboardType: TextInputType.number,
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: "สถานะ"),
                items: const [
                  DropdownMenuItem(
                    value: "รอดำเนินการ",
                    child: Text("รอดำเนินการ"),
                  ),
                  DropdownMenuItem(value: "อนุมัติ", child: Text("อนุมัติ")),
                  DropdownMenuItem(
                    value: "รับบางส่วน",
                    child: Text("รับบางส่วน"),
                  ),
                  DropdownMenuItem(value: "รับครบ", child: Text("รับครบ")),
                  DropdownMenuItem(value: "ยกเลิก", child: Text("ยกเลิก")),
                ],
                onChanged: (v) => setState(() => status = v ?? "รอดำเนินการ"),
              ),
              TextFormField(
                controller: _remarkController,
                decoration: const InputDecoration(labelText: "หมายเหตุ"),
                maxLines: 2,
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
