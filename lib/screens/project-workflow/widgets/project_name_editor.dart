import 'package:flutter/material.dart';

class ProjectNameEditor extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final Function(String, String) onEdit;
  const ProjectNameEditor({super.key, required this.initialName, required this.initialDescription, required this.onEdit});

  @override
  State<ProjectNameEditor> createState() => _ProjectNameEditorState();
}

class _ProjectNameEditorState extends State<ProjectNameEditor> {
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;

  @override
  void initState() {
    nameCtrl = TextEditingController(text: widget.initialName);
    descCtrl = TextEditingController(text: widget.initialDescription);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: "Project Name"),
              onSubmitted: (_) => widget.onEdit(nameCtrl.text, descCtrl.text),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              onSubmitted: (_) => widget.onEdit(nameCtrl.text, descCtrl.text),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => widget.onEdit(nameCtrl.text, descCtrl.text),
                child: const Text("Save"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
