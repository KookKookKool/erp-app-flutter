import 'package:flutter/material.dart';

class SupplierFormScreen extends StatefulWidget {
  final Map<String, dynamic>? supplier;
  const SupplierFormScreen({super.key, this.supplier});

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.supplier != null) {
      _codeController.text = widget.supplier!["code"] ?? "";
      _nameController.text = widget.supplier!["name"] ?? "";
      _phoneController.text = widget.supplier!["phone"] ?? "";
      _emailController.text = widget.supplier!["email"] ?? "";
      _addressController.text = widget.supplier!["address"] ?? "";
      _remarkController.text = widget.supplier!["remark"] ?? "";
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "code": _codeController.text,
        "name": _nameController.text,
        "phone": _phoneController.text,
        "email": _emailController.text,
        "address": _addressController.text,
        "remark": _remarkController.text,
      });
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบซัพพลายเออร์"),
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
    final isEdit = widget.supplier != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขซัพพลายเออร์" : "เพิ่มซัพพลายเออร์"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบซัพพลายเออร์นี้",
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
                decoration: const InputDecoration(labelText: "รหัสซัพพลายเออร์"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                enabled: !isEdit, // รหัสแก้ไม่ได้ถ้าแก้ไข
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "ชื่อซัพพลายเออร์"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: "เบอร์โทร"),
                keyboardType: TextInputType.phone,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: "อีเมล"),
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _addressController,
                decoration: const InputDecoration(labelText: "ที่อยู่"),
                maxLines: 2,
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
