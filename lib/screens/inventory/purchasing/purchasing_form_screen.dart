import 'package:flutter/material.dart';

class PurchasingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? order;
  const PurchasingFormScreen({super.key, this.order});

  @override
  State<PurchasingFormScreen> createState() => _PurchasingFormScreenState();
}

class _PurchasingFormScreenState extends State<PurchasingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _poNoController = TextEditingController();
  final _dateController = TextEditingController();
  final _supplierController = TextEditingController();
  final _totalController = TextEditingController();
  String status = "รอดำเนินการ";
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.order != null) {
      _poNoController.text = widget.order!["poNo"] ?? "";
      _dateController.text = widget.order!["date"] ?? "";
      _supplierController.text = widget.order!["supplier"] ?? "";
      _totalController.text = widget.order!["total"]?.toString() ?? "";
      status = widget.order!["status"] ?? "รอดำเนินการ";
      _remarkController.text = widget.order!["remark"] ?? "";
    }
  }

  @override
  void dispose() {
    _poNoController.dispose();
    _dateController.dispose();
    _supplierController.dispose();
    _totalController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "poNo": _poNoController.text,
        "date": _dateController.text,
        "supplier": _supplierController.text,
        "total": int.tryParse(_totalController.text) ?? 0,
        "status": status,
        "remark": _remarkController.text,
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
    final isEdit = widget.order != null;
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
                decoration: const InputDecoration(labelText: "เลขที่ใบสั่งซื้อ"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                enabled: !isEdit, // แก้ไขเลขที่ไม่ได้
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "วันที่ (YYYY-MM-DD)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(labelText: "ซัพพลายเออร์"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
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
                  DropdownMenuItem(value: "รอดำเนินการ", child: Text("รอดำเนินการ")),
                  DropdownMenuItem(value: "อนุมัติ", child: Text("อนุมัติ")),
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
