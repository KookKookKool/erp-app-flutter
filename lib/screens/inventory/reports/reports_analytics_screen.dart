import 'package:flutter/material.dart';
import 'report_stock_summary_screen.dart';
import 'report_low_stock_screen.dart';
import 'report_po_screen.dart';
import 'report_movement_screen.dart';
import '../supplier/supplier_list_screen.dart';


class ReportsAnalyticsScreen extends StatelessWidget {
  const ReportsAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // mock data
    final stockTotal = 2000;
    final stockMinItems = 2;
    final poTotal = 8;
    final supplierCount = 3;

    return Scaffold(
      appBar: AppBar(title: const Text("รายงาน & Analytics")),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text("Dashboard ภาพรวม", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportStockSummaryScreen()),
                ),
                child: _InfoCard(
                  label: "สินค้าคงเหลือทั้งหมด",
                  value: "$stockTotal",
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportLowStockScreen()),
                ),
                child: _InfoCard(
                  label: "รายการต่ำกว่าขั้นต่ำ",
                  value: "$stockMinItems",
                  color: Colors.redAccent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ReportPOScreen()),
                ),
                child: _InfoCard(
                  label: "จำนวนใบสั่งซื้อ",
                  value: "$poTotal",
                ),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(18),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SupplierListScreen()),
                ),
                child: _InfoCard(
                  label: "จำนวนซัพพลายเออร์",
                  value: "$supplierCount",
                ),
              ),
            ],
          ),
          const Divider(height: 36),
          const SizedBox(height: 6),
          const Text("รายงานยอดนิยม", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.inventory_2, color: Colors.blue),
            title: const Text("รายงานสรุปสินค้าคงคลัง"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportStockSummaryScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.swap_horiz, color: Colors.green),
            title: const Text("รายงานการเคลื่อนไหวสินค้า (รับ/จ่าย/โอน)"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportMovementScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.warning, color: Colors.red),
            title: const Text("รายงานสินค้าต่ำกว่าขั้นต่ำ"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportLowStockScreen()),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.receipt, color: Colors.deepOrange),
            title: const Text("รายงานใบสั่งซื้อ (Purchasing)"),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ReportPOScreen()),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  const _InfoCard({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: color?.withOpacity(0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 3,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        width: 150,
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: color ?? Colors.blue[900],
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
