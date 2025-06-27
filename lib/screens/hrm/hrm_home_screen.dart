import 'package:flutter/material.dart';
import 'employee/employee_manage_screen.dart';
import 'attendance/attendance_report_screen.dart';

class HRMHomeScreen extends StatelessWidget {
  const HRMHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    // Responsive grid settings
    int crossAxisCount;
    double mainAxisSpacing;
    double crossAxisSpacing;
    final double availableWidth =
        MediaQuery.of(context).size.width - 48; // 24 padding x2
    if (availableWidth < 600) {
      crossAxisCount = 2;
      mainAxisSpacing = 16.0;
      crossAxisSpacing = 16.0;
    } else if (availableWidth < 900) {
      crossAxisCount = 3;
      mainAxisSpacing = 24.0;
      crossAxisSpacing = 24.0;
    } else {
      crossAxisCount = 4;
      mainAxisSpacing = 32.0;
      crossAxisSpacing = 32.0;
    }
    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700),
                      Color(0xFFFF8C00),
                      Color(0xFFFF4500),
                    ],
                    stops: [0.0, 0.7, 1.0],
                  ),
                ),
              ),
              title: const Text(
                "Human Resource Management",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  shadows: [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(100, 0, 0, 0),
                    ),
                  ],
                ),
              ),
              centerTitle: true,
              elevation: 0,
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFFFF3E0), Color(0xFFFFECB3), Color(0xFFFBE4C4)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: GridView.count(
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
              Stack(
                children: [
                  _HRMModuleIcon(
                    icon: Icons.payments,
                    label: "เงินเดือน\n(กำลังอัพเดท)",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "โมดูล Payroll/เงินเดือน กำลังอัพเดท",
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: Color(0xFFFF8C00),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
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
          ),
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
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: const Color(0xFFFFECB3),
              child: Icon(icon, size: 40, color: Color(0xFFFF8C00)),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF8B4513),
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
