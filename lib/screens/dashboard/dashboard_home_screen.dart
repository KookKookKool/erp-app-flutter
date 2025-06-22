import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'widgets/kpi_card.dart';
import 'widgets/inventory_pie_chart.dart';
import 'widgets/sales_bar_chart.dart';
import 'widgets/section_header.dart';
import 'widgets/summary_card.dart';

class DashboardHomeScreen extends StatelessWidget {
  const DashboardHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // KPI
    final totalCustomers = mockCustomerList.length;
    final totalSuppliers = mockSupplierList.length;
    final totalProducts = mockProductList.length;

    final lowStockCount =
        mockProductList.where((p) => (p["qty"] as int) <= (p["min"] as int)).length;

    // Bar chart data: รายเดือน
    List<String> months = [
      'ม.ค.', 'ก.พ.', 'มี.ค.', 'เม.ย.', 'พ.ค.', 'มิ.ย.',
      'ก.ค.', 'ส.ค.', 'ก.ย.', 'ต.ค.', 'พ.ย.', 'ธ.ค.',
    ];

    Map<int, double> salesByMonth = {};
    Map<int, double> purchaseByMonth = {};
    for (int i = 1; i <= 12; i++) {
      salesByMonth[i] = 0;
      purchaseByMonth[i] = 0;
    }
    for (final so in mockSalesOrderList) {
      int m = int.parse(so["date"].toString().split('-')[1]);
      if (so["status"] == "สำเร็จ") {
        salesByMonth[m] = (salesByMonth[m] ?? 0) + (so["total"] ?? 0.0);
      }
    }
    for (final po in mockPOList) {
      int m = int.parse(po["date"].toString().split('-')[1]);
      if (po["status"] == "สำเร็จ") {
        purchaseByMonth[m] = (purchaseByMonth[m] ?? 0) + (po["total"] ?? 0.0);
      }
    }

    // AR/AP
    final arDue = mockARList.where((ar) => ar["status"] == "ค้างรับ").fold<double>(0, (a, ar) => a + (ar["amount"] ?? 0));
    final apDue = mockAPList.where((ap) => ap["status"] == "ค้างจ่าย").fold<double>(0, (a, ap) => a + (ap["amount"] ?? 0));

    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(title: const Text("Dashboard & Analytics"), centerTitle: true)
          : null,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SectionHeader(title: 'สรุปข้อมูลหลัก'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                KPI_Card(icon: Icons.people, label: "ลูกค้า", value: totalCustomers),
                KPI_Card(icon: Icons.handshake, label: "ซัพพลายเออร์", value: totalSuppliers),
                KPI_Card(icon: Icons.inventory_2, label: "สินค้า", value: totalProducts),
              ],
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'สถานะสินค้าคงคลัง'),
            InventoryPieChart(
              inStock: totalProducts - lowStockCount,
              lowStock: lowStockCount,
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'ยอดขาย/ซื้อ รายเดือน'),
            SalesBarChart(
              months: months,
              salesData: salesByMonth,
              purchaseData: purchaseByMonth,
            ),
            const SizedBox(height: 18),
            SectionHeader(title: 'สรุปค้างรับ/ค้างจ่าย'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SummaryCard(label: "ค้างรับ", value: arDue),
                SummaryCard(label: "ค้างจ่าย", value: apDue),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
