import 'package:flutter/material.dart';
import 'product_form_screen.dart';
import 'widgets/product_card.dart';

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
      "unit": "เล่ม",
      "stock": 120,
      "warehouse": "คลังหลัก",
      "remark": "",
    },
    {
      "code": "P002",
      "name": "ปากกาเจล",
      "category": "เครื่องเขียน",
      "unit": "ด้าม",
      "stock": 240,
      "warehouse": "คลังสาขา 1",
      "remark": "สินค้าขายดี",
    },
    {
      "code": "P003",
      "name": "น้ำดื่ม 600ml",
      "category": "เครื่องดื่ม",
      "unit": "ขวด",
      "stock": 50,
      "warehouse": "คลังหลัก",
      "remark": "",
    },
  ];

  String search = "";
  String? selectedCategory;

  @override
  Widget build(BuildContext context) {
    // --- สร้าง list หมวดหมู่แบบไม่ซ้ำ ---
    final categories = products
        .map((p) => p['category'] as String)
        .toSet()
        .toList();
    categories.sort();

    // --- กรองสินค้า ---
    final filtered = products.where((p) {
      final matchSearch =
          search.isEmpty ||
          p["name"].toString().toLowerCase().contains(search.toLowerCase()) ||
          p["code"].toString().toLowerCase().contains(search.toLowerCase());
      final matchCategory =
          selectedCategory == null || selectedCategory == "ทั้งหมด"
          ? true
          : p["category"] == selectedCategory;
      return matchSearch && matchCategory;
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("รายการสินค้าในสต็อก")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
            child: Row(
              children: [
                // ช่องค้นหา
                Expanded(
                  flex: 2,
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "ค้นหาชื่อ/รหัสสินค้า",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    ),
                    onChanged: (v) => setState(() => search = v),
                  ),
                ),
                const SizedBox(width: 10),
                // Dropdown หมวดหมู่
                Expanded(
                  flex: 1,
                  child: DropdownButtonFormField<String>(
                    isExpanded: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "หมวดหมู่",
                    ),
                    value: selectedCategory,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text("ทั้งหมด"),
                      ),
                      ...categories.map(
                        (cat) => DropdownMenuItem(value: cat, child: Text(cat)),
                      ),
                    ],
                    onChanged: (val) => setState(() => selectedCategory = val),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 0),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูลสินค้า"))
                : ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final item = filtered[i];
                      return GestureDetector(
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ProductFormScreen(product: item),
                            ),
                          );
                          if (result != null) {
                            if (result == "delete") {
                              setState(() {
                                products.removeWhere(
                                  (p) => p["code"] == item["code"],
                                );
                              });
                            } else {
                              setState(() {
                                // อัปเดตสินค้าใน list
                                final idx = products.indexWhere(
                                  (p) => p["code"] == item["code"],
                                );
                                if (idx != -1) products[idx] = result;
                              });
                            }
                          }
                        },

                        child: ProductCard(data: item),
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
          final newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const ProductFormScreen()),
          );
          if (newProduct != null) {
            setState(() => products.add(newProduct));
          }
        },
      ),
    );
  }
}
