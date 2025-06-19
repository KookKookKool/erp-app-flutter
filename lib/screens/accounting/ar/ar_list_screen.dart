import 'package:flutter/material.dart';
import 'ar_form_screen.dart';
import 'package:erp_app/utils/mock_data.dart';

class ARListScreen extends StatefulWidget {
  const ARListScreen({super.key});
  @override
  State<ARListScreen> createState() => _ARListScreenState();
}

class _ARListScreenState extends State<ARListScreen> {
  String searchText = "";

  List<Map<String, dynamic>> get arList => mockARList;

  @override
  Widget build(BuildContext context) {
    final filtered = arList.where((ar) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      final customerName = mockCustomerList.firstWhere(
        (c) => c["code"] == ar["customer"],
        orElse: () => {"name": ""},
      )["name"];
      return [
        ar["arNo"] ?? "",
        ar["date"] ?? "",
        customerName ?? "",
        ar["status"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ลูกหนี้การค้า (AR)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (เลขที่ AR/ลูกค้า/สถานะ)",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => searchText = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(18),
              itemCount: filtered.length,
              itemBuilder: (context, i) {
                final ar = filtered[i];
                final customerName = mockCustomerList.firstWhere(
                  (c) => c["code"] == ar["customer"],
                  orElse: () => {"name": ""},
                )["name"];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.account_balance, color: Colors.white),
                    ),
                    title: Text(
                      "${ar["arNo"] ?? ""} (${ar["status"] ?? ""})",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Customer: $customerName"),
                        Text("ยอด: ${ar["amount"]} บาท"),
                        Text("วันที่: ${ar["date"] ?? "-"}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ARFormScreen(ar: ar),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() {
                            arList.remove(ar);
                          });
                        } else if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            final idx = arList.indexOf(ar);
                            arList[idx] = result;
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ARFormScreen(ar: ar),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() {
                          arList.remove(ar);
                        });
                      } else if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          final idx = arList.indexOf(ar);
                          arList[idx] = result;
                        });
                      }
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("เพิ่มลูกหนี้"),
        onPressed: () async {
          final newAR = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ARFormScreen()),
          );
          if (newAR != null) {
            setState(() => arList.add(newAR));
          }
        },
      ),
    );
  }
}
