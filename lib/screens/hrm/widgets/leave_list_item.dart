import 'package:flutter/material.dart';

class LeaveListItem extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onTap;

  const LeaveListItem({
    super.key,
    required this.data,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final leave = data['leave'] ?? {};
    final status = leave['approveStatus'] ?? "pending";
    String statusLabel;
    Color statusColor;

    switch (status) {
      case "approved":
        statusLabel = "อนุมัติ";
        statusColor = Colors.green;
        break;
      case "rejected":
        statusLabel = "ไม่อนุมัติ";
        statusColor = Colors.red;
        break;
      default:
        statusLabel = "รอดำเนินการ";
        statusColor = Colors.orange;
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(child: Text(data['name']?[0] ?? "?")),
        title: Text("${data['name']} (${data['empId']})"),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("วันที่ ${data['date']}"),
            if (leave['remark'] != null && leave['remark'].toString().isNotEmpty)
              Text("หมายเหตุ: ${leave['remark']}", style: const TextStyle(fontSize: 12)),
            if (leave['deductSalary'] == true)
              const Text("หักเงิน", style: TextStyle(color: Colors.red, fontSize: 11)),
          ],
        ),
        trailing: Text(statusLabel, style: TextStyle(color: statusColor)),
        onTap: onTap,
      ),
    );
  }
}
