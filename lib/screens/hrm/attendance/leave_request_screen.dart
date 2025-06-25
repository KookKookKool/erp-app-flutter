import 'package:flutter/material.dart';

class LeaveRequestScreen extends StatefulWidget {
  final String empId;
  final String empName;
  const LeaveRequestScreen({
    super.key,
    required this.empId,
    required this.empName,
  });

  @override
  State<LeaveRequestScreen> createState() => _LeaveRequestScreenState();
}

class _LeaveRequestScreenState extends State<LeaveRequestScreen> {
  DateTime? startDate;
  DateTime? endDate;
  String leaveType = "ลากิจ";
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (startDate == null || endDate == null || _reasonController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        // --- ปรับสี SnackBar แจ้งเตือน ---
        SnackBar(
          content: const Text(
            "กรุณากรอกข้อมูลให้ครบถ้วน",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent, // สีแดงสำหรับแจ้งเตือนข้อผิดพลาด
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }
    Navigator.pop(context, {
      "date": startDate!.toIso8601String().substring(0, 10),
      "empId": widget.empId,
      "name": widget.empName,
      "status": "ลา",
      "leave": {
        "approveStatus": "pending",
        "deductSalary": false,
        "remark": _reasonController.text,
        "type": leaveType,
        "startDate": startDate,
        "endDate": endDate,
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- ปรับสี AppBar ---
      appBar: AppBar(
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
          "ฟอร์มลางาน",
          style: TextStyle(
            color: Colors.white, // ข้อความเป็นสีขาว
          ),
        ),
        centerTitle: true,
        elevation: 0, // ยกเลิกเงา AppBar
      ),
      body: Container( // เพิ่ม Container เพื่อใส่ Background Gradient
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              // --- ปรับสี Text สำหรับชื่อพนักงาน ---
              Text(
                "ชื่อ: ${widget.empName}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513), // Saddle Brown
                ),
              ),
              const SizedBox(height: 16),
              // --- ปรับสี DropdownButtonFormField ---
              DropdownButtonFormField<String>(
                value: leaveType,
                decoration: const InputDecoration(
                  labelText: "ประเภทการลา",
                  labelStyle: TextStyle(color: Color(0xFF8B4513)), // Saddle Brown
                  enabledBorder: OutlineInputBorder( // สีเส้นขอบปกติ
                    borderSide: BorderSide(color: Color(0xFF8B4513)),
                  ),
                  focusedBorder: OutlineInputBorder( // สีเส้นขอบเมื่อโฟกัส
                    borderSide: BorderSide(color: Color(0xFFFF8C00), width: 2.0), // Vibrant Orange
                  ),
                ),
                items: [
                  DropdownMenuItem(
                    value: "ลากิจ",
                    child: Text("ลากิจ", style: TextStyle(color: Color(0xFF8B4513))),
                  ),
                  DropdownMenuItem(
                    value: "ลาป่วย",
                    child: Text("ลาป่วย", style: TextStyle(color: Color(0xFF8B4513))),
                  ),
                  DropdownMenuItem(
                    value: "ลาพักร้อน",
                    child: Text("ลาพักร้อน", style: TextStyle(color: Color(0xFF8B4513))),
                  ),
                ],
                onChanged: (v) => setState(() => leaveType = v ?? "ลากิจ"),
                style: TextStyle(color: Color(0xFF8B4513)), // สีข้อความที่เลือก
              ),
              const SizedBox(height: 16),
              // --- ปรับสี ListTile สำหรับ Date Pickers ---
              ListTile(
                title: Text(
                  "วันที่เริ่ม: ${startDate != null ? "${startDate!.day}/${startDate!.month}/${startDate!.year + 543}" : "-"}",
                  style: const TextStyle(color: Color(0xFF8B4513)), // Saddle Brown
                ),
                trailing: const Icon(
                  Icons.date_range,
                  color: Color(0xFF8B4513), // Saddle Brown
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                    builder: (context, child) {
                      return Theme( // ปรับสีของ DatePicker
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFFFF8C00), // Vibrant Orange for primary elements
                            onPrimary: Colors.white, // Text on primary background
                            onSurface: Color(0xFF8B4513), // Saddle Brown for text on surface
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFF8C00), // Vibrant Orange for button text
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) setState(() => startDate = picked);
                },
              ),
              ListTile(
                title: Text(
                  "วันที่สิ้นสุด: ${endDate != null ? "${endDate!.day}/${endDate!.month}/${endDate!.year + 543}" : "-"}",
                  style: const TextStyle(color: Color(0xFF8B4513)), // Saddle Brown
                ),
                trailing: const Icon(
                  Icons.date_range,
                  color: Color(0xFF8B4513), // Saddle Brown
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: startDate ?? DateTime.now(),
                    firstDate: DateTime(DateTime.now().year - 1),
                    lastDate: DateTime(DateTime.now().year + 2),
                    builder: (context, child) {
                      return Theme( // ปรับสีของ DatePicker
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: Color(0xFFFF8C00), // Vibrant Orange for primary elements
                            onPrimary: Colors.white, // Text on primary background
                            onSurface: Color(0xFF8B4513), // Saddle Brown for text on surface
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              foregroundColor: const Color(0xFFFF8C00), // Vibrant Orange for button text
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (picked != null) setState(() => endDate = picked);
                },
              ),
              const SizedBox(height: 16),
              // --- ปรับสี TextFormField ---
              TextFormField(
                controller: _reasonController,
                decoration: const InputDecoration(
                  labelText: "เหตุผลในการลา",
                  labelStyle: TextStyle(color: Color(0xFF8B4513)), // Saddle Brown
                  border: OutlineInputBorder( // สีขอบปกติ
                    borderSide: BorderSide(color: Color(0xFF8B4513)),
                  ),
                  enabledBorder: OutlineInputBorder( // สีขอบเมื่อ enable
                    borderSide: BorderSide(color: Color(0xFF8B4513)),
                  ),
                  focusedBorder: OutlineInputBorder( // สีขอบเมื่อโฟกัส
                    borderSide: BorderSide(color: Color(0xFFFF8C00), width: 2.0), // Vibrant Orange
                  ),
                ),
                maxLines: 2,
                style: const TextStyle(color: Color(0xFF8B4513)), // สีข้อความที่พิมพ์
              ),
              const SizedBox(height: 32),
              // --- ปรับสี ElevatedButton ---
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // ลบ padding เริ่มต้น
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5, // เพิ่มเงา
                ),
                child: Ink( // ใช้ Ink เพื่อใช้ BoxDecoration กับ Gradient
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xFFFFD700), // Warm Yellow
                        Color(0xFFFF8C00), // Vibrant Orange
                        Color(0xFFFF4500), // Deep Red-Orange
                      ],
                      stops: [0.0, 0.6, 1.0],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 15), // เพิ่ม padding ให้ปุ่มมีขนาดเหมาะสม
                    child: const Text(
                      "ส่งคำขอลา",
                      style: TextStyle(
                        fontSize: 18, // เพิ่มขนาดฟอนต์
                        color: Colors.white, // ข้อความเป็นสีขาว
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
            ],
          ),
        ),
      ),
    );
  }
}