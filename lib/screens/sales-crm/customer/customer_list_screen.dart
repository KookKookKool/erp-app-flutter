import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'customer_form_screen.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    final filtered = mockCustomerList.where((c) {
      if (searchText.isEmpty) return true;
      final q = searchText.toLowerCase();
      return c.values.whereType<String>().any(
        (v) => v.toLowerCase().contains(q),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text("ลูกค้า (Customer)")),
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
                final c = filtered[i];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  margin: const EdgeInsets.only(bottom: 14),
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigoAccent,
                      child: Icon(Icons.people),
                    ),
                    title: Text(
                      c["name"],
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("รหัส: ${c["code"]}"),
                        if ((c["phone"] ?? "").isNotEmpty)
                          Text("โทร: ${c["phone"]}"),
                        if ((c["email"] ?? "").isNotEmpty)
                          Text("อีเมล: ${c["email"]}"),
                        if ((c["address"] ?? "").isNotEmpty)
                          Text("ที่อยู่: ${c["address"]}"),
                        if ((c["remark"] ?? "").isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 2),
                            child: Text(
                              "หมายเหตุ: ${c["remark"]}",
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
                            builder: (_) => CustomerFormScreen(customer: c),
                          ),
                        );
                        if (result == 'delete') {
                          setState(() => mockCustomerList.removeAt(i));
                        } else if (result != null &&
                            result is Map<String, dynamic>) {
                          setState(() => mockCustomerList[i] = result);
                        }
                      },
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CustomerFormScreen(customer: c),
                        ),
                      );
                      if (result == 'delete') {
                        setState(() => mockCustomerList.removeAt(i));
                      } else if (result != null &&
                          result is Map<String, dynamic>) {
                        setState(() => mockCustomerList[i] = result);
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
        label: const Text("เพิ่มลูกค้า"),
        onPressed: () async {
          final newC = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CustomerFormScreen()),
          );
          if (newC != null) {
            setState(() => mockCustomerList.add(newC));
          }
        },
      ),
    );
  }
}
