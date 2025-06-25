import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'widgets/project_card.dart';
import 'project_detail_screen.dart';
import 'widgets/project_name_editor.dart';
import 'widgets/project_stakeholders.dart';

class ProjectHomeScreen extends StatefulWidget {
  const ProjectHomeScreen({super.key});

  @override
  State<ProjectHomeScreen> createState() => _ProjectHomeScreenState();
}

class _ProjectHomeScreenState extends State<ProjectHomeScreen> {
  String filter = 'All';

  List<Map<String, dynamic>> get filteredProjects {
    if (filter == 'All') return mockProjectList;
    if (filter == 'Done') {
      return mockProjectList.where((p) {
        final tasks = p["tasks"] ?? [];
        if (tasks.isEmpty) return false;
        return tasks.every((t) => t["completed"] == true);
      }).toList();
    }
    if (filter == 'Ongoing') {
      return mockProjectList.where((p) {
        final tasks = p["tasks"] ?? [];
        if (tasks.isEmpty) return false;
        return tasks.any((t) => t["completed"] == false);
      }).toList();
    }
    if (filter == 'Canceled') {
      return mockProjectList
          .where((p) => (p["status"] ?? '') == "Canceled")
          .toList();
    }
    return mockProjectList;
  }

  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(title: const Text("Project & Workflow"), centerTitle: true)
          : null,
      body: Column(
        children: [
          // Filter Tab
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _FilterTab("All"),
                const SizedBox(width: 8),
                _FilterTab("Processing"),
                const SizedBox(width: 8),
                _FilterTab("Done"),
                const SizedBox(width: 8),
                _FilterTab("Canceled"),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              itemCount: filteredProjects.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) => ProjectCard(
                project: filteredProjects[idx],
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProjectDetailScreen(
                        projectId: filteredProjects[idx]["id"],
                      ),
                    ),
                  );
                  setState(() {}); // บรรทัดนี้หลัง await เพื่อรีเฟรช
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddProjectDialog,
        icon: const Icon(Icons.add),
        label: const Text("Add Project"),
      ),
    );
  }

  void _showAddProjectDialog() {
    String name = '';
    String description = '';
    String responsible = '';
    List<String> departments = [];
    List<String> members = [];
    DateTime? startDate;
    DateTime? dueDate;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Add Project"),
          content: StatefulBuilder(
            builder: (context, setStateDialog) => SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ProjectNameEditor(
                    initialName: name,
                    initialDescription: description,
                    initialStartDate: startDate,
                    initialEndDate: dueDate,
                    onEdit: (n, d, s, e) {
                      setStateDialog(() {
                        name = n;
                        description = d;
                        startDate = s;
                        dueDate = e;
                      });
                    },
                  ),
                  const SizedBox(height: 12),
                  ProjectStakeholders(
                    responsibleId: responsible,
                    departments: departments,
                    members: members,
                    onChanged: (newResponsible, newDepts, newMembers) {
                      setStateDialog(() {
                        responsible = newResponsible;
                        departments = newDepts;
                        members = newMembers;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (name.trim().isEmpty || responsible.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "กรุณากรอกชื่อโปรเจกต์และเลือกผู้รับผิดชอบ",
                      ),
                    ),
                  );
                  return;
                }
                setState(() {
                  mockProjectList.add({
                    "id": "P${mockProjectList.length + 1}".padLeft(4, '0'),
                    "name": name,
                    "description": description,
                    "responsible": responsible,
                    "departments": departments,
                    "members": members,
                    "startDate": startDate?.toIso8601String().substring(0, 10),
                    "dueDate": dueDate?.toIso8601String().substring(0, 10),
                    "tasks": [],
                    "comments": [],
                    "activitylog": [
                      {
                        "user": responsible,
                        "action": "สร้างโครงการ",
                        "date": DateTime.now().toIso8601String().substring(
                          0,
                          10,
                        ),
                      },
                    ],
                  });
                });
                Navigator.pop(ctx);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Widget _FilterTab(String label) {
    final isActive = filter == label;
    return ChoiceChip(
      label: Text(label),
      selected: isActive,
      onSelected: (_) => setState(() => filter = label),
      selectedColor: Colors.blue.shade50,
      labelStyle: TextStyle(
        color: isActive ? Colors.blue : Colors.black54,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
