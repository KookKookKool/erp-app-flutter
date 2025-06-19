import 'package:flutter/material.dart';
import 'ap_form_screen.dart';
import 'package:erp_app/utils/mock_data.dart';

class APListScreen extends StatefulWidget {
  const APListScreen({super.key});
  @override
  State<APListScreen> createState() => _APListScreenState();
}

class _APListScreenState extends State<APListScreen> {
  String searchText = "";

  List<Map<String, dynamic>> get apList => mockAPList;

  @override
  Widget build(BuildContext context) {
    final filtered = apList.where((ap) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      final supplierName = mockSupplierList.firstWhere(
        (s) => s["code"] == ap["supplier"],
        orElse: () => {"name": ""},
      )["name"];
      return [
        ap["apNo"] ?? "",
        ap["date"] ?? "",
        supplierName ?? "",
        ap["status"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("เจ้าหนี้การค้า (AP)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (เลขที่ AP/ซัพพลายเออร์/สถานะ)",
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
                final ap = filtered[i];
                final supplierName = mockSupplierList.firstWhere(
                  (s) => s["code"] == ap["supplier"],
                  orElse: () => {"name": ""},
                )["name"];
                return Card(
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepPurple,
                      child: Icon(Icons.account_balance_wallet, color: Colors.white),
                    ),
                    title: Text(
                      "${ap["apNo"] ?? ""} (${ap["status"] ?? ""})",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Supplier: $supplierName"),
                        Text("ยอด: ${ap["amount"]} บาท"),
                        Text("วันที่: ${ap["date"] ?? "-"}"),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => APFormScreen(ap: ap),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() {
                            apList.remove(ap);
                          });
                        } else if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            final idx = apList.indexOf(ap);
                            apList[idx] = result;
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => APFormScreen(ap: ap),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() {
                          apList.remove(ap);
                        });
                      } else if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          final idx = apList.indexOf(ap);
                          apList[idx] = result;
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
        label: const Text("เพิ่มเจ้าหนี้"),
        onPressed: () async {
          final newAP = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const APFormScreen()),
          );
          if (newAP != null) {
            setState(() => apList.add(newAP));
          }
        },
      ),
    );
  }
}
