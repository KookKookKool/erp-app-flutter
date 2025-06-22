// lib/widgets/app_drawer.dart
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final int selectedIndex;
  final void Function(int)? onMenuTap;

  const AppDrawer({
    super.key,
    this.selectedIndex = 0,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/300?img=5",
                ),
              ),
              accountName: const Text("ศิริพร ใจดี (ฝ้าย)"),
              accountEmail: const Text("faijai@gmail.com"),
              decoration: const BoxDecoration(color: Colors.blueAccent),
            ),
            ListTile(
              leading: const Icon(Icons.account_circle),
              title: const Text("My Profile"),
              selected: selectedIndex == 0,
              onTap: () => onMenuTap?.call(0),
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text("HR Management"),
              selected: selectedIndex == 1,
              onTap: () => onMenuTap?.call(1),
            ),
            ListTile(
              leading: const Icon(Icons.inventory_2),
              title: const Text('Inventory & Supply Chain'),
              selected: selectedIndex == 2,
              onTap: () => onMenuTap?.call(2),
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Accounting / Finance'),
              selected: selectedIndex == 3,
              onTap: () => onMenuTap?.call(3),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: const Text('Sales / CRM'),
              selected: selectedIndex == 4,
              onTap: () => onMenuTap?.call(4),
            ),
            ListTile(
              leading: const Icon(Icons.analytics),
              title: const Text('Dashboard & Analytics'),
              selected: selectedIndex == 5,
              onTap: () => onMenuTap?.call(5),
            ),
            ListTile(
              leading: const Icon(Icons.folder_copy),
              title: const Text('Project / Workflow'),
              selected: selectedIndex == 6,
              onTap: () => onMenuTap?.call(6),
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
