import 'package:flutter/material.dart';

class LeaveRequestScreen extends StatefulWidget {
  final String empId;
  final String empName;
  const LeaveRequestScreen({
    super.key,
    required this.empId,
    required this.empName,
  });

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String leaveType = "ลากิจ";
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (startDate == null || endDate == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("กรุณากรอกข้อมูลให้ครบถ้วน")),
      );
      return;
    }
    Navigator.pop(context, {
      "date": startDate!.toIso8601String().substring(0, 10),
      "empId": widget.empId,
      "name": widget.empName,
      "status": "ลา",
      "leave": {
        "approveStatus": "pending",
        "deductSalary": false,
        "remark": _reasonController.text,
        "type": leaveType,
        "startDate": startDate,
        "endDate": endDate,
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ฟอร์มลางาน")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            Text("ชื่อ: ${widget.empName}", style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: leaveType,
              decoration: const InputDecoration(labelText: "ประเภทการลา"),
              items: [
                DropdownMenuItem(value: "ลากิจ", child: Text("ลากิจ")),
                DropdownMenuItem(value: "ลาป่วย", child: Text("ลาป่วย")),
                DropdownMenuItem(value: "ลาพักร้อน", child: Text("ลาพักร้อน")),
              ],
              onChanged: (v) => setState(() => leaveType = v ?? "ลากิจ"),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text("วันที่เริ่ม: ${startDate != null ? "${startDate!.day}/${startDate!.month}/${startDate!.year + 543}" : "-"}"),
              trailing: Icon(Icons.date_range),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 2),
                );
                if (picked != null) setState(() => startDate = picked);
              },
            ),
            ListTile(
              title: Text("วันที่สิ้นสุด: ${endDate != null ? "${endDate!.day}/${endDate!.month}/${endDate!.year + 543}" : "-"}"),
              trailing: Icon(Icons.date_range),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: startDate ?? DateTime.now(),
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 2),
                );
                if (picked != null) setState(() => endDate = picked);
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _reasonController,
              decoration: const InputDecoration(
                labelText: "เหตุผลในการลา",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _submit,
              child: const Text("ส่งคำขอลา"),
            )
          ],
        ),
      ),
    );
  }
}
