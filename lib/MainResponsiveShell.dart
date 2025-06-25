// lib/screens/home/main_responsive_shell.dart
import 'package:flutter/material.dart';
import 'package:erp_app/widgets/app_drawer.dart';
import 'package:erp_app/screens/home/myprofile_screen.dart';
import 'package:erp_app/screens/hrm/hrm_home_screen.dart';
import 'package:erp_app/screens/inventory-supply-chain/inventory_home_screen.dart';
import 'package:erp_app/screens/accounting/accounting_home_screen.dart';
import 'package:erp_app/screens/sales-crm/sales_home_screen.dart';
import 'package:erp_app/screens/dashboard/dashboard_home_screen.dart';
import 'package:erp_app/screens/project-workflow/project_home_screen.dart';

class MainResponsiveShell extends StatefulWidget {
  const MainResponsiveShell({super.key});

  @override
  State<MainResponsiveShell> createState() => _MainResponsiveShellState();
}

class _MainResponsiveShellState extends State<MainResponsiveShell> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    MyProfileScreen(),
    HRMHomeScreen(),
    InventoryHomeScreen(),
    AccountingHomeScreen(),
    SalesHomeScreen(),
    DashboardHomeScreen(),
    ProjectHomeScreen(),
  ];

  final List<String> _titles = [
    "My Profile",
    "HR Management",
    "Inventory & Supply Chain",
    "Accounting / Finance",
    "Sales / CRM",
    "Dashboard & Analytics",
    "Project / Workflow",
  ];

  void _onMenuTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
    // ปิด Drawer อัตโนมัติถ้าจอเล็ก
    if (MediaQuery.of(context).size.width < 900) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      // --- ปรับสี AppBar สำหรับจอเล็ก ---
      // AppBar จะแสดงเฉพาะเมื่อไม่ใช่จอใหญ่ (isLargeScreen เป็น false)
      appBar: isLargeScreen
          ? null
          : AppBar(
              iconTheme: const IconThemeData(color: Colors.red),
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700), // Warm Yellow
                      Color(0xFFFF8C00), // Vibrant Orange
                      Color(0xFFFF4500), // Deep Red-Orange
                    ],
                    stops: [0.0, 0.7, 1.0],
                  ),
                ),
              ),
              title: Text(
                _titles[_selectedIndex],
                style: const TextStyle(
                  color: Colors.white, // ข้อความเป็นสีขาว
                  // ไม่ปรับ fontWeight, fontSize, shadows ตามคำขอ (คงเดิมจากโค้ดเดิม)
                ),
              ),
              centerTitle: true, // จัดให้อยู่ตรงกลาง
              elevation: 0, // ยกเลิกเงา
            ),
      // Drawer ถูกจัดการใน `app_drawer.dart` ซึ่งต้องมีการปรับสไตล์ในไฟล์นั้นแยกต่างหาก
      drawer: isLargeScreen
          ? null
          : AppDrawer(onMenuTap: _onMenuTap, selectedIndex: _selectedIndex),
      // --- ปรับสี Background ของ Body (พื้นที่แสดงผลของแต่ละหน้า) ---
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF3E0), // Very light peach/cream
              Color(0xFFFFECB3), // Light Peach
              Color(0xFFFBE4C4), // Slightly darker peach/cream
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Row(
          children: [
            if (isLargeScreen)
              SizedBox(
                width: 280,
                child: AppDrawer(
                  onMenuTap: _onMenuTap,
                  selectedIndex: _selectedIndex,
                ),
              ),
            Expanded(child: _pages[_selectedIndex]),
          ],
        ),
      ),
    );
  }
}
