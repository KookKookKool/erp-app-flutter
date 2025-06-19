import 'package:flutter/material.dart';
import 'profile_card.dart';
import 'time_card.dart';
import 'checkin_button.dart';
import 'package:erp_app/widgets/app_drawer.dart';
import 'package:erp_app/screens/hrm/attendance/leave_request_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // mock ข้อมูลพนักงาน
  final mockProfile = {
    "empId": "EMP001",
    "name": "ศิริพร ใจดี",
    "nickname": "ฝ้าย",
    "level": "Senior",
    "position": "HR Manager",
    "email": "faijai@gmail.com",
    "phone": "081-234-5678",
    "profilePic": "https://i.pravatar.cc/300?img=5",
    "startDate": "2020-01-20",
  };

  // mock ข้อมูลเวลาเข้า-ออก
  DateTime? checkInTime;
  DateTime? checkOutTime;

  void handleCheckInOut() {
    setState(() {
      if (checkInTime == null) {
        checkInTime = DateTime.now();
      } else if (checkOutTime == null) {
        checkOutTime = DateTime.now();
      } else {
        // รีเซ็ต demo (จริงควรปิดปุ่ม)
        checkInTime = null;
        checkOutTime = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(), // เมนูเบอร์เกอร์
      appBar: AppBar(
        title: const Text("โปรไฟล์พนักงาน"),
        centerTitle: true,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ProfileCard(profile: mockProfile),
          const SizedBox(height: 32),
          TimeCard(checkIn: checkInTime, checkOut: checkOutTime),
          const SizedBox(height: 24),
          // <<<-- ปุ่มบันทึกเวลา & ลางาน อยู่แถวเดียวกัน
          Row(
            children: [
              // ปุ่มบันทึกเวลา (ซ้าย)
              Expanded(
                child: CheckInButton(
                  checkIn: checkInTime,
                  checkOut: checkOutTime,
                  onPressed: handleCheckInOut,
                ),
              ),
              const SizedBox(width: 12),
              // ปุ่มลางาน (ขวา)
              Expanded(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.event_note),
                  label: const Text("ลางาน"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => LeaveRequestScreen(
                          empId: mockProfile['empId'] ?? '',
                          empName: mockProfile['name'] ?? '',
                        ),
                      ),
                    );
                    if (result != null && result is Map<String, dynamic>) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("ส่งคำขอลาสำเร็จ")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
          // --- จบ Row ปุ่มคู่
        ],
      ),
    );
  }
}
