import 'package:flutter/material.dart';

class ActivityLog extends StatelessWidget {
  final List<Map<String, dynamic>> logs;
  const ActivityLog({super.key, required this.logs});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: SizedBox(
        height: 150,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 14, left: 16, bottom: 8),
              child: Text("Activity Log", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: logs.length > 5 ? 5 : logs.length,
                itemBuilder: (_, i) {
                  final l = logs[i];
                  return ListTile(
                    dense: true,
                    leading: const Icon(Icons.history, size: 18),
                    title: Text("${l['user']}: ${l['action']}"),
                    subtitle: Text(l['date'] ?? ""),
                  );
                },
              ),
            ),
            if (logs.length > 5)
              TextButton(
                child: const Text("ดูทั้งหมด"),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text("ประวัติกิจกรรมทั้งหมด"),
                      content: SizedBox(
                        width: 300,
                        height: 350,
                        child: ListView(
                          children: logs.map((l) => ListTile(
                            dense: true,
                            leading: const Icon(Icons.history, size: 18),
                            title: Text("${l['user']}: ${l['action']}"),
                            subtitle: Text(l['date'] ?? ""),
                          )).toList(),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
