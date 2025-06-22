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
      appBar: isLargeScreen
          ? null
          : AppBar(title: Text(_titles[_selectedIndex])),
      drawer: isLargeScreen
          ? null
          : AppDrawer(onMenuTap: _onMenuTap, selectedIndex: _selectedIndex),
      body: Row(
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
    );
  }
}
