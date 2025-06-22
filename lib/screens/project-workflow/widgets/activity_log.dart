import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ActivityLog extends StatelessWidget {
  final List<Map<String, dynamic>> activitylog;
  final void Function(List<Map<String, dynamic>>) onUpdate;
  const ActivityLog({super.key, required this.activitylog, required this.onUpdate});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Activity Log", style: TextStyle(fontWeight: FontWeight.bold)),
            ...activitylog.take(5).map((log) {
              final user = mockEmployeeList.firstWhere((e) => e["id"] == log["user"], orElse: () => {});
              return ListTile(
                leading: CircleAvatar(radius: 14, backgroundImage: NetworkImage(user["profilePic"] ?? "")),
                title: Text(user["name"] ?? "", style: const TextStyle(fontSize: 14)),
                subtitle: Text("${log["action"] ?? ""} (${log["date"] ?? ""})", style: const TextStyle(fontSize: 13)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
