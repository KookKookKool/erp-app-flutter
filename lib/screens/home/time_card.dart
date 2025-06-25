import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeCard extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  const TimeCard({super.key, this.checkIn, this.checkOut});

  String format(DateTime? time) {
    if (time == null) return "ยังไม่ได้ลงเวลางาน";
    return DateFormat('HH:mm:ss น.').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      // --- ปรับสี Card ให้เข้าธีม ---
      elevation: 5, // เพิ่มมิติเล็กน้อย
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Colors.white, // ใช้สีขาวเป็นพื้นฐาน
      // สามารถเพิ่ม gradient อ่อนๆ ได้ ถ้าต้องการ
      // decoration: BoxDecoration(
      //   borderRadius: BorderRadius.circular(20),
      //   gradient: LinearGradient(
      //     begin: Alignment.topLeft,
      //     end: Alignment.bottomRight,
      //     colors: [
      //       Color(0xFFFFF3E0), // Very light peach/cream
      //       Colors.white,
      //     ],
      //   ),
      // ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text(
                  "เวลาเข้างาน",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513), // Saddle Brown
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  format(checkIn),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8B4513), // Saddle Brown
                  ),
                ),
              ],
            ),
            Column(
              children: [
                const Text(
                  "เวลาออกงาน",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B4513), // Saddle Brown
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  format(checkOut),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF8B4513), // Saddle Brown
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}