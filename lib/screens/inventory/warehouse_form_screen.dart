import 'package:flutter/material.dart';

class WarehouseFormScreen extends StatefulWidget {
  final Map<String, dynamic>? warehouse;
  const WarehouseFormScreen({super.key, this.warehouse});

  @override
  State<WarehouseFormScreen> createState() => _WarehouseFormScreenState();
}

class _WarehouseFormScreenState extends State<WarehouseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.warehouse != null) {
      _codeController.text = widget.warehouse!["code"] ?? "";
      _nameController.text = widget.warehouse!["name"] ?? "";
      _locationController.text = widget.warehouse!["location"] ?? "";
      _remarkController.text = widget.warehouse!["remark"] ?? "";
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "code": _codeController.text,
        "name": _nameController.text,
        "location": _locationController.text,
        "remark": _remarkController.text,
      });
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบคลัง/โกดัง"),
        content: const Text("ต้องการลบคลังนี้ใช่หรือไม่?"),
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
    final isEdit = widget.warehouse != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขคลัง/โกดัง" : "เพิ่มคลัง/โกดัง"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบคลังนี้",
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
                controller: _codeController,
                decoration: const InputDecoration(labelText: "รหัสคลัง"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                enabled: !isEdit, // รหัสแก้ไม่ได้ถ้าแก้ไข
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "ชื่อคลัง/โกดัง"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: "ที่ตั้ง/สถานที่"),
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
