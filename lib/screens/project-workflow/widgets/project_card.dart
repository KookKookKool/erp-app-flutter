import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';
import 'package:erp_app/utils/status_utils.dart';

class ProjectCard extends StatelessWidget {
  final Map<String, dynamic> project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

  @override
  Widget build(BuildContext context) {
    final tasks = project["tasks"] ?? [];
    final completed = tasks.where((t) => t["completed"] == true).length;
    final total = tasks.length;
    final progress = total > 0 ? completed / total : 0.0;

    // ดึงวันที่จาก project
    String? startDateStr = project["startDate"];
    String? dueDateStr = project["dueDate"];
    String startDate = startDateStr != null ? _formatDate(startDateStr) : "-";
    String dueDate = dueDateStr != null ? _formatDate(dueDateStr) : "-";

    // Status logic
    String status = (() {
      if (tasks.isEmpty) return "Not Started";
      if (completed == total && total > 0) return "Done";
      if (completed > 0) return "Processing";
      return "Not Started";
    })();

    // Member Avatars (from mockEmployeeList)
    final members = (project["members"] as List?)?.cast<String>() ?? [];
    final memberAvatars = members.take(3).map((id) {
      final emp = mockEmployeeList.firstWhere(
        (e) => e["empId"] == id,
        orElse: () => <String, dynamic>{},
      );
      return Padding(
        padding: const EdgeInsets.only(right: 2.0),
        child: CircleAvatar(
          radius: 12,
          backgroundImage: emp["profilePic"] != null
              ? NetworkImage(emp["profilePic"])
              : null,
          child:
              (emp["profilePic"] == null ||
                  emp["profilePic"].toString().isEmpty)
              ? Text(emp["name"]?[0] ?? "?")
              : null,
        ),
      );
    }).toList();

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 1.5,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Project name + Status badge
              Row(
                children: [
                  Expanded(
                    child: Text(
                      project["name"] ?? "",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  _StatusBadge(status: status),
                ],
              ),
              const SizedBox(height: 6),
              // Dates
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 13, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    "Start: $startDate  Due: $dueDate",
                    style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Progress & Task summary
              Row(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        width: 38,
                        height: 38,
                        child: CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 5,
                          backgroundColor: Colors.grey.shade200,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            progress == 1.0
                                ? Colors.green
                                : (progress > 0 ? Colors.orange : Colors.grey),
                          ),
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),
                  Text(
                    "$completed/$total Task${total > 1 ? "s" : ""}",
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                  ),
                  const Spacer(),
                  ...memberAvatars,
                  if (members.length > 3)
                    CircleAvatar(
                      radius: 12,
                      backgroundColor: Colors.grey[300],
                      child: Text(
                        "+${members.length - 3}",
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  const SizedBox(width: 8),
                  const Icon(Icons.chevron_right, size: 22, color: Colors.grey),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return "${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}";
    } catch (_) {
      return iso;
    }
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final color = StatusUtils.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
