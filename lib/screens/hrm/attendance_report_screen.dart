import 'package:flutter/material.dart';
import 'widgets/status_filter_bar.dart';
import 'widgets/attendance_list_item.dart';
import 'widgets/leave_list_item.dart';
import 'leave_approve_screen.dart';

class AttendanceReportScreen extends StatefulWidget {
  const AttendanceReportScreen({super.key});
  @override
  State<AttendanceReportScreen> createState() => _AttendanceReportScreenState();
}

class _AttendanceReportScreenState extends State<AttendanceReportScreen> {
  final List<Map<String, dynamic>> attendanceList = [
    // --- วันใหม่ที่ขอ 2025-06-17 ---
    {
      "date": "2025-06-17",
      "empId": "EMP010",
      "name": "อาภัสรา มาเช้า",
      "checkIn": "08:10",
      "checkOut": "17:00",
      "status": "ปกติ",
    },
    {
      "date": "2025-06-17",
      "empId": "EMP011",
      "name": "สมหมาย สาย",
      "checkIn": "09:22",
      "checkOut": "17:30",
      "status": "สาย",
    },
    {
      "date": "2025-06-17",
      "empId": "EMP012",
      "name": "ประยูร ขาด",
      "checkIn": null,
      "checkOut": null,
      "status": "ขาด",
    },
    {
      "date": "2025-06-17",
      "empId": "EMP013",
      "name": "จิตติมา ลา",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "pending",
        "deductSalary": false,
        "remark": "ขอลาไปธุระด่วน",
      },
    },
    {
      "date": "2025-06-17",
      "empId": "EMP014",
      "name": "นาวี ลาอนุมัติ",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "approved",
        "deductSalary": false,
        "remark": "ลาพักร้อน",
      },
    },
    {
      "date": "2025-06-17",
      "empId": "EMP015",
      "name": "ราตรี ลาไม่อนุมัติ",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "rejected",
        "deductSalary": true,
        "remark": "ขอลาโดยไม่มีเหตุผล",
      },
    },
    // วันแรก
    {
      "date": "2025-06-18",
      "empId": "EMP001",
      "name": "ศิริพร ใจดี",
      "checkIn": "08:36",
      "checkOut": "17:31",
      "status": "ปกติ",
    },
    {
      "date": "2025-06-18",
      "empId": "EMP002",
      "name": "สมชาย เข้ม",
      "checkIn": null,
      "checkOut": null,
      "status": "ขาด",
    },
    {
      "date": "2025-06-18",
      "empId": "EMP003",
      "name": "ปาริชาติ ลา",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "pending",
        "deductSalary": false,
        "remark": "ขอลางานแต่งเพื่อน",
      },
    },
    // วันสอง
    {
      "date": "2025-06-19",
      "empId": "EMP004",
      "name": "สมใจ สาย",
      "checkIn": "09:30",
      "checkOut": "17:42",
      "status": "สาย",
    },
    {
      "date": "2025-06-19",
      "empId": "EMP005",
      "name": "วีระพงศ์ ใจดี",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "approved",
        "deductSalary": false,
        "remark": "ลาไปพบหมอ",
      },
    },
    // วันสาม
    {
      "date": "2025-06-20",
      "empId": "EMP003",
      "name": "ปาริชาติ ลา",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "approved",
        "deductSalary": false,
        "remark": "ลาวันเกิด",
      },
    },
    {
      "date": "2025-06-20",
      "empId": "EMP006",
      "name": "นัทธมน ลา",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "pending",
        "deductSalary": false,
        "remark": "ลากิจ 1 วัน",
      },
    },
    // วันสี่
    {
      "date": "2025-06-21",
      "empId": "EMP003",
      "name": "ปาริชาติ ลา",
      "checkIn": null,
      "checkOut": null,
      "status": "ลา",
      "leave": {
        "approveStatus": "rejected",
        "deductSalary": true,
        "remark": "ลาบ่อย",
      },
    },
    {
      "date": "2025-06-21",
      "empId": "EMP007",
      "name": "พรทิพย์ มา",
      "checkIn": "08:25",
      "checkOut": "17:02",
      "status": "ปกติ",
    },
  ];

  String searchText = "";
  DateTime selectedDate = DateTime.now();
  String? filterStatus;

  // เฉพาะลา
  bool showAllLeave = false;

  String leaveDropdownFilter = "all"; // ตัวแปรสถานะที่เลือกใน dropdown
  final leaveStatusDropdownOptions = [
    {"value": "all", "label": "สถานะการลา: ทั้งหมด"},
    {"value": "pending", "label": "รอดำเนินการ"},
    {"value": "approved", "label": "อนุมัติ"},
    {"value": "rejected", "label": "ไม่อนุมัติ"},
  ];

  Set<String> leaveStatusFilters = {};

  @override
  Widget build(BuildContext context) {
    final dateStr =
        "${selectedDate.year.toString().padLeft(4, '0')}-"
        "${selectedDate.month.toString().padLeft(2, '0')}-"
        "${selectedDate.day.toString().padLeft(2, '0')}";

    // === กรองข้อมูลหลัก ===
    final filtered = attendanceList.where((row) {
      final matchSearch =
          row['name'].toString().contains(searchText) ||
          row['empId'].toString().contains(searchText);

      if (filterStatus == "ลา") {
        final matchDate = showAllLeave ? true : row['date'] == dateStr;
        final isLeave = row['status'] == "ลา";
        final leave = row['leave'] ?? {};
        final approveStatus = leave['approveStatus'] ?? "pending";
        final matchLeaveStatus =
            leaveDropdownFilter == "all" ||
            leaveDropdownFilter == approveStatus;

        return isLeave && matchSearch && matchDate && matchLeaveStatus;
      } else if (filterStatus != null) {
        final matchStatus = row['status'] == filterStatus;
        final matchDate = row['date'] == dateStr;
        return matchStatus && matchSearch && matchDate;
      } else {
        final matchDate = row['date'] == dateStr;
        return matchSearch && matchDate;
      }
    }).toList();

    // === Summary (เฉพาะวันเดียว) ===
    int total = attendanceList.where((e) => e['date'] == dateStr).length;
    int come = attendanceList
        .where((e) => e['date'] == dateStr && e['status'] == "ปกติ")
        .length;
    int absent = attendanceList
        .where((e) => e['date'] == dateStr && e['status'] == "ขาด")
        .length;
    int leave = attendanceList
        .where((e) => e['date'] == dateStr && e['status'] == "ลา")
        .length;
    int late = attendanceList
        .where((e) => e['date'] == dateStr && e['status'] == "สาย")
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text("รายงานการเข้างาน")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: "ค้นหาชื่อ/รหัสพนักงาน",
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => setState(() => searchText = v),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime(2024, 1, 1),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) setState(() => selectedDate = picked);
                  },
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    "${selectedDate.day}/${selectedDate.month}/${selectedDate.year + 543}",
                    style: const TextStyle(fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            child: StatusFilterBar(
              total: total,
              come: come,
              absent: absent,
              leave: leave,
              late: late,
              selected: filterStatus,
              onSelect: (val) => setState(() => filterStatus = val),
            ),
          ),
          if (filterStatus == "ลา")
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                children: [
                  Checkbox(
                    value: showAllLeave,
                    onChanged: (v) => setState(() => showAllLeave = v ?? false),
                  ),
                  const Text("ดูการลาทุกวัน"),
                  const SizedBox(width: 16),
                  DropdownButton<String>(
                    value: leaveDropdownFilter,
                    items: leaveStatusDropdownOptions
                        .map(
                          (item) => DropdownMenuItem(
                            value: item["value"],
                            child: Text(item["label"]!),
                          ),
                        )
                        .toList(),
                    onChanged: (val) =>
                        setState(() => leaveDropdownFilter = val ?? "all"),
                  ),
                ],
              ),
            ),

          const Divider(),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text("ไม่พบข้อมูล"))
                : ListView.builder(
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final row = filtered[i];
                      if (filterStatus == "ลา") {
                        // แสดงข้อมูลลา
                        return LeaveListItem(
                          data: row,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LeaveApproveScreen(
                                  leaveRecord: row,
                                  onUpdate: (result) {
                                    setState(() {
                                      row['leave'] = result['leave'];
                                    });
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      } else {
                        // แสดงข้อมูลเข้างาน/ขาด/สาย
                        return AttendanceListItem(data: row);
                      }
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.picture_as_pdf),
                label: const Text("ส่งออกเป็น PDF"),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("กำลังพัฒนาฟีเจอร์ PDF")),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
