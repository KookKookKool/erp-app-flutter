// D:\flutter\erp_app\lib\screens\project-workflow\widgets\project_stakeholders.dart
import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ProjectStakeholders extends StatefulWidget {
  final String responsibleId;
  final List<String> departments;
  final List<String> members;
  final Function(
    String newResponsible,
    List<String> departments,
    List<String> members,
  )
  onChanged;

  const ProjectStakeholders({
    super.key,
    required this.responsibleId,
    required this.departments,
    required this.members,
    required this.onChanged,
  });

  @override
  State<ProjectStakeholders> createState() => _ProjectStakeholdersState();
}

class _ProjectStakeholdersState extends State<ProjectStakeholders> {
  late String responsibleId;
  late List<String> departments;
  late List<String> members;

  @override
  void initState() {
    super.initState();
    responsibleId = widget.responsibleId;
    departments = List<String>.from(widget.departments);
    members = List<String>.from(widget.members);
  }

  void _update() {
    widget.onChanged(responsibleId, departments, members);
  }

  Future<void> _selectResponsible() async {
    final newId = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text("เลือกผู้รับผิดชอบ"),
        children: mockEmployeeList.map((e) {
          return SimpleDialogOption(
            onPressed: () => Navigator.pop(ctx, e["empId"]),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundImage: e["profilePic"] != null
                      ? NetworkImage(e["profilePic"]!)
                      : null,
                  child:
                      (e["profilePic"] == null ||
                          e["profilePic"].toString().isEmpty)
                      ? Text(e["name"]?[0] ?? "?")
                      : null,
                ),
                const SizedBox(width: 10),
                Text(e["name"] ?? ""),
              ],
            ),
          );
        }).toList(),
      ),
    );
    if (newId != null && newId.isNotEmpty) {
      setState(() {
        responsibleId = newId;
        // (Optionally: auto-add to members)
        if (!members.contains(newId)) {
          members.add(newId);
        }
        _update();
      });
    }
  }

  Future<void> _selectDepartments() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (ctx) {
        final tmp = Set<String>.from(
          departments,
        ); // departments คือ List<String> ปัจจุบัน
        return AlertDialog(
          title: const Text("เลือกฝ่ายที่เกี่ยวข้อง"),
          content: SizedBox(
            width: 320,
            child: StatefulBuilder(
              builder: (context, setInnerState) => ListView(
                shrinkWrap: true,
                children: mockDepartmentList.map<Widget>((d) {
                  return CheckboxListTile(
                    value: tmp.contains(d["id"]),
                    title: Text(d["name"] ?? ""),
                    onChanged: (v) {
                      setInnerState(() {
                        if (v == true) {
                          tmp.add((d["id"] ?? "").toString());
                        } else {
                          tmp.remove(d["id"]);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, tmp.toList()),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    if (selected != null) {
      setState(() {
        departments = selected;
        _update(); // ถ้ามีฟังก์ชัน update ให้เรียกต่อท้าย
      });
    }
  }

  Future<void> _selectMembers() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (ctx) {
        final tmp = Set<String>.from(
          members,
        ); // members คือ List<String> ปัจจุบัน
        return AlertDialog(
          title: const Text("เลือกบุคคลที่เกี่ยวข้อง"),
          content: SizedBox(
            width: 320,
            child: StatefulBuilder(
              builder: (context, setInnerState) => ListView(
                shrinkWrap: true,
                children: mockEmployeeList.map<Widget>((e) {
                  return CheckboxListTile(
                    value: tmp.contains(e["empId"]),
                    title: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundImage: e["profilePic"] != null
                              ? NetworkImage(e["profilePic"]!)
                              : null,
                          child:
                              (e["profilePic"] == null ||
                                  e["profilePic"].toString().isEmpty)
                              ? Text(e["name"]?[0] ?? "?")
                              : null,
                        ),
                        const SizedBox(width: 8),
                        Text(e["name"] ?? ""),
                      ],
                    ),
                    onChanged: (v) {
                      setInnerState(() {
                        if (v == true) {
                          tmp.add(e["empId"]);
                        } else {
                          tmp.remove(e["empId"]);
                        }
                      });
                    },
                  );
                }).toList(),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, null),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () => Navigator.pop(ctx, tmp.toList()),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
    if (selected != null) {
      setState(() {
        members = selected;
        _update(); // ถ้ามีฟังก์ชัน update ให้เรียกต่อท้าย
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsible = mockEmployeeList.firstWhere(
      (e) => e["empId"] == responsibleId,
      orElse: () => <String, dynamic>{},
    );
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ผู้รับผิดชอบ
            Row(
              children: [
                const Text(
                  "ผู้รับผิดชอบ:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                responsible.isNotEmpty
                    ? Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: responsible["profilePic"] != null
                                ? NetworkImage(responsible["profilePic"]!)
                                : null,
                            child:
                                (responsible["profilePic"] == null ||
                                    responsible["profilePic"]
                                        .toString()
                                        .isEmpty)
                                ? Text(responsible["name"]?[0] ?? "?")
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(responsible["name"] ?? ""),
                        ],
                      )
                    : const Text("-", style: TextStyle(color: Colors.grey)),
                const Spacer(),
                TextButton.icon(
                  onPressed: _selectResponsible,
                  icon: const Icon(Icons.edit, size: 18),
                  label: const Text("เปลี่ยน"),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ฝ่ายที่เกี่ยวข้อง
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "ฝ่าย:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 7),
                Expanded(
                  child: Wrap(
                    spacing: 4,
                    children: [
                      ...departments.map((id) {
                        final dept = mockDepartmentList.firstWhere(
                          (d) => d["id"] == id,
                          orElse: () => <String, String>{},
                        );
                        return Chip(
                          label: Text(dept["name"] ?? "-"),
                          onDeleted: () {
                            setState(() {
                              departments.remove(id);
                              _update();
                            });
                          },
                        );
                      }),
                      ActionChip(
                        label: const Text("เพิ่ม/แก้ไข"),
                        avatar: const Icon(Icons.add, size: 16),
                        onPressed: _selectDepartments,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // บุคคลที่เกี่ยวข้อง
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "บุคคล:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: Wrap(
                    spacing: 2,
                    runSpacing: 2,
                    children: [
                      ...members.map((id) {
                        final emp = mockEmployeeList.firstWhere(
                          (e) => e["empId"] == id,
                          orElse: () => <String, dynamic>{},
                        );
                        return Chip(
                          avatar: CircleAvatar(
                            backgroundImage: emp["profilePic"] != null
                                ? NetworkImage(emp["profilePic"]!)
                                : null,
                            child:
                                (emp["profilePic"] == null ||
                                    emp["profilePic"].toString().isEmpty)
                                ? Text(emp["name"]?[0] ?? "?")
                                : null,
                          ),
                          label: Text(emp["name"] ?? "-"),
                          onDeleted: () {
                            setState(() {
                              members.remove(id);
                              _update();
                            });
                          },
                        );
                      }),
                      ActionChip(
                        label: const Text("เพิ่ม/แก้ไข"),
                        avatar: const Icon(Icons.add, size: 16),
                        onPressed: _selectMembers,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
