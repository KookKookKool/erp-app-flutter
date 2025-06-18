import 'package:flutter/material.dart';
import 'profile_card.dart';
import 'time_card.dart';
import 'checkin_button.dart';
import '../../widgets/app_drawer.dart';
import '../hrm/attendance/leave_request_screen.dart';

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
          CheckInButton(
            checkIn: checkInTime,
            checkOut: checkOutTime,
            onPressed: handleCheckInOut,
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.event_note),
                label: const Text("ลางาน"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange, // เปลี่ยนสีปุ่มได้
                ),
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LeaveRequestScreen(
                        empId: mockProfile['empId'] ?? '',
                        empName: mockProfile['name'] ?? '',
                        // ส่งข้อมูลอื่นๆ ที่จำเป็น
                      ),
                    ),
                  );
                  if (result != null && result is Map<String, dynamic>) {
                    // TODO: บันทึก/ส่ง result ไปที่โมดูลลา
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("ส่งคำขอลาสำเร็จ")),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
