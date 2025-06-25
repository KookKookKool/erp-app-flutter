import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      // --- ปรับสี Card และเงาให้เข้าธีม ---
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      elevation: 5, // เพิ่มมิติเล็กน้อย
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.white, // ใช้สีขาวเป็นพื้นฐาน
      // ถ้าต้องการให้ Card มี gradient อ่อนๆ เหมือน TimeCard ก็สามารถเพิ่มได้
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profile["profilePic"] ?? "https://i.pravatar.cc/300?img=5"), // เพิ่ม default pic กัน error
            ),
            const SizedBox(height: 16),
            Text(
              profile["name"] ?? "",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF8B4513), // Saddle Brown
              ),
            ),
            Text(
              "(${profile["nickname"] ?? ""})",
              style: const TextStyle(
                color: Colors.grey, // สีเทาสำหรับข้อความรอง
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "รหัสพนักงาน: ${profile["empId"] ?? ""}",
              style: const TextStyle(
                color: Color(0xFF8B4513), // Saddle Brown
              ),
            ),
            Text(
              "${profile["level"] ?? ""} - ${profile["position"] ?? ""}",
              style: const TextStyle(
                color: Color(0xFF8B4513), // Saddle Brown
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "Email: ${profile["email"] ?? ""}",
              style: const TextStyle(
                color: Color(0xFF8B4513), // Saddle Brown
              ),
            ),
            Text(
              "เบอร์ติดต่อ: ${profile["phone"] ?? ""}",
              style: const TextStyle(
                color: Color(0xFF8B4513), // Saddle Brown
              ),
            ),
            // ... ต่อด้วยส่วนอื่น ๆ ที่คุณต้องการเพิ่ม
          ],
        ),
      ),
    );
  }
}