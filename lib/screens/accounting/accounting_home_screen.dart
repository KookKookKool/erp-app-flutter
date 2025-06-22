import 'package:flutter/material.dart';
import 'package:erp_app/screens/accounting/ap/ap_list_screen.dart';
import 'package:erp_app/screens/accounting/ar/ar_list_screen.dart';

class AccountingHomeScreen extends StatelessWidget {
  const AccountingHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
     appBar: isLargeScreen
          ? AppBar(title: const Text("Accounting / Finance"), centerTitle: true)
          : null,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 32,
          crossAxisSpacing: 32,
          children: [
            _AccountingModuleIcon(
              icon: Icons.account_balance_wallet,
              label: "รายการเจ้าหนี้ (AP)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const APListScreen()),
              ),
            ),
            _AccountingModuleIcon(
              icon: Icons.receipt,
              label: "รายการลูกหนี้ (AR)",
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ARListScreen()),
              ),
            ),
            // รายงานรับจ่าย (Coming soon)
            Stack(
              children: [
                _AccountingModuleIcon(
                  icon: Icons.bar_chart,
                  label: "รายงานรับจ่าย",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("โมดูลรายงานรับจ่าย กำลังอัพเดท"),
                      ),
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
            // บัญชีแยกประเภท (Coming soon)
            Stack(
              children: [
                _AccountingModuleIcon(
                  icon: Icons.library_books,
                  label: "บัญชีแยกประเภท",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("โมดูลบัญชีแยกประเภท กำลังอัพเดท"),
                      ),
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

class _AccountingModuleIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _AccountingModuleIcon({
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
              backgroundColor: Colors.green[100],
              child: Icon(icon, size: 40, color: Colors.green[900]),
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
