import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'project_detail_screen.dart';

class ProjectHomeScreen extends StatelessWidget {
  const ProjectHomeScreen({super.key});

  Map<String, dynamic>? findEmployee(String? id) {
    return mockEmployeeList.firstWhere(
      (e) => e['id'] == id,
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(title: const Text("Project / Workflow"), centerTitle: true)
          : null,
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: mockProjectList.length,
        itemBuilder: (_, i) {
          final pj = mockProjectList[i];
          // ignore: unused_local_variable
          final responsible = findEmployee(pj["responsible"]);
          final members = (pj["members"] as List<dynamic>? ?? [])
              .map((id) => findEmployee(id))
              .toList();
          final percent = (pj["progress"] ?? 0.0) as double;

          return Card(
            margin: const EdgeInsets.only(bottom: 14),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProjectDetailScreen(projectId: pj["id"]),
                ),
              ),
              title: Text(pj["name"] ?? "",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pj["description"] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      ...members.take(5).map((e) => Padding(
                        padding: const EdgeInsets.only(right: 4),
                        child: CircleAvatar(
                          radius: 12,
                          backgroundImage: (e?["profilePic"] ?? '').toString().isNotEmpty
                              ? NetworkImage(e!["profilePic"])
                              : null,
                          child: (e?["profilePic"] == null || (e?["profilePic"] ?? '').toString().isEmpty)
                              ? Text((e?["name"] ?? "?").toString().substring(0, 1))
                              : null,
                        ),
                      )),
                      if (members.length > 5)
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.grey[300],
                          child: Text("+${members.length - 5}",
                              style: const TextStyle(fontSize: 13, color: Colors.black)),
                        ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: LinearProgressIndicator(
                      value: percent,
                      minHeight: 7,
                      color: Colors.blueAccent,
                      backgroundColor: Colors.grey[200],
                    ),
                  ),
                ],
              ),
              trailing: const Icon(Icons.chevron_right),
            ),
          );
        },
      ),
    );
  }
}
