import 'package:flutter/material.dart';

class LeaveApproveScreen extends StatefulWidget {
  final Map<String, dynamic> leaveRecord;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  const LeaveApproveScreen({super.key, required this.leaveRecord, required this.onUpdate});

  @override
  State<LeaveApproveScreen> createState() => _LeaveApproveScreenState();
}

class _LeaveApproveScreenState extends State<LeaveApproveScreen> {
  late Map<String, dynamic> leave;
  late String approveStatus;
  late bool deductSalary;
  late TextEditingController _remarkController;

  final List<Map<String, dynamic>> statusOptions = [
    {"value": "pending", "label": "รอดำเนินการ"},
    {"value": "approved", "label": "อนุมัติ"},
    {"value": "rejected", "label": "ไม่อนุมัติ"},
  ];

  @override
  void initState() {
    leave = Map<String, dynamic>.from(widget.leaveRecord['leave'] ?? {});
    approveStatus = leave['approveStatus'] ?? "pending";
    deductSalary = leave['deductSalary'] ?? false;
    _remarkController = TextEditingController(text: leave['remark'] ?? "");
    super.initState();
  }

  @override
  void dispose() {
    _remarkController.dispose();
    super.dispose();
  }

  void _save() {
    leave['approveStatus'] = approveStatus;
    leave['deductSalary'] = deductSalary;
    leave['remark'] = _remarkController.text;
    widget.onUpdate({"leave": leave});
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("อนุมัติการลา")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("สถานะการลา:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: approveStatus,
              items: statusOptions
                  .map((status) => DropdownMenuItem<String>(
                        value: status['value'],
                        child: Text(status['label']),
                      ))
                  .toList(),
              onChanged: (v) => setState(() => approveStatus = v ?? "pending"),
              isExpanded: true,
            ),
            const Divider(),
            Row(
              children: [
                Checkbox(
                  value: deductSalary,
                  onChanged: (v) => setState(() => deductSalary = v ?? false),
                ),
                const Text("หักเงิน"),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              controller: _remarkController,
              decoration: const InputDecoration(
                labelText: "หมายเหตุ",
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _save,
                child: const Text("บันทึก"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
