import 'package:flutter/material.dart';
import 'employee_detail_screen.dart';
import 'employee_add_screen.dart';

class EmployeeManageScreen extends StatefulWidget {
  const EmployeeManageScreen({super.key});

  @override
  State<EmployeeManageScreen> createState() => _EmployeeManageScreenState();
}

class _EmployeeManageScreenState extends State<EmployeeManageScreen> {
  final List<Map<String, dynamic>> _employees = [
    {
      "empId": "EMP001",
      "name": "ศิริพร ใจดี",
      "nickname": "ฝ้าย",
      "level": "Senior",
      "position": "HR Manager",
      "email": "faijai@gmail.com",
      "phone": "0812345678",
      "profilePic": "https://i.pravatar.cc/300?img=5",
      "password": "123456",
    },
    {
      "empId": "EMP002",
      "name": "อนันต์ อาจดี",
      "nickname": "นัท",
      "level": "Staff",
      "position": "Programmer",
      "email": "anan@gmail.com",
      "phone": "0898765432",
      "profilePic": "https://i.pravatar.cc/300?img=2",
      "password": "654321",
    },
    // เพิ่ม mock พนักงานอื่นๆ ได้
  ];

  String _search = "";

  @override
  Widget build(BuildContext context) {
    // ฟิลเตอร์ข้อมูลตาม search
    final filtered = _employees.where((emp) {
      final q = _search.toLowerCase();
      return emp['name'].toLowerCase().contains(q) ||
          emp['empId'].toLowerCase().contains(q) ||
          emp['email'].toLowerCase().contains(q) ||
          emp['phone'].toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("รายชื่อพนักงาน"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: "เพิ่มพนักงาน",
            onPressed: () async {
              // ไปหน้าฟอร์มเพิ่มพนักงาน
              final newEmp = await Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmployeeAddScreen()),
              );
              if (newEmp != null) {
                setState(() {
                  _employees.add(newEmp);
                });
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "ค้นหา: ชื่อ, รหัส, อีเมล, เบอร์โทร",
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _search = v),
            ),
          ),
          Expanded(
            child: ListView.separated(
              itemCount: filtered.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final emp = filtered[i];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(emp['profilePic']),
                  ),
                  title: Text('${emp['name']} (${emp['nickname']})'),
                  subtitle: Text('${emp['level']} | ${emp['position']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.more_vert),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EmployeeDetailScreen(
                            employee: emp,
                            onUpdate: (updatedEmp) {
                              setState(() {
                                _employees[i] = updatedEmp;
                              });
                            },
                            onDelete: () {
                              setState(() {
                                _employees.removeAt(i);
                              });
                              Navigator.pop(context); // กลับไปหน้ารายชื่อ
                            },
                          ),
                        ),
                      );
                    },
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EmployeeDetailScreen(
                          employee: emp,
                          onUpdate: (updatedEmp) {
                            setState(() {
                              _employees[i] = updatedEmp;
                            });
                          },
                          onDelete: () {
                            setState(() {
                              _employees.removeAt(i);
                            });
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
