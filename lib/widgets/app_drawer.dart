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
      // 1. กำหนดสีพื้นหลังของ Drawer ให้เป็นสีเดียวกับสีอ่อนที่สุดในพื้นหลังจอหลัก
      backgroundColor: const Color(0xFFFFF3E0), // Very light peach/cream
      child: SafeArea(
        child: Column(
          children: [
            // 2. ปรับ UserAccountsDrawerHeader ให้ใช้ Gradient แบบเดียวกับ AppBar
            UserAccountsDrawerHeader(
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(
                  "https://i.pravatar.cc/300?img=5",
                ),
              ),
              accountName: const Text(
                "ศิริพร ใจดี (ฝ้าย)",
                style: TextStyle(
                    color: Colors.white, // ตัวอักษรสีขาว
                    fontWeight: FontWeight.bold),
              ),
              accountEmail: const Text(
                "faijai@gmail.com",
                style: TextStyle(color: Colors.white70), // ตัวอักษรสีขาวจางลง
              ),
              margin: EdgeInsets.zero, // ลบ margin เริ่มต้นของ header
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
            // 3. กำหนด Style ให้กับ ListTile ด้วยฟังก์ชัน _buildDrawerItem
            _buildDrawerItem(
              context,
              icon: Icons.account_circle,
              title: "My Profile",
              index: 0,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.people,
              title: "HR Management",
              index: 1,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.inventory_2,
              title: 'Inventory & Supply Chain',
              index: 2,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.account_balance_wallet,
              title: 'Accounting / Finance',
              index: 3,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.shopping_cart,
              title: 'Sales / CRM',
              index: 4,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.analytics,
              title: 'Dashboard & Analytics',
              index: 5,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.folder_copy,
              title: 'Project / Workflow',
              index: 6,
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            const Spacer(), // ใช้ Spacer เพื่อดันรายการด้านล่างลงไป
            const Divider(color: Colors.black12), // ปรับสี Divider ให้เข้ากับธีม
            _buildDrawerItem(
              context,
              icon: Icons.settings,
              title: "Setting",
              index: 7, // กำหนด index ให้ Setting เพื่อให้สามารถเลือกได้
              selectedIndex: selectedIndex,
              onTap: onMenuTap,
            ),
            _buildDrawerItem(
              context,
              icon: Icons.logout,
              title: "ออกจากระบบ",
              index: 8, // กำหนด index ให้ ออกจากระบบ เพื่อให้สามารถเลือกได้
              selectedIndex: selectedIndex,
              onTap: (index) {
                // เพิ่ม Logic สำหรับออกจากระบบตรงนี้
                Navigator.of(context).popUntil((route) => route.isFirst);
                onMenuTap?.call(index); // เรียก onTap callback ด้วย
              },
            ),
          ],
        ),
      ),
    );
  }

  // Helper method เพื่อสร้าง ListTile ที่มี Style ตามต้องการ (Unselected/Selected)
  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required int index,
    required int selectedIndex,
    required void Function(int)? onTap,
  }) {
    final bool isSelected = index == selectedIndex;
    return ListTile(
      leading: Icon(
        icon,
        // สี Icon: ส้มเข้มเมื่อเลือก, ดำเข้มเมื่อไม่เลือก
        color: isSelected ? const Color(0xFFDD6600) : Colors.black87,
      ),
      title: Text(
        title,
        style: TextStyle(
          // สี Text: ส้มเข้มเมื่อเลือก, ดำเข้มเมื่อไม่เลือก
          color: isSelected ? const Color(0xFFDD6600) : Colors.black87,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, // ตัวหนาเมื่อเลือก
        ),
      ),
      selected: isSelected, // กำหนดสถานะ selected
      // สีพื้นหลังเมื่อถูกเลือก (Light Peach จากธีม)
      selectedTileColor: const Color(0xFFFFECB3), 
      onTap: () => onTap?.call(index), // เรียก onTap callback
    );
  }
}