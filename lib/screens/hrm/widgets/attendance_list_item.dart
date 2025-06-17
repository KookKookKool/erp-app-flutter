import 'package:flutter/material.dart';

class AttendanceListItem extends StatelessWidget {
  final Map<String, dynamic> data;

  const AttendanceListItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(data['name'][0])),
        title: Text("${data['name']} (${data['empId']})"),
        subtitle: Text(
          "เข้า: ${data['checkIn'] ?? "-"}  ออก: ${data['checkOut'] ?? "-"}",
        ),
        trailing: Text(
          data['status'],
          style: TextStyle(
            color: data['status'] == "ปกติ"
                ? Colors.green
                : data['status'] == "ขาด"
                    ? Colors.red
                    : data['status'] == "ลา"
                        ? Colors.orange
                        : Colors.blue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
