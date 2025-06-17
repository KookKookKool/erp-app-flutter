import 'package:flutter/material.dart';
import 'warehouse_form_screen.dart';

class WarehouseListScreen extends StatefulWidget {
  const WarehouseListScreen({super.key});

  @override
  State<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends State<WarehouseListScreen> {
  List<Map<String, dynamic>> warehouses = [
    {
      "code": "W001",
      "name": "คลังหลัก",
      "location": "สำนักงานใหญ่",
      "remark": "คลังสินค้าหลักสำหรับบริษัท",
    },
    {"code": "W002", "name": "คลังสาขา 1", "location": "บางนา", "remark": ""},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("คลัง/โกดังสินค้า")),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: warehouses.length,
        itemBuilder: (context, i) {
          final wh = warehouses[i];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 4,
            margin: const EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 10),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center, // **กึ่งกลางแนวนอน**
                children: [
                  Icon(
                    Icons.store_mall_directory,
                    color: Colors.deepPurple,
                    size: 38,
                  ),
                  const SizedBox(width: 18),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          wh["name"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text("รหัส: ${wh["code"]}"),
                        Text("ที่ตั้ง: ${wh["location"]}"),
                        if ((wh["remark"] ?? "").toString().isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              wh["remark"],
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.orange),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => WarehouseFormScreen(warehouse: wh),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() {
                          warehouses.removeAt(i);
                        });
                      } else if (result != null &&
                          result is Map<String, dynamic>) {
                        setState(() {
                          warehouses[i] = result;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text("เพิ่มคลัง/โกดัง"),
        onPressed: () async {
          final newWh = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const WarehouseFormScreen()),
          );
          if (newWh != null) {
            setState(() => warehouses.add(newWh));
          }
        },
      ),
    );
  }
}
