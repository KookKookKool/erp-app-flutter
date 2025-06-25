import 'package:flutter/material.dart';

class CheckInButton extends StatelessWidget {
  final DateTime? checkIn;
  final DateTime? checkOut;
  final VoidCallback onPressed;

  const CheckInButton({
    super.key,
    required this.checkIn,
    required this.checkOut,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    String label = "บันทึกเวลาเข้างาน";
    if (checkIn != null && checkOut == null) {
      label = "บันทึกเวลาออกงาน";
    } else if (checkIn != null && checkOut != null) {
      label = "รีเซ็ต (demo)"; // สำหรับรีเซ็ต ให้ใช้สีต่างออกไปเพื่อให้แยกแยะได้ง่าย
    }

    // --- กำหนด Gradient สำหรับปุ่ม ---
    LinearGradient buttonGradient;
    Color? overrideBackgroundColor; // สำหรับปุ่มรีเซ็ต

    if (label == "รีเซ็ต (demo)") {
      // สีสำหรับปุ่มรีเซ็ต (อาจใช้สี Sky Blue หรือสีเทา)
      buttonGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF2196F3),
          Color(0xFF03A9F4),
        ],
      );
    } else {
      // สีสำหรับปุ่ม Check-in/Check-out (Primary Sun Gradient)
      buttonGradient = const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFFFFD700), // Warm Yellow
          Color(0xFFFF8C00), // Vibrant Orange
          Color(0xFFFF4500), // Deep Red-Orange
        ],
        stops: [0.0, 0.6, 1.0],
      );
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.zero, // ลบ padding เริ่มต้น
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 5, // เพิ่มเงา
        ),
        child: Ink( // ใช้ Ink เพื่อใช้ BoxDecoration กับ Gradient
          decoration: BoxDecoration(
            gradient: buttonGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 15), // เพิ่ม padding ให้ปุ่มมีขนาดเหมาะสม
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18, // เพิ่มขนาดฟอนต์
                color: Colors.white,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    offset: Offset(1.0, 1.0),
                    blurRadius: 3.0,
                    color: Color.fromARGB(100, 0, 0, 0),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}