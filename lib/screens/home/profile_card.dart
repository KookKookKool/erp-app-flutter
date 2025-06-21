import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(profile["profilePic"]),
            ),
            const SizedBox(height: 16),
            Text(
              profile["name"] ?? "",
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              "(${profile["nickname"] ?? ""})",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text("รหัสพนักงาน: ${profile["empId"] ?? ""}"),
            Text("${profile["level"] ?? ""} - ${profile["position"] ?? ""}"),
            const SizedBox(height: 8),
            Text("Email: ${profile["email"] ?? ""}"),
            Text("เบอร์ติดต่อ: ${profile["phone"] ?? ""}"),
            // ... ต่อด้วยส่วนอื่น ๆ ที่คุณต้องการเพิ่ม
          ],
        ),
      ),
    );
  }
}
