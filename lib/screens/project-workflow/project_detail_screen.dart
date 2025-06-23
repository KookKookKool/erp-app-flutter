// lib/screens/project-workflow/project_detail_screen.dart
import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'widgets/project_name_editor.dart';
import 'widgets/project_stakeholders.dart';
import 'widgets/task_checklist.dart';
import 'widgets/comment_section.dart';
import 'widgets/activity_log.dart';
import 'widgets/project_loading_widget.dart';

class ProjectDetailScreen extends StatefulWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  State<ProjectDetailScreen> createState() => _ProjectDetailScreenState();
}

class _ProjectDetailScreenState extends State<ProjectDetailScreen> {
  Map<String, dynamic>? project;
  List<Map<String, dynamic>> comments = [];
  List<Map<String, dynamic>> tasks = [];
  List<Map<String, dynamic>> activitylog = [];

  @override
  void initState() {
    super.initState();
    _loadProject();
  }

  void _loadProject() {
    project = mockProjectList.firstWhere(
      (p) => p['id'] == widget.projectId,
      orElse: () => {},
    );
    comments =
        (project?["comments"] as List?)?.cast<Map<String, dynamic>>() ?? [];
    tasks = (project?["tasks"] as List?)?.cast<Map<String, dynamic>>() ?? [];
    activitylog =
        (project?["activitylog"] as List?)?.cast<Map<String, dynamic>>() ?? [];
  }

  void _onEditName(String name, String desc) {
    setState(() {
      project?["name"] = name;
      project?["description"] = desc;
    });
  }

  void _onUpdateStakeholders(
    String responsible,
    List<String> departments,
    List<String> members,
  ) {
    setState(() {
      project?["responsible"] = responsible;
      project?["departments"] = departments;
      project?["members"] = members;
    });
  }

  void _onUpdateTasks(List<Map<String, dynamic>> newTasks) {
    setState(() {
      project?["tasks"] = newTasks;
    });
  }

  void _onAddComment(Map<String, dynamic> newComment) {
    setState(() {
      comments.insert(0, newComment);
      project?["comments"] = comments;
    });
  }

  void _onUpdateActivityLog(List<Map<String, dynamic>> log) {
    setState(() {
      project?["activitylog"] = log;
    });
  }

@override
Widget build(BuildContext context) {
  if (project == null) {
    return const ProjectLoadingWidget();
  }
  return Scaffold(
    appBar: AppBar(title: const Text("Project Detail")),
    body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProjectNameEditor(
                initialName: project?["name"] ?? "",
                initialDescription: project?["description"] ?? "",
                onEdit: _onEditName,
              ),
              const SizedBox(height: 14),
              ProjectStakeholders(
                responsibleId: project?["responsible"] ?? "",
                departments: List<String>.from(project?["departments"] ?? []),
                members: List<String>.from(project?["members"] ?? []),
                onChanged: _onUpdateStakeholders,
              ),
              const SizedBox(height: 16),
              TaskChecklist(
                tasks: List<Map<String, dynamic>>.from(project?["tasks"] ?? []),
                onUpdate: _onUpdateTasks,
              ),
              const SizedBox(height: 16),
              CommentSection(
                comments: comments,
                onAdd: _onAddComment,
                projectId: widget.projectId,
              ),
              const SizedBox(height: 16),
              ActivityLog(
                activitylog: activitylog,
                onUpdate: _onUpdateActivityLog,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
