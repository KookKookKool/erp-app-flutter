import 'package:flutter/material.dart';
import 'product/product_list_screen.dart';
import 'warehouse/warehouse_list_screen.dart';
import 'movement/stock_movement_list_screen.dart';
import 'supplier/supplier_list_screen.dart';
import 'purchasing/purchasing_list_screen.dart';
import 'reports/reports_analytics_screen.dart';
import 'receiving/receiving_list_screen.dart';

class InventoryHomeScreen extends StatelessWidget {
  const InventoryHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("คลังสินค้า & ซัพพลายเชน"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 32,
          crossAxisSpacing: 32,
          children: [
            _InventoryModuleIcon(
              icon: Icons.inventory,
              label: "จัดการสต็อกสินค้า",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProductListScreen()),
              ),
            ),
            _InventoryModuleIcon(
              icon: Icons.store,
              label: "คลัง/โกดัง",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WarehouseListScreen()),
              ),
            ),
            _InventoryModuleIcon(
              icon: Icons.shopping_cart_checkout,
              label: "ระบบจัดซื้อ (Purchasing)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PurchasingListScreen()),
              ),
            ),
            _InventoryModuleIcon(
              icon: Icons.local_shipping,
              label: "รับ/จ่าย/โอนสินค้า",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StockMovementListScreen(),
                ),
              ),
            ),
            _InventoryModuleIcon(
              icon: Icons.people_alt,
              label: "ซัพพลายเออร์ (Supplier)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupplierListScreen()),
              ),
            ),
            _InventoryModuleIcon(
              icon: Icons.move_to_inbox,
              label: "รับสินค้าเข้าคลัง",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ReceivingListScreen()),
              ),
            ),
            _InventoryModuleIcon(
              icon: Icons.analytics,
              label: "รายงาน/วิเคราะห์",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ReportsAnalyticsScreen(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InventoryModuleIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _InventoryModuleIcon({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: Colors.deepPurple[100],
                child: Icon(icon, size: 40, color: Colors.deepPurple[900]),
              ),
              const SizedBox(height: 16),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
