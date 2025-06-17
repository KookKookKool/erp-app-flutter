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
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const Text("เวลาเข้างาน", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(format(checkIn)),
              ],
            ),
            Column(
              children: [
                const Text("เวลาออกงาน", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text(format(checkOut)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
