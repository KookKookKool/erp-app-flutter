import 'package:flutter/material.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class StockMovementFormScreen extends StatefulWidget {
  final Map<String, dynamic>? movement;
  const StockMovementFormScreen({super.key, this.movement});

  @override
  State<StockMovementFormScreen> createState() => _StockMovementFormScreenState();
}

class _StockMovementFormScreenState extends State<StockMovementFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String type = "IN";
  final _dateController = TextEditingController();
  final _docNoController = TextEditingController();
  final _warehouseController = TextEditingController();
  final _productController = TextEditingController();
  final _qtyController = TextEditingController();
  final _unitController = TextEditingController();
  final _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.movement != null) {
      type = widget.movement!["type"] ?? "IN";
      _dateController.text = widget.movement!["date"] ?? "";
      _docNoController.text = widget.movement!["docNo"] ?? "";
      _warehouseController.text = widget.movement!["warehouse"] ?? "";
      _productController.text = widget.movement!["product"] ?? "";
      _qtyController.text = widget.movement!["qty"]?.toString() ?? "";
      _unitController.text = widget.movement!["unit"] ?? "";
      _remarkController.text = widget.movement!["remark"] ?? "";
    }
  }

  @override
  void dispose() {
    _dateController.dispose();
    _docNoController.dispose();
    _warehouseController.dispose();
    _productController.dispose();
    _qtyController.dispose();
    _unitController.dispose();
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      Navigator.pop(context, {
        "type": type,
        "date": _dateController.text,
        "docNo": _docNoController.text,
        "warehouse": _warehouseController.text,
        "product": _productController.text,
        "qty": int.tryParse(_qtyController.text) ?? 0,
        "unit": _unitController.text,
        "remark": _remarkController.text,
      });
    }
  }

  void _delete() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("ยืนยันลบรายการ"),
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

  Future<void> _exportPDF() async {
    if (widget.movement == null) return;
    final mv = widget.movement!;
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("เอกสารรับ/จ่าย/โอนสินค้า", style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 14),
            pw.Text("เลขที่: ${mv['docNo'] ?? ''}"),
            pw.Text("วันที่: ${mv['date'] ?? ''}"),
            pw.Text("ประเภท: ${mv['type'] == 'IN' ? 'รับเข้า' : mv['type'] == 'OUT' ? 'จ่ายออก' : 'โอนคลัง'}"),
            pw.Text("คลัง: ${mv['warehouse'] ?? ''}"),
            pw.Text("สินค้า: ${mv['product'] ?? ''}"),
            pw.Text("จำนวน: ${mv['qty'] ?? ''} ${mv['unit'] ?? ''}"),
            if ((mv['remark'] ?? '').toString().isNotEmpty)
              pw.Text("หมายเหตุ: ${mv['remark']}"),
          ],
        ),
      ),
    );
    await Printing.layoutPdf(
      onLayout: (format) async => pdf.save(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.movement != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? "แก้ไขรายการ" : "รับ/จ่าย/โอนใหม่"),
        actions: isEdit
            ? [
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  tooltip: "ส่งออก PDF รายการนี้",
                  onPressed: _exportPDF,
                ),
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
              DropdownButtonFormField<String>(
                value: type,
                decoration: const InputDecoration(labelText: "ประเภท"),
                items: const [
                  DropdownMenuItem(value: "IN", child: Text("รับเข้า")),
                  DropdownMenuItem(value: "OUT", child: Text("จ่ายออก")),
                  DropdownMenuItem(value: "TRANSFER", child: Text("โอนคลัง")),
                ],
                onChanged: (v) => setState(() => type = v ?? "IN"),
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(labelText: "วันที่ (YYYY-MM-DD)"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _docNoController,
                decoration: const InputDecoration(labelText: "เลขที่เอกสาร"),
              ),
              TextFormField(
                controller: _warehouseController,
                decoration: const InputDecoration(labelText: "คลัง/โกดัง"),
              ),
              TextFormField(
                controller: _productController,
                decoration: const InputDecoration(labelText: "สินค้า"),
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                controller: _qtyController,
                decoration: const InputDecoration(labelText: "จำนวน"),
                keyboardType: TextInputType.number,
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
