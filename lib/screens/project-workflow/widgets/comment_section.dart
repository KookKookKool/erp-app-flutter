import 'package:flutter/material.dart';

class CommentSection extends StatefulWidget {
  final List<Map<String, dynamic>> comments;
  final Function(Map<String, dynamic>) onAdd;
  final Function(int, Map<String, dynamic>) onEdit;
  final Function(int) onDelete;
  const CommentSection({
    super.key,
    required this.comments,
    required this.onAdd,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  State<CommentSection> createState() => _CommentSectionState();
}

class _CommentSectionState extends State<CommentSection> {
  final _controller = TextEditingController();
  String? _attachedFile;

  void _addComment() {
    if (_controller.text.trim().isEmpty) return;
    final cmt = {
      "user": "E001",
      "text": _controller.text,
      "createdAt": DateTime.now().toString().substring(0, 16),
      "file": _attachedFile,
      "editedAt": null,
      "deleted": false,
    };
    widget.onAdd(cmt);
    _controller.clear();
    setState(() => _attachedFile = null);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Comments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ListView.builder(
              shrinkWrap: true,
              reverse: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.comments.length,
              itemBuilder: (ctx, i) {
                final c = widget.comments[i];
                if (c['deleted'] == true) {
                  return ListTile(
                    leading: const Icon(Icons.delete_forever, color: Colors.grey),
                    title: const Text("ความคิดเห็นนี้ถูกลบแล้ว", style: TextStyle(color: Colors.grey)),
                  );
                }
                return ListTile(
                  leading: const CircleAvatar(radius: 16, child: Icon(Icons.person)),
                  title: Row(
                    children: [
                      Text(c['user']),
                      if (c['editedAt'] != null)
                        Text(" (แก้ไข ${c['editedAt']})", style: const TextStyle(fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(c['text'] ?? ""),
                      if (c['file'] != null) Row(
                        children: [
                          const Icon(Icons.attach_file, size: 14),
                          Text(c['file']),
                        ],
                      ),
                      Text(c['createdAt'], style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                  trailing: PopupMenuButton(
                    onSelected: (v) async {
                      if (v == "edit") {
                        final ctrl = TextEditingController(text: c['text']);
                        final newText = await showDialog<String>(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text("Edit Comment"),
                            content: TextField(controller: ctrl),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                              TextButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text("Save")),
                            ],
                          ),
                        );
                        if (newText != null) {
                          final newCmt = {...c, "text": newText, "editedAt": DateTime.now().toString().substring(0, 16)};
                          widget.onEdit(i, newCmt);
                        }
                      } else if (v == "delete") {
                        widget.onDelete(i);
                      }
                    },
                    itemBuilder: (ctx) => [
                      const PopupMenuItem(value: "edit", child: Text("Edit")),
                      const PopupMenuItem(value: "delete", child: Text("Delete")),
                    ],
                  ),
                );
              },
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: "Add a comment...",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.attach_file),
                  onPressed: () async {
                    // mock แนบไฟล์จริงควรใช้ file_picker
                    final fileName = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        final ctrl = TextEditingController();
                        return AlertDialog(
                          title: const Text("แนบไฟล์"),
                          content: TextField(controller: ctrl, decoration: const InputDecoration(hintText: "ชื่อไฟล์")),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text("OK")),
                          ],
                        );
                      },
                    );
                    if (fileName != null && fileName.isNotEmpty) {
                      setState(() => _attachedFile = fileName);
                    }
                  },
                ),
                ElevatedButton(
                  onPressed: _addComment,
                  child: const Text("ส่ง"),
                ),
              ],
            ),
            if (_attachedFile != null) Text("แนบ: $_attachedFile"),
          ],
        ),
      ),
    );
  }
}
