import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'widgets/project_name_editor.dart';
import 'widgets/project_stakeholders.dart';
import 'widgets/task_checklist.dart';
import 'widgets/comment_section.dart';
import 'widgets/activity_log.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  late Map<String, dynamic> project;

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    project = mockProjectList.firstWhere((p) => p['id'] == widget.projectId);
  }

  void _updateProject(Map<String, dynamic> updates) {
    setState(() {
      project.addAll(updates);
    });
  }

  void _addLog(String action) {
    setState(() {
      project['activitylog'].insert(0, {
        "user": "E001", // ปรับเป็น user ปัจจุบันหากมีระบบ login
        "action": action,
        "date": DateTime.now().toString().substring(0, 16),
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    _loadProject();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Detail"),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              // ลบ project
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Delete Project"),
                  content: const Text("Are you sure to delete this project?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        mockProjectList.removeWhere((p) => p['id'] == widget.projectId);
                        Navigator.pop(context);
                        Navigator.pop(context);
                      },
                      child: const Text("Delete", style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(18),
        children: [
          ProjectNameEditor(
            name: project['name'],
            description: project['description'] ?? "",
            onChanged: (name, desc) {
              _updateProject({"name": name, "description": desc});
              _addLog("Edit project name/description");
            },
          ),
          const SizedBox(height: 16),
          ProjectStakeholders(
            project: project,
            onUpdate: (departments, members, responsible) {
              _updateProject({
                "departments": departments,
                "members": members,
                "responsible": responsible,
              });
              _addLog("Edit stakeholders");
            },
          ),
          const SizedBox(height: 18),
          TaskChecklist(
            tasks: List<Map<String, dynamic>>.from(project['tasks']),
            progress: project['progress'] ?? 0.0,
            onChanged: (tasks, progress) {
              _updateProject({"tasks": tasks, "progress": progress});
              _addLog("Edit tasks/progress");
            },
          ),
          const SizedBox(height: 20),
          CommentSection(
            comments: List<Map<String, dynamic>>.from(project['comments']),
            onAdd: (comment) {
              setState(() {
                project['comments'].insert(0, comment);
              });
              _addLog("Add comment");
            },
            onEdit: (idx, newComment) {
              setState(() {
                project['comments'][idx] = newComment;
              });
              _addLog("Edit comment");
            },
            onDelete: (idx) {
              setState(() {
                project['comments'][idx]['deleted'] = true;
              });
              _addLog("Delete comment");
            },
          ),
          const SizedBox(height: 20),
          ActivityLog(logs: List<Map<String, dynamic>>.from(project['activitylog'])),
        ],
      ),
    );
  }
}
