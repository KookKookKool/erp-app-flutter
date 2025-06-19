import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

import 'report_stock_summary_screen.dart';
import 'report_low_stock_screen.dart';
import 'report_movement_screen.dart';
import 'report_po_screen.dart';
import 'package:erp_app/screens/inventory/supplier/supplier_list_screen.dart';
import 'package:erp_app/screens/inventory/warehouse/warehouse_list_screen.dart';
import 'package:erp_app/screens/inventory/product/product_list_screen.dart';

class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final totalProduct = mockProductList.length;
    final totalPO = mockPOList.length;
    final totalSupplier = mockSupplierList.length;
    final totalWarehouse = mockWarehouseList.length;
    final totalLowStock = mockProductList
        .where((p) => p["qty"] < p["min"])
        .length;
    final totalMovements = mockMovementList.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text("ภาพรวมระบบ ERP"),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
        children: [
          _dashboardHeader(context),
          const SizedBox(height: 8),
          GridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.25,
            children: [
              _dashboardCard(
                icon: Icons.inventory_2,
                label: "สินค้าในระบบ",
                count: totalProduct,
                color: Colors.blue,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProductListScreen()),
                ),
              ),
              _dashboardCard(
                icon: Icons.store_mall_directory,
                label: "คลัง/โกดัง",
                count: totalWarehouse,
                color: Colors.deepPurple,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const WarehouseListScreen(),
                  ),
                ),
              ),
              _dashboardCard(
                icon: Icons.receipt_long,
                label: "ใบสั่งซื้อ (PO)",
                count: totalPO,
                color: Colors.green,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportPOScreen()),
                ),
              ),
              _dashboardCard(
                icon: Icons.inventory_2,
                label: "คงเหลือสินค้า",
                count: totalProduct,
                color: Colors.teal,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportStockSummaryScreen(),
                  ),
                ),
              ),
              _dashboardCard(
                icon: Icons.swap_horiz,
                label: "เคลื่อนไหวล่าสุด",
                count: totalMovements,
                color: Colors.orange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportMovementScreen(),
                  ),
                ),
              ),
              _dashboardCard(
                icon: Icons.warning,
                label: "สินค้าใกล้หมด",
                count: totalLowStock,
                color: Colors.redAccent,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ReportLowStockScreen(),
                  ),
                ),
              ),
              _dashboardCard(
                icon: Icons.local_shipping,
                label: "ซัพพลายเออร์",
                count: totalSupplier,
                color: Colors.deepOrange,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupplierListScreen()),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _dashboardHeader(BuildContext context) {
    final today = DateTime.now();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 2),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.deepPurple.shade100,
            child: const Icon(
              Icons.dashboard_customize,
              color: Colors.deepPurple,
              size: 32,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "ERP Dashboard",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              ),
              Text(
                "วันที่ ${today.day}/${today.month}/${today.year}",
                style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _dashboardCard({
    required IconData icon,
    required String label,
    required int count,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              colors: [color.withOpacity(0.12), Colors.white],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.08),
                blurRadius: 7,
                offset: const Offset(2, 4),
              ),
            ],
            border: Border.all(color: color.withOpacity(0.13)),
          ),
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 30),
              const SizedBox(height: 9),
              Text(
                "$count",
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                  color: color,
                ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
