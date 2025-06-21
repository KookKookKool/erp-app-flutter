import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class QuotationFormScreen extends StatefulWidget {
  final Map<String, dynamic>? quotation;
  const QuotationFormScreen({super.key, this.quotation});

  @override
  State<QuotationFormScreen> createState() => _QuotationFormScreenState();
}

class _QuotationFormScreenState extends State<QuotationFormScreen> {
  final _quotationNoController = TextEditingController();
  final _dateController = TextEditingController();
  String? selectedCustomerCode;
  final _totalController = TextEditingController();
  String status = "รอดำเนินการ";
  List<Map<String, dynamic>> items = [];

  @override
  void initState() {
    super.initState();
    if (widget.quotation != null) {
      _quotationNoController.text = widget.quotation!["quotationNo"] ?? "";
      _dateController.text = widget.quotation!["date"] ?? "";
      status = widget.quotation!["status"] ?? "รอดำเนินการ";
      _totalController.text = widget.quotation!["total"]?.toString() ?? "";
      final custName = widget.quotation!["customerName"];
      final match = mockCustomerList.firstWhere(
        (c) => c["name"] == custName,
        orElse: () => <String, dynamic>{},
      );
      selectedCustomerCode = match.isNotEmpty ? match["code"] : null;
      items = List<Map<String, dynamic>>.from(widget.quotation!["items"] ?? []);
    }
  }

  @override
  void dispose() {
    _quotationNoController.dispose();
    _dateController.dispose();
    _totalController.dispose();
    super.dispose();
  }

  void _save() {
    if (selectedCustomerCode == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("กรุณาเลือกลูกค้า")));
      return;
    }
    final customerName = mockCustomerList.firstWhere(
      (c) => c["code"] == selectedCustomerCode,
    )["name"];
    Navigator.pop(context, {
      "quotationNo": _quotationNoController.text,
      "date": _dateController.text,
      "status": status,
      "customerName": customerName,
      "total": double.tryParse(_totalController.text) ?? 0,
      "items": items,
    });
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบใบเสนอราคา"),
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
    if (confirm == true) Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.quotation != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขใบเสนอราคา" : "สร้างใบเสนอราคา"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: "ลบใบเสนอราคานี้",
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
                controller: _quotationNoController,
                decoration: const InputDecoration(
                  labelText: "เลขที่ Quotation",
                ),
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
                decoration: const InputDecoration(labelText: "ลูกค้า"),
                items: mockCustomerList
                    .map(
                      (c) => DropdownMenuItem<String>(
                        value: c["code"] as String,
                        child: Text("${c["name"]} (${c["code"]})"),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedCustomerCode = v),
                validator: (v) => v == null ? "เลือกลูกค้า" : null,
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
                  DropdownMenuItem(value: "สำเร็จ", child: Text("สำเร็จ")),
                  DropdownMenuItem(value: "ยกเลิก", child: Text("ยกเลิก")),
                ],
                onChanged: (v) => setState(() => status = v ?? "รอดำเนินการ"),
              ),
              const SizedBox(height: 24),
              // อนาคต: เพิ่มส่วนเลือกรายการสินค้า
              ElevatedButton(onPressed: _save, child: const Text("บันทึก")),
            ],
          ),
        ),
      ),
    );
  }
}
