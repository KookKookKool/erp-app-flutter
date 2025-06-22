import 'package:flutter/material.dart';

class TaskChecklist extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final double progress;
  final Function(List<Map<String, dynamic>>, double) onChanged;
  const TaskChecklist({
    super.key,
    required this.tasks,
    required this.progress,
    required this.onChanged,
  });

  @override
  State<TaskChecklist> createState() => _TaskChecklistState();
}

class _TaskChecklistState extends State<TaskChecklist> {
  late List<Map<String, dynamic>> tasks;

  @override
  void initState() {
    super.initState();
    tasks = List<Map<String, dynamic>>.from(widget.tasks);
  }

  void _toggle(int idx) {
    setState(() {
      tasks[idx]['completed'] = !(tasks[idx]['completed'] ?? false);
      _updateProgress();
    });
  }

  void _addTask(String taskName) {
    setState(() {
      tasks.add({'name': taskName, 'completed': false});
      _updateProgress();
    });
  }

  void _removeTask(int idx) {
    setState(() {
      tasks.removeAt(idx);
      _updateProgress();
    });
  }

  void _editTask(int idx, String name) {
    setState(() {
      tasks[idx]['name'] = name;
      widget.onChanged(tasks, _calculateProgress());
    });
  }

  double _calculateProgress() {
    if (tasks.isEmpty) return 0;
    final done = tasks.where((t) => t['completed'] == true).length;
    return done / tasks.length;
  }

  void _updateProgress() {
    final progress = _calculateProgress();
    widget.onChanged(tasks, progress);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Task Checklist", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: _calculateProgress(),
              minHeight: 7,
              backgroundColor: Colors.grey[200],
              color: Colors.blue,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                "Progress: ${(100 * _calculateProgress()).toStringAsFixed(1)}%",
                style: const TextStyle(fontSize: 13),
              ),
            ),
            ...List.generate(tasks.length, (i) {
              final t = tasks[i];
              return ListTile(
                dense: true,
                leading: Checkbox(
                  value: t['completed'] ?? false,
                  onChanged: (_) => _toggle(i),
                ),
                title: GestureDetector(
                  onTap: () async {
                    final newName = await showDialog<String>(
                      context: context,
                      builder: (_) {
                        final ctrl = TextEditingController(text: t['name']);
                        return AlertDialog(
                          title: const Text("Edit Task"),
                          content: TextField(controller: ctrl),
                          actions: [
                            TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                            TextButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text("Save")),
                          ],
                        );
                      },
                    );
                    if (newName != null && newName.isNotEmpty) {
                      _editTask(i, newName);
                    }
                  },
                  child: Text(
                    t['name'] ?? "",
                    style: TextStyle(decoration: t['completed'] == true ? TextDecoration.lineThrough : null),
                  ),
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red, size: 18),
                  onPressed: () => _removeTask(i),
                ),
              );
            }),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: "Add Task",
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (v) {
                        if (v.isNotEmpty) _addTask(v);
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () async {
                      final newTask = await showDialog<String>(
                        context: context,
                        builder: (_) {
                          final ctrl = TextEditingController();
                          return AlertDialog(
                            title: const Text("Add Task"),
                            content: TextField(controller: ctrl, autofocus: true),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
                              TextButton(onPressed: () => Navigator.pop(context, ctrl.text), child: const Text("Add")),
                            ],
                          );
                        },
                      );
                      if (newTask != null && newTask.isNotEmpty) {
                        _addTask(newTask);
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
