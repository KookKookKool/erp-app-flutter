import 'package:flutter/material.dart';
import 'supplier_form_screen.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});
  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  List<Map<String, dynamic>> suppliers = [
    {
      "code": "S001",
      "name": "บริษัท สมาร์ทซัพพลาย จำกัด",
      "phone": "086-111-2222",
      "email": "contact@smartsupply.co.th",
      "address": "12/34 ถ.สุขุมวิท บางนา กทม.",
      "remark": "VAT Registered"
    },
    {
      "code": "S002",
      "name": "รุ่งเรืองการค้า",
      "phone": "098-222-3333",
      "email": "rung@example.com",
      "address": "89/9 หมู่ 7 เชียงใหม่",
      "remark": ""
    },
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filtered = suppliers.where((s) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return s.values
        .whereType<String>()
        .any((v) => v.toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ซัพพลายเออร์ (Supplier)")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (ชื่อ/รหัส/เบอร์/อีเมล/ที่อยู่/หมายเหตุ)",
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
                final s = filtered[i];
                return Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const CircleAvatar(
                      child: Icon(Icons.person),
                      backgroundColor: Colors.purpleAccent,
                    ),
                    title: Text(
                      s["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("รหัส: ${s["code"]}"),
                        if ((s["phone"] ?? "").isNotEmpty)
                          Text("โทร: ${s["phone"]}"),
                        if ((s["email"] ?? "").isNotEmpty)
                          Text("อีเมล: ${s["email"]}"),
                        if ((s["address"] ?? "").isNotEmpty)
                          Text("ที่อยู่: ${s["address"]}"),
                        if ((s["remark"] ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text("หมายเหตุ: ${s["remark"]}", style: const TextStyle(fontSize: 12)),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => SupplierFormScreen(supplier: s),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() {
                            suppliers.removeAt(i);
                          });
                        } else if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            suppliers[i] = result;
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => SupplierFormScreen(supplier: s),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() {
                          suppliers.removeAt(i);
                        });
                      } else if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          suppliers[i] = result;
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
        label: const Text("เพิ่มซัพพลายเออร์"),
        onPressed: () async {
          final newS = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const SupplierFormScreen()),
          );
          if (newS != null) {
            setState(() => suppliers.add(newS));
          }
        },
      ),
    );
  }
}
