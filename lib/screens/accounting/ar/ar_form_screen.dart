import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ARFormScreen extends StatefulWidget {
  final Map<String, dynamic>? ar;
  const ARFormScreen({super.key, this.ar});

  @override
  State<ARFormScreen> createState() => _ARFormScreenState();
}

class _ARFormScreenState extends State<ARFormScreen> {
  final _arNoController = TextEditingController();
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _dueDateController = TextEditingController();
  String status = "ค้างรับ";
  String? selectedCustomerCode;
  final _soNoController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.ar != null) {
      _arNoController.text = widget.ar!["arNo"] ?? "";
      _dateController.text = widget.ar!["date"] ?? "";
      _amountController.text = widget.ar!["amount"]?.toString() ?? "";
      _dueDateController.text = widget.ar!["dueDate"] ?? "";
      status = widget.ar!["status"] ?? "ค้างรับ";
      _soNoController.text = widget.ar!["soNo"] ?? "";

      // ใช้ code ตรงๆ
      selectedCustomerCode = widget.ar!["customer"];
      // ถ้าไม่มี code ใน mockCustomerList ให้เซตเป็น null
      if (selectedCustomerCode == null ||
          !mockCustomerList.any((c) => c["code"] == selectedCustomerCode)) {
        selectedCustomerCode = null;
      }
    }
  }

  @override
  void dispose() {
    _arNoController.dispose();
    _dateController.dispose();
    _amountController.dispose();
    _dueDateController.dispose();
    _soNoController.dispose();
    super.dispose();
  }

  void _save() {
    if (selectedCustomerCode == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณาเลือกลูกหนี้")));
      return;
    }
    Navigator.pop(context, {
      "arNo": _arNoController.text,
      "date": _dateController.text,
      "amount": double.tryParse(_amountController.text) ?? 0,
      "dueDate": _dueDateController.text,
      "status": status,
      "customer": selectedCustomerCode, // ← ใช้ code
      "soNo": _soNoController.text,
    });
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบลูกหนี้"),
        content: const Text("ต้องการลบข้อมูลนี้ใช่หรือไม่?"),
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
    final isEdit = widget.ar != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขลูกหนี้" : "เพิ่มลูกหนี้"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบลูกหนี้นี้",
                  onPressed: _delete,
                ),
              ]
            : null,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          child: ListView(
            children: [
              TextFormField(
                controller: _arNoController,
                decoration: const InputDecoration(labelText: "เลขที่ AR"),
                enabled: !isEdit,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  labelText: "วันที่ (YYYY-MM-DD)",
                ),
              ),
              DropdownButtonFormField<String>(
                value: selectedCustomerCode,
                decoration: const InputDecoration(
                  labelText: "ลูกหนี้/Customer",
                ),
                items: mockCustomerList
                    .map<DropdownMenuItem<String>>(
                      (c) => DropdownMenuItem(
                        value: c["code"],
                        child: Text("${c["name"]} (${c["code"]})"),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedCustomerCode = v),
                validator: (v) =>
                    v == null || v.isEmpty ? "เลือกลูกหนี้" : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: "ยอดเงิน (บาท)"),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _dueDateController,
                decoration: const InputDecoration(labelText: "ครบกำหนดชำระ"),
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: "สถานะ"),
                items: const [
                  DropdownMenuItem(value: "ค้างรับ", child: Text("ค้างรับ")),
                  DropdownMenuItem(
                    value: "รับเงินแล้ว",
                    child: Text("รับเงินแล้ว"),
                  ),
                ],
                onChanged: (v) => setState(() => status = v ?? "ค้างรับ"),
              ),
              TextFormField(
                controller: _soNoController,
                decoration: const InputDecoration(labelText: "เลขที่ SO"),
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
