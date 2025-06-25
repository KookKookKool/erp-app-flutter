import 'package:flutter/material.dart';
import 'package:erp_app/utils/status_utils.dart';

class TaskChecklist extends StatefulWidget {
  final List<Map<String, dynamic>> tasks;
  final void Function(List<Map<String, dynamic>>) onUpdate;

  const TaskChecklist({super.key, required this.tasks, required this.onUpdate});

  @override
  State<TaskChecklist> createState() => _TaskChecklistState();
}

class _TaskChecklistState extends State<TaskChecklist> {
  late List<Map<String, dynamic>> tasks;
  bool editMode = false;

  @override
  void initState() {
    tasks = List<Map<String, dynamic>>.from(widget.tasks);
    super.initState();
  }

  double get percent => tasks.isEmpty
      ? 0.0
      : tasks.where((t) => t["completed"] == true).length / tasks.length;

  void addTask(String name) {
    setState(() {
      tasks.add({"name": name, "completed": false});
      widget.onUpdate(tasks);
    });
  }

  void updateTask(int idx, bool? val) {
    setState(() {
      tasks[idx]["completed"] = val ?? false;
      widget.onUpdate(tasks);
    });
  }

  void removeTask(int idx) {
    setState(() {
      tasks.removeAt(idx);
      widget.onUpdate(tasks);
    });
  }

  String get status {
    final completed = tasks.where((t) => t["completed"] == true).length;
    final total = tasks.length;
    if (total == 0) return "Not Started";
    if (completed == total) return "Done";
    if (completed > 0) return "Processing";
    return "Not Started";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      "Task Checklist",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${(percent * 100).toStringAsFixed(0)}%",
                      style: const TextStyle(color: Colors.blue),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.add_circle),
                      onPressed: () async {
                        String? newTask = await showDialog<String>(
                          context: context,
                          builder: (ctx) {
                            final ctrl = TextEditingController();
                            return AlertDialog(
                              title: const Text("เพิ่ม Task"),
                              content: TextField(
                                controller: ctrl,
                                decoration: const InputDecoration(
                                  hintText: "Task name",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(ctx),
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(ctx, ctrl.text),
                                  child: const Text("OK"),
                                ),
                              ],
                            );
                          },
                        );
                        if (newTask != null && newTask.trim().isNotEmpty) {
                          addTask(newTask.trim());
                        }
                      },
                    ),
                  ],
                ),
                LinearProgressIndicator(value: percent, minHeight: 8),
                ...tasks.asMap().entries.map(
                  (entry) => Dismissible(
                    key: ValueKey(entry.key),
                    direction: DismissDirection.endToStart,
                    onDismissed: (_) => removeTask(entry.key),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 14),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: CheckboxListTile(
                            value: entry.value["completed"] ?? false,
                            title: Text(entry.value["name"] ?? ""),
                            onChanged: (v) => updateTask(entry.key, v),
                          ),
                        ),
                        if (editMode)
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.redAccent,
                            ),
                            onPressed: () => removeTask(entry.key),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
                    children: [
                      _StatusBadge(status: status),
                      const Spacer(),
                      PopupMenuButton<String>(
                        icon: const Icon(Icons.edit),
                        tooltip: editMode ? "ปิดโหมดแก้ไข" : "แก้ไขรายการ",
                        onSelected: (value) {
                          if (value == 'edit') {
                            setState(() => editMode = !editMode);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            value: 'edit',
                            child: Text(
                              editMode ? "ปิดโหมดแก้ไข" : "แก้ไขรายการ",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
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
