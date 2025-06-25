import 'package:flutter/material.dart';
import 'package:erp_app/screens/login/login_screen.dart'; // ตรวจสอบ Path ให้ถูกต้อง

class OrgCodeScreen extends StatefulWidget {
  const OrgCodeScreen({super.key});

  @override
  State<OrgCodeScreen> createState() => _OrgCodeScreenState();
}

class _OrgCodeScreenState extends State<OrgCodeScreen> {
  final TextEditingController _codeController = TextEditingController();

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    final code = _codeController.text.trim();
    if (code.isNotEmpty) {
      // mock org name สำหรับทดสอบ (จริงควรเช็คจาก backend)
      final orgName = "บริษัท สมมติ จำกัด";

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(orgCode: code, orgName: orgName),
        ),
      );
    } else {
      // ใช้ SnackBar ที่ปรับสีให้เข้ากับธีม
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'กรุณากรอก Org Code',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(
            0xFFFF8C00,
          ), // Vibrant Orange for error feedback
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (ใช้สี Gradient ที่สดใส) ---
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
          'กรอกรหัสองค์กร',
          style: TextStyle(
            color: Colors.white, // ข้อความเป็นสีขาวตัดกับ Gradient
            fontWeight: FontWeight.bold,
            fontSize: 20,
            shadows: [
              Shadow(
                offset: Offset(1.0, 1.0),
                blurRadius: 3.0,
                color: Color.fromARGB(100, 0, 0, 0),
              ),
            ],
          ),
        ),
        centerTitle: true,
        elevation: 0, // ไม่มีเงาใต้ AppBar
      ),
      body: Container(
        // --- Background Gradient (ใช้ LinearGradient แบบอ่อนโยนเหมือน SplashScreen) ---
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

  child: Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 400),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- Text "กรุณากรอกรหัสองค์กร" (ใช้สีน้ำตาลเข้ม) ---
            const Text(
              'กรุณากรอกรหัสองค์กร',
              style: TextStyle(
                fontSize: 20,
                color: Color(0xFF8B4513), // Saddle Brown เพื่อความเข้ากัน
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24),
            // --- TextField (ปรับตามที่แนะนำไว้สำหรับ Input Fields) ---
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.1),
                    blurRadius: 5,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Organization Code',
                  labelStyle: TextStyle(color: Color(0xFF8B4513)),
                  hintStyle: TextStyle(color: Color(0xFF8B4513)),
                  filled: true,
                  fillColor:
                      Colors.transparent, // Color handled by parent Container
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(
                      color: Colors.grey.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(
                      color: Color(0xFFFF8C00),
                      width: 2,
                    ), // โฟกัสด้วยสีส้มสดใส
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // --- ElevatedButton (ใช้ปุ่ม Primary Sun Button ที่สร้างไว้) ---
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNextPressed,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero, // Remove default padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 5, // Add a bit of shadow
                ),
                child: Ink(
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
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    constraints: const BoxConstraints(
                      minWidth: 120,
                      minHeight: 50,
                    ),
                    child: const Text(
                      'ถัดไป',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
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
