import 'package:flutter/material.dart';

class StatusFilterBar extends StatelessWidget {
  final int total, come, absent, leave, late;
  final String? selected;
  final ValueChanged<String?> onSelect;

  const StatusFilterBar({
    super.key,
    required this.total,
    required this.come,
    required this.absent,
    required this.leave,
    required this.late,
    required this.selected,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _StatusFilterBox(label: "ทั้งหมด", value: total, color: Colors.grey, selected: selected == null, onTap: () => onSelect(null)),
        _StatusFilterBox(label: "มา", value: come, color: Colors.green, selected: selected == "ปกติ", onTap: () => onSelect("ปกติ")),
        _StatusFilterBox(label: "ขาด", value: absent, color: Colors.red, selected: selected == "ขาด", onTap: () => onSelect("ขาด")),
        _StatusFilterBox(label: "ลา", value: leave, color: Colors.orange, selected: selected == "ลา", onTap: () => onSelect("ลา")),
        _StatusFilterBox(label: "สาย", value: late, color: Colors.blue, selected: selected == "สาย", onTap: () => onSelect("สาย")),
      ],
    );
  }
}

class _StatusFilterBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  final bool selected;
  final VoidCallback onTap;

  const _StatusFilterBox({
    required this.label,
    required this.value,
    required this.color,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? color.withOpacity(0.18) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? color : Colors.grey.shade300),
        ),
        child: Column(
          children: [
            Text("$value", style: TextStyle(fontSize: 17, color: color, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(fontSize: 12, color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
