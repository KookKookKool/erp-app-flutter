import 'package:flutter/material.dart';
import 'employee_edit_screen.dart';

class EmployeeDetailScreen extends StatefulWidget {
  final Map<String, dynamic> employee;
  final ValueChanged<Map<String, dynamic>> onUpdate;
  final VoidCallback onDelete;

  const EmployeeDetailScreen({
    super.key,
    required this.employee,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  State<EmployeeDetailScreen> createState() => _EmployeeDetailScreenState();
}

class _EmployeeDetailScreenState extends State<EmployeeDetailScreen> {
  late Map<String, dynamic> emp;

  @override
  void initState() {
    emp = Map<String, dynamic>.from(widget.employee);
    super.initState();
  }

  void _editEmp() async {
    final updated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployeeEditScreen(employee: emp)),
    );
    if (updated != null) {
      setState(() => emp = updated);
      widget.onUpdate(updated);
    }
  }

  void _confirmDelete() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("ลบพนักงาน?"),
        content: Text("ยืนยันลบข้อมูลของ ${emp['name']}?"),
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
    if (ok == true) {
      widget.onDelete();
    }
  }

  @override
  Widget build(BuildContext context) {
    // <<-- ส่วนนี้เพิ่มสำหรับ attendance
    String checkIn = emp['attendance']?['checkIn'] ?? "ยังไม่ได้ลงเวลา";
    String checkOut = emp['attendance']?['checkOut'] ?? "ยังไม่ได้ลงเวลา";

    return Scaffold(
      appBar: AppBar(
        title: Text("โปรไฟล์พนักงาน"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            tooltip: "ลบพนักงาน",
            onPressed: _confirmDelete,
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: "แก้ไขข้อมูล",
            onPressed: _editEmp,
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(32),
        children: [
          Center(
            child: CircleAvatar(
              backgroundImage: NetworkImage(emp['profilePic']),
              radius: 56,
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              '${emp['empId']} • ${emp['name']} (${emp['nickname']})',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              '${emp['level']}  |  ${emp['position']}',
              style: const TextStyle(fontSize: 18),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(leading: const Icon(Icons.email), title: Text(emp['email'])),
          ListTile(leading: const Icon(Icons.phone), title: Text(emp['phone'])),
          const Divider(height: 36),
          ListTile(
            leading: const Icon(Icons.login),
            title: Text("เวลาเข้างาน: $checkIn"),
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: Text("เวลาออกงาน: $checkOut"),
          ),
        ],
      ),
    );
  }
}
