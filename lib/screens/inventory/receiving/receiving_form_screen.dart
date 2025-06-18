import 'package:flutter/material.dart';

class ReceivingFormScreen extends StatefulWidget {
  final Map<String, dynamic>? receipt;
  const ReceivingFormScreen({super.key, this.receipt});

  @override
  State<ReceivingFormScreen> createState() => _ReceivingFormScreenState();
}

class _ReceivingFormScreenState extends State<ReceivingFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _receiveNoController = TextEditingController();
  final _dateController = TextEditingController();
  final _poNoController = TextEditingController();
  final _supplierController = TextEditingController();
  final _warehouseController = TextEditingController();
  String status = "รับครบ";
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    if (widget.receipt != null) {
      _receiveNoController.text = widget.receipt!["receiveNo"] ?? "";
      _dateController.text = widget.receipt!["date"] ?? "";
      _poNoController.text = widget.receipt!["poNo"] ?? "";
      _supplierController.text = widget.receipt!["supplier"] ?? "";
      _warehouseController.text = widget.receipt!["warehouse"] ?? "";
      status = widget.receipt!["status"] ?? "รับครบ";
      items = List<Map<String, dynamic>>.from(widget.receipt!["items"] ?? []);
    }
  }

  @override
  void dispose() {
    _receiveNoController.dispose();
    _dateController.dispose();
    _poNoController.dispose();
    _supplierController.dispose();
    _warehouseController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate() && items.isNotEmpty) {
      Navigator.pop(context, {
        "receiveNo": _receiveNoController.text,
        "date": _dateController.text,
        "poNo": _poNoController.text,
        "supplier": _supplierController.text,
        "warehouse": _warehouseController.text,
        "items": items,
        "status": status,
      });
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบรายการรับสินค้า"),
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
    final isEdit = widget.receipt != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขรับสินค้าเข้า" : "รับสินค้าเข้าใหม่"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบรายการนี้",
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
                controller: _receiveNoController,
                decoration: const InputDecoration(labelText: "เลขที่รับเข้า"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
                enabled: !isEdit,
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "วันที่ (YYYY-MM-DD)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _poNoController,
                decoration: const InputDecoration(labelText: "เลขที่ใบสั่งซื้อ (PO)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(labelText: "Supplier"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _warehouseController,
                decoration: const InputDecoration(labelText: "คลัง"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              DropdownButtonFormField<String>(
                value: status,
                decoration: const InputDecoration(labelText: "สถานะ"),
                items: const [
                  DropdownMenuItem(value: "รับครบ", child: Text("รับครบ")),
                  DropdownMenuItem(value: "รับบางส่วน", child: Text("รับบางส่วน")),
                ],
                onChanged: (v) => setState(() => status = v ?? "รับครบ"),
              ),
              const SizedBox(height: 16),
              const Text("รายการสินค้า", style: TextStyle(fontWeight: FontWeight.bold)),
              ...items.map((item) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  title: Text("${item["name"]} (${item["qty"]} ${item["unit"]})"),
                  subtitle: Text("รหัส: ${item["code"]}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      setState(() => items.remove(item));
                    },
                  ),
                ),
              )),
              const SizedBox(height: 6),
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("เพิ่มสินค้า"),
                onPressed: () async {
                  // mockup: กดจะเพิ่มสินค้าเทียม
                  setState(() {
                    items.add({
                      "code": "P00${items.length + 1}",
                      "name": "สินค้าใหม่",
                      "qty": 1,
                      "unit": "ชิ้น",
                    });
                  });
                },
              ),
              const SizedBox(height: 24),
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
