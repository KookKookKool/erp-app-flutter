import 'package:flutter/material.dart';
import 'profile_card.dart';
import 'time_card.dart';
import 'checkin_button.dart';
import 'package:erp_app/screens/hrm/attendance/leave_request_screen.dart';

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
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

  DateTime? checkInTime;
  DateTime? checkOutTime;

  void handleCheckInOut() {
    setState(() {
      if (checkInTime == null) {
        checkInTime = DateTime.now();
      } else if (checkOutTime == null) {
        checkOutTime = DateTime.now();
      } else {
        checkInTime = null;
        checkOutTime = null;
      }
    });
  }

  
  
  @override
  Widget build(BuildContext context) {
    final isLargeScreen = MediaQuery.of(context).size.width >= 900;
    return Scaffold(
      appBar: isLargeScreen
          ? AppBar(title: const Text("My Profile"), centerTitle: true)
          : null,
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          ProfileCard(profile: mockProfile),
          const SizedBox(height: 32),
          TimeCard(checkIn: checkInTime, checkOut: checkOutTime),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: CheckInButton(
                  checkIn: checkInTime,
                  checkOut: checkOutTime,
                  onPressed: handleCheckInOut,
                ),
              ),
              const SizedBox(width: 12),
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
        ],
      ),
    );
  }
}
