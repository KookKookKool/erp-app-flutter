import 'package:flutter/material.dart';

class ProductFormScreen extends StatefulWidget {
  final Map<String, dynamic>? product;
  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _nameController = TextEditingController();
  final _categoryController = TextEditingController();
  final _unitController = TextEditingController();
  final _stockController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _codeController.text = widget.product!["code"] ?? "";
      _nameController.text = widget.product!["name"] ?? "";
      _categoryController.text = widget.product!["category"] ?? "";
      _unitController.text = widget.product!["unit"] ?? "";
      _stockController.text = widget.product!["stock"]?.toString() ?? "";
      _warehouseController.text = widget.product!["warehouse"] ?? "";
      _remarkController.text = widget.product!["remark"] ?? "";
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    _categoryController.dispose();
    _unitController.dispose();
    _stockController.dispose();
    _warehouseController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "code": _codeController.text,
        "name": _nameController.text,
        "category": _categoryController.text,
        "unit": _unitController.text,
        "stock": int.tryParse(_stockController.text) ?? 0,
        "warehouse": _warehouseController.text,
        "remark": _remarkController.text,
      });
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบสินค้า"),
        content: const Text("ต้องการลบสินค้านี้ใช่หรือไม่?"),
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
      Navigator.pop(context, "delete");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.product != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขสินค้า" : "เพิ่มสินค้าใหม่"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบสินค้า",
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
                decoration: const InputDecoration(labelText: "รหัสสินค้า"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                enabled: !isEdit, // รหัสแก้ไม่ได้ถ้าแก้ไข
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "ชื่อสินค้า"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "หมวดหมู่"),
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: "หน่วยนับ"),
              ),
              TextFormField(
                controller: _stockController,
                decoration: const InputDecoration(labelText: "จำนวนคงเหลือ"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _warehouseController,
                decoration: const InputDecoration(labelText: "คลัง/สถานที่จัดเก็บ"),
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
