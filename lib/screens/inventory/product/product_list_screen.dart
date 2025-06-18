import 'package:flutter/material.dart';
import 'product_form_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});
  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Map<String, dynamic>> products = [
    {
      "code": "P001",
      "name": "สมุดโน๊ต A5",
      "category": "เครื่องเขียน",
      "stock": 80,
      "unit": "เล่ม",
      "remark": ""
    },
    {
      "code": "P002",
      "name": "ปากกาเจล",
      "category": "เครื่องเขียน",
      "stock": 120,
      "unit": "ด้าม",
      "remark": "สินค้าขายดี"
    },
  ];

  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filtered = products.where((p) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return p.values
        .whereType<String>()
        .any((v) => v.toLowerCase().contains(q));
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
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
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
                        Text("คงเหลือ: ${p["stock"]} ${p["unit"]}"),
                        if ((p["remark"] ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text("หมายเหตุ: ${p["remark"]}", style: const TextStyle(fontSize: 12)),
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
                            products.removeAt(i);
                          });
                        } else if (result != null && result is Map<String, dynamic>) {
                          setState(() {
                            products[i] = result;
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
                          products.removeAt(i);
                        });
                      } else if (result != null && result is Map<String, dynamic>) {
                        setState(() {
                          products[i] = result;
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
            setState(() => products.add(newP));
          }
        },
      ),
    );
  }
}
