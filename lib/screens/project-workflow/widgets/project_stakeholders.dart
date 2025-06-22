import 'package:flutter/material.dart';
import 'package:erp_app/utils/mock_data.dart';

class ProjectStakeholders extends StatefulWidget {
  final Map<String, dynamic> project;
  final Function(List<String>, List<String>, String) onUpdate;
  const ProjectStakeholders({
    super.key,
    required this.project,
    required this.onUpdate,
  });

  @override
  State<ProjectStakeholders> createState() => _ProjectStakeholdersState();
}

class _ProjectStakeholdersState extends State<ProjectStakeholders> {
  late List<String> departments;
  late List<String> members;
  late String responsible;

  @override
  void initState() {
    super.initState();
    departments = List<String>.from(widget.project['departments']);
    members = List<String>.from(widget.project['members']);
    responsible = widget.project['responsible'] ?? "";
  }

  void _selectDepartments() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (ctx) {
        final tmp = Set<String>.from(departments);
        return AlertDialog(
          title: const Text("ฝ่ายเกี่ยวข้อง"),
          content: SizedBox(
            width: 260,
            child: ListView(
              shrinkWrap: true,
              children: mockDepartmentList.map((d) {
                final deptId = d['id'];
                return CheckboxListTile(
                  value:
                      tmp.contains(deptId) ||
                      tmp.contains(deptId?.toLowerCase()),
                  title: Text(d['name'] ?? ''),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        tmp.add(deptId!);
                      } else {
                        tmp.remove(deptId);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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
      setState(() => departments = selected);
      widget.onUpdate(departments, members, responsible);
    }
  }

  void _selectMembers() async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (ctx) {
        final tmp = Set<String>.from(members);
        return AlertDialog(
          title: const Text("บุคคลที่เกี่ยวข้อง"),
          content: SizedBox(
            width: 260,
            child: ListView(
              shrinkWrap: true,
              children: mockEmployeeList.map((e) {
                return CheckboxListTile(
                  value: tmp.contains(e['id']),
                  title: Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundImage: NetworkImage(e['profilePic'] ?? ""),
                      ),
                      const SizedBox(width: 8),
                      Text(e['name']),
                    ],
                  ),
                  onChanged: (v) {
                    setState(() {
                      if (v == true) {
                        tmp.add(e['id']);
                      } else {
                        tmp.remove(e['id']);
                      }
                    });
                  },
                );
              }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
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
      setState(() => members = selected);
      widget.onUpdate(departments, members, responsible);
    }
  }

  void _selectResponsible() async {
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text("เลือกผู้รับผิดชอบ"),
          children: mockEmployeeList.map((e) {
            return SimpleDialogOption(
              onPressed: () => Navigator.pop(ctx, e['id']),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 13,
                    backgroundImage: NetworkImage(e['profilePic'] ?? ""),
                  ),
                  const SizedBox(width: 10),
                  Text(e['name']),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
    if (selected != null) {
      setState(() => responsible = selected);
      widget.onUpdate(departments, members, responsible);
    }
  }

  @override
  Widget build(BuildContext context) {
    final responsibleEmp = mockEmployeeList.firstWhere(
      (e) => e['id'] == responsible,
      orElse: () => {},
    );
    final memberAvatars = members.map((id) {
      final e = mockEmployeeList.firstWhere(
        (em) => em['id'] == id,
        orElse: () => {},
      );
      return e != {}
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: CircleAvatar(
                radius: 13,
                backgroundImage: NetworkImage(e['profilePic'] ?? ""),
              ),
            )
          : Container();
    }).toList();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  "ผู้รับผิดชอบ:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 8),
                responsibleEmp != {}
                    ? GestureDetector(
                        onTap: _selectResponsible,
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 16,
                              backgroundImage: NetworkImage(
                                responsibleEmp['profilePic'] ?? "",
                              ),
                            ),
                            const SizedBox(width: 7),
                            Text(responsibleEmp['name']),
                            const Icon(
                              Icons.edit,
                              size: 18,
                              color: Colors.orange,
                            ),
                          ],
                        ),
                      )
                    : TextButton.icon(
                        icon: const Icon(Icons.add),
                        label: const Text("เลือก"),
                        onPressed: _selectResponsible,
                      ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Text(
                  "ฝ่ายเกี่ยวข้อง:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 7),
                ...departments.map((id) {
                  final d = mockDepartmentList.firstWhere(
                    (dept) => dept['id'] == id,
                    orElse: () => {},
                  );
                  return d != {}
                      ? Chip(
                          label: Text(d['name'] ?? ''),
                          onDeleted: () {
                            setState(() {
                              departments.remove(id);
                              widget.onUpdate(
                                departments,
                                members,
                                responsible,
                              );
                            });
                          },
                        )
                      : Container();
                }),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _selectDepartments,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "บุคคลที่เกี่ยวข้อง:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(width: 5),
                ...memberAvatars.take(5),
                if (memberAvatars.length > 5)
                  Padding(
                    padding: const EdgeInsets.only(left: 2),
                    child: InkWell(
                      child: CircleAvatar(
                        radius: 13,
                        child: Text(
                          "+${memberAvatars.length - 5}",
                          style: const TextStyle(fontSize: 11),
                        ),
                      ),
                      onTap: _selectMembers,
                    ),
                  ),
                IconButton(
                  icon: const Icon(Icons.add_circle),
                  onPressed: _selectMembers,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
