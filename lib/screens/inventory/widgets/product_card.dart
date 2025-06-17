import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> data;
  const ProductCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(data['name'][0])),
        title: Text(data['name']),
        subtitle: Text("รหัส: ${data['code']} | หมวด: ${data['category']}"),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("คงเหลือ", style: const TextStyle(fontSize: 12)),
            Text("${data['stock']} ${data['unit']}",
                style: const TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.green)),
          ],
        ),
      ),
    );
  }
}
