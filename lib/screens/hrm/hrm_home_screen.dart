import 'package:flutter/material.dart';
import 'employee/employee_manage_screen.dart';
import 'attendance/attendance_report_screen.dart';

class HRMHomeScreen extends StatelessWidget {
  const HRMHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(
              title: const Text("Human Resource Management"),
              centerTitle: true,
            )
          : null,
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Padding รอบ GridView
        child: LayoutBuilder(
          builder: (context, constraints) {
            // รับความกว้างสูงสุดที่ GridView สามารถใช้ได้
            final double availableWidth = constraints.maxWidth;

            int crossAxisCount;
            double mainAxisSpacing;
            double crossAxisSpacing;

            // กำหนดเงื่อนไขตามขนาดหน้าจอ (ตัวอย่าง breakpoint)
            if (availableWidth < 600) {
              // หน้าจอขนาดเล็ก (เช่น โทรศัพท์มือถือ)
              crossAxisCount = 2;
              mainAxisSpacing = 16.0;
              crossAxisSpacing = 16.0;
            } else if (availableWidth < 900) {
              // หน้าจอขนาดกลาง (เช่น แท็บเล็ตแนวตั้ง)
              crossAxisCount = 3;
              mainAxisSpacing = 24.0;
              crossAxisSpacing = 24.0;
            } else {
              // หน้าจอขนาดใหญ่ (เช่น แท็บเล็ตแนวนอน หรือเดสก์ท็อป)
              crossAxisCount = 4; // หรือ 3 ตามที่คุณต้องการ
              mainAxisSpacing = 32.0;
              crossAxisSpacing = 32.0;
            }
            double maxCardWidth = 250.0;

            return GridView.count(
              crossAxisCount: crossAxisCount,
              mainAxisSpacing: mainAxisSpacing,
              crossAxisSpacing: crossAxisSpacing,
              children: [
                _HRMModuleIcon(
                  icon: Icons.badge,
                  label: "จัดการพนักงาน",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const EmployeeManageScreen(),
                    ),
                  ),
                ),
                _HRMModuleIcon(
                  icon: Icons.assignment_turned_in,
                  label: "รายงานการเข้างาน",
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const AttendanceReportScreen(),
                    ),
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
                          const SnackBar(
                            content: Text(
                              "โมดูล Payroll/เงินเดือน กำลังอัพเดท",
                            ),
                          ),
                        );
                      },
                    ),
                    Positioned(
                      left: 0,
                      top: 0,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
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
            );
          },
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
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
