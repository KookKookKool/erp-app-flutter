import 'package:flutter/material.dart';
import 'product_form_screen.dart';
import 'package:erp_app/utils/mock_data.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  String searchText = "";

  List<Map<String, dynamic>> get products => mockProductList;

  @override
  Widget build(BuildContext context) {
    // ถ้ามีสินค้าใหม่โครงสร้างไม่ครบ ให้เติม field ว่างๆ (เพื่อรองรับ schema เดิม)
    for (final p in products) {
      p["category"] ??= "";
      p["stock"] ??= p["qty"] ?? 0;
      p["unit"] ??= "";
      p["remark"] ??= "";
    }

    final filtered = products.where((p) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return [
        p["name"] ?? "",
        p["code"] ?? "",
        p["category"] ?? "",
        p["remark"] ?? "",
      ].any((v) => v.toString().toLowerCase().contains(q));
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("สินค้า/สต็อก")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: "ค้นหา (ชื่อ/รหัส/หมวดหมู่/หมายเหตุ)",
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
                final p = filtered[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.deepOrange,
                      child: Icon(Icons.inventory),
                    ),
                    title: Text(
                      p["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("รหัส: ${p["code"]}"),
                        Text("หมวดหมู่: ${p["category"]}"),
                        Text("คงเหลือ: ${p["stock"] ?? p["qty"]} ${p["unit"]}"),
                        if ((p["remark"] ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "หมายเหตุ: ${p["remark"]}",
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProductFormScreen(product: p),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() {
                            products.remove(p);
                          });
                        } else if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            // update ทั้ง global และ filtered list
                            final idx = products.indexOf(p);
                            products[idx] = result;
                          });
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ProductFormScreen(product: p),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() {
                          products.remove(p);
                        });
                      } else if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          final idx = products.indexOf(p);
                          products[idx] = result;
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
        label: const Text("เพิ่มสินค้า"),
        onPressed: () async {
          final newP = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
          if (newP != null) {
            setState(() {
              products.add(newP);
            });
          }
        },
      ),
    );
  }
}
