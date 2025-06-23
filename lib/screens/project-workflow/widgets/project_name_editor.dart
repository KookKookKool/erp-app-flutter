import 'package:flutter/material.dart';

class ProjectNameEditor extends StatefulWidget {
  final String initialName;
  final String initialDescription;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(String, String, DateTime?, DateTime?) onEdit;

  const ProjectNameEditor({
    super.key,
    required this.initialName,
    required this.initialDescription,
    required this.onEdit,
    this.initialStartDate,
    this.initialEndDate,
  });

  @override
  State<ProjectNameEditor> createState() => _ProjectNameEditorState();
}

class _ProjectNameEditorState extends State<ProjectNameEditor> {
  late TextEditingController nameCtrl;
  late TextEditingController descCtrl;
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    nameCtrl = TextEditingController(text: widget.initialName);
    descCtrl = TextEditingController(text: widget.initialDescription);
    startDate = widget.initialStartDate;
    endDate = widget.initialEndDate;
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
              onChanged: (_) => widget.onEdit(
                nameCtrl.text,
                descCtrl.text,
                startDate,
                endDate,
              ),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: "Description"),
              onChanged: (_) => widget.onEdit(
                nameCtrl.text,
                descCtrl.text,
                startDate,
                endDate,
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: startDate ?? DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => startDate = picked);
                        widget.onEdit(
                          nameCtrl.text,
                          descCtrl.text,
                          startDate,
                          endDate,
                        );
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "Start Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        startDate != null
                            ? "${startDate!.day}/${startDate!.month}/${startDate!.year}"
                            : "เลือกวันที่เริ่ม",
                        style: TextStyle(
                          color: startDate != null
                              ? Colors.black87
                              : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: endDate ?? (startDate ?? DateTime.now()),
                        firstDate: startDate ?? DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (picked != null) {
                        setState(() => endDate = picked);
                        widget.onEdit(
                          nameCtrl.text,
                          descCtrl.text,
                          startDate,
                          endDate,
                        );
                      }
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: "End Date",
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      child: Text(
                        endDate != null
                            ? "${endDate!.day}/${endDate!.month}/${endDate!.year}"
                            : "เลือกวันที่จบ",
                        style: TextStyle(
                          color: endDate != null ? Colors.black87 : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
