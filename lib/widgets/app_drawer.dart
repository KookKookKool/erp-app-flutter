import 'package:flutter/material.dart';
import 'package:erp_app/screens/hrm/hrm_home_screen.dart';
import 'package:erp_app/screens/inventory-supply-chain/inventory_home_screen.dart';
import 'package:erp_app/screens/accounting/accounting_home_screen.dart';
import 'package:erp_app/screens/sales-crm/sales_home_screen.dart';
import 'package:erp_app/screens/dashboard/dashboard_home_screen.dart';


class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage("https://i.pravatar.cc/300?img=5"),
              ),
              accountName: const Text("ศิริพร ใจดี (ฝ้าย)"),
              accountEmail: const Text("faijai@gmail.com"),
              decoration: const BoxDecoration(
                color: Colors.blueAccent,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("My Profile"),
              // onTap: () => Navigator.pop(context), // ถ้ามีหน้า dashboard จริงให้เปิดหน้านั้น
              onTap: () {
                Navigator.pop(context); // หรือเพิ่มหน้า dashboard ตามต้องการ
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("HRM"),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const HRMHomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Inventory & Supply Chain'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const InventoryHomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Accounting / Finance'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AccountingHomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Sales / CRM'),
              // ยังไม่มีหน้านี้ - ขึ้น SnackBar ว่า Coming Soon
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SalesHomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Dashboard & Analytics'),
              // ยังไม่มีหน้านี้ - ขึ้น SnackBar ว่า Coming Soon
              onTap: () {
               Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardHomeScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy),
              title: const Text('Project / Workflow'),
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Project / Workflow: Coming Soon!")),
                );
              },
            ),
            const Spacer(),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text("Setting"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("ออกจากระบบ"),
              onTap: () {
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        ),
      ),
    );
  }
}
