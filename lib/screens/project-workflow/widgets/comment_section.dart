import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class CommentSection extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(Map<String, dynamic>) onAdd;
  final String projectId;

  const CommentSection({super.key, required this.comments, required this.onAdd, required this.projectId});

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final TextEditingController commentController = TextEditingController();

  void addComment(String text) {
    if (text.trim().isEmpty) return;
    // ในตัวอย่าง mock ใส่ E001 เป็น user ตัวอย่าง
    final comment = {
      "user": "E001",
      "text": text,
      "createdAt": DateTime.now().toIso8601String().substring(0, 16).replaceFirst("T", " "),
    };
    widget.onAdd(comment);
    commentController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(hintText: "Add comment..."),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () => addComment(commentController.text),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ...widget.comments.map((c) {
              final user = mockEmployeeList.firstWhere((e) => e["id"] == c["user"], orElse: () => {});
              return ListTile(
                leading: CircleAvatar(radius: 15, backgroundImage: NetworkImage(user["profilePic"] ?? "")),
                title: Text(user["name"] ?? "User", style: const TextStyle(fontSize: 15)),
                subtitle: Text(c["text"] ?? "", style: const TextStyle(fontSize: 14)),
                trailing: Text(c["createdAt"] ?? "", style: const TextStyle(fontSize: 11, color: Colors.grey)),
              );
            }),
          ],
        ),
      ),
    );
  }
}
