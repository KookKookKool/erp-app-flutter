import 'package:flutter/material.dart';

class ProjectNameEditor extends StatefulWidget {
  final String name;
  final String description;
  final Function(String, String) onChanged;
  const ProjectNameEditor({
    super.key,
    required this.name,
    required this.description,
    required this.onChanged,
  });

  @override
  State<ProjectNameEditor> createState() => _ProjectNameEditorState();
}

class _ProjectNameEditorState extends State<ProjectNameEditor> {
  late TextEditingController _nameCtrl;
  late TextEditingController _descCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.name);
    _descCtrl = TextEditingController(text: widget.description);
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _descCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameCtrl,
              decoration: const InputDecoration(labelText: "Project Name"),
              onChanged: (v) => widget.onChanged(v, _descCtrl.text),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _descCtrl,
              maxLines: 2,
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (v) => widget.onChanged(_nameCtrl.text, v),
            ),
          ],
        ),
      ),
    );
  }
}
