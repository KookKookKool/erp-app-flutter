import 'package:flutter/material.dart';
import 'quotation/quotation_list_screen.dart';
import 'sales_order/sales_order_list_screen.dart';
import 'customer/customer_list_screen.dart';

class SalesHomeScreen extends StatelessWidget {
  const SalesHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sales / CRM")),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 32,
          crossAxisSpacing: 32,
          children: [
            _SalesModuleIcon(
              icon: Icons.request_quote,
              label: "ใบเสนอราคา\n(Quotation)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const QuotationListScreen()),
              ),
            ),
            _SalesModuleIcon(
              icon: Icons.assignment,
              label: "ใบสั่งขาย\n(Sales Order)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SalesOrderListScreen()),
              ),
            ),
            _SalesModuleIcon(
              icon: Icons.people,
              label: "ลูกค้า (Customer)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CustomerListScreen()),
              ),
            ),
            Stack(
              children: [
                _SalesModuleIcon(
                  icon: Icons.receipt_long,
                  label: "ใบแจ้งหนี้/Receipt\n(Coming soon)",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ฟีเจอร์นี้กำลังพัฒนา")),
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
    );
  }
}

class _SalesModuleIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _SalesModuleIcon({
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.red[100],
              child: Icon(icon, size: 40, color: Colors.red[900]),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
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
