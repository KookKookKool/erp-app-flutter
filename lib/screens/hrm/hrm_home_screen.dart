import 'package:flutter/material.dart';
import 'employee/employee_manage_screen.dart';
import 'attendance/attendance_report_screen.dart';

class HRMHomeScreen extends StatelessWidget {
  const HRMHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("เมนู HRM"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 32,
          crossAxisSpacing: 32,
          children: [
            _HRMModuleIcon(
              icon: Icons.badge,
              label: "จัดการพนักงาน",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const EmployeeManageScreen()),
              ),
            ),
            _HRMModuleIcon(
              icon: Icons.assignment_turned_in,
              label: "รายงานการเข้างาน",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AttendanceReportScreen()),
              ),
            ),
            // Payroll Module with "Coming soon"
            Stack(
              children: [
                _HRMModuleIcon(
                  icon: Icons.payments,
                  label: "เงินเดือน\n(กำลังอัพเดท)", // \n เพื่อจัดกึ่งกลาง
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("โมดูล Payroll/เงินเดือน กำลังอัพเดท")),
                    );
                  },
                ),
                Positioned(
                  left: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.orange.shade300,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Coming soon",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HRMModuleIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _HRMModuleIcon({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.blue[100],
              child: Icon(icon, size: 40, color: Colors.blue[900]),
            ),
            const SizedBox(height: 16),
            // แก้ label ตรงกลาง รองรับ \n
            Center(
              child: Text(
                label,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
