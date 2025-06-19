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
      label = "รีเซ็ต (demo)";
    }
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        onPressed: onPressed,
        child: Text(label, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
