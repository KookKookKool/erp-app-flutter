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
          ? AppBar(
              flexibleSpace: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700), // Warm Yellow
                      Color(0xFFFF8C00), // Vibrant Orange
                      Color(0xFFFF4500), // Deep Red-Orange
                    ],
                    stops: [0.0, 0.7, 1.0],
                  ),
                ),
              ),
              title: const Text(
                "My Profile",
                style: TextStyle(color: Colors.white),
              ),
              centerTitle: true,
              elevation: 0, // ต้องเป็น 0 เพื่อลบเงาของ AppBar
            )
          : null,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF3E0), // Very light peach/cream
              Color(0xFFFFECB3), // Light Peach
              Color(0xFFFBE4C4), // Slightly darker peach/cream
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: Column(
          children: [
            if (!isLargeScreen)
              Container(
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFFD700), // Warm Yellow
                      Color(0xFFFF8C00), // Vibrant Orange
                      Color(0xFFFF4500), // Deep Red-Orange
                    ],
                    stops: [0.0, 0.7, 1.0],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4.0,
                      offset: Offset(0.0, 2.0),
                    ),
                  ],
                ),
              ),
            Expanded(
              child: ListView(
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
                        child: GestureDetector(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => LeaveRequestScreen(
                                  empId: mockProfile['empId'] ?? '',
                                  empName: mockProfile['name'] ?? '',
                                ),
                              ),
                            );
                            if (result != null &&
                                result is Map<String, dynamic>) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Text(
                                    "ส่งคำขอลาสำเร็จ",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  backgroundColor: const Color(
                                    0xFF2196F3,
                                  ), // Sky Blue (for success snackbar)
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            }
                          },
                          // --- Custom button with Gradient Border (Primary Sun Gradient) ---
                          child: Container(
                            height: 56, // ทำให้ความสูงเข้ากับ CheckInButton
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                // Gradient สำหรับขอบ (Primary Sun Gradient)
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFFFFD700), // Warm Yellow
                                  Color(0xFFFF8C00), // Vibrant Orange
                                  Color(0xFFFF4500), // Deep Red-Orange
                                ],
                                stops: [0.0, 0.6, 1.0],
                              ),
                              boxShadow: [
                                // เงาของปุ่มโดยรวม
                                BoxShadow(
                                  color: Color(
                                    0xFFFF8C00,
                                  ).withOpacity(0.3), // สีเงาจาก gradient
                                  blurRadius: 8.0,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Center(
                              // จัดให้เนื้อหาอยู่ตรงกลาง
                              child: Container(
                                // Container ชั้นในสำหรับพื้นหลังสีเดียว
                                decoration: BoxDecoration(
                                  color: const Color(
                                    0xFFFFF3E0,
                                  ), // สีพื้นหลังของปุ่ม (สีเดียวกับพื้นหลังจอ)
                                  borderRadius: BorderRadius.circular(
                                    14,
                                  ), // Radius เล็กกว่าชั้นนอก
                                ),
                                margin: const EdgeInsets.all(
                                  2,
                                ), // กำหนดความหนาของขอบ
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.event_note,
                                      color: Color(0xFFDD6600),
                                      size: 20,
                                    ), // สี Icon
                                    SizedBox(width: 8),
                                    Text(
                                      "ลางาน",
                                      style: TextStyle(
                                        color: Color(0xFFDD6600), // สี Text
                                        fontSize:
                                            18, // ขนาดฟอนต์เข้ากับ CheckInButton
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
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
    );
  }
}
