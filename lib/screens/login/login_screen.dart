import 'package:flutter/material.dart';
import 'package:erp_app/MainResponsiveShell.dart'; // ตรวจสอบ Path ให้ถูกต้อง

// ทำการ mock ข้อมูลบัญชีผู้ใช้สำหรับทดสอบ
// ในการพัฒนาแอปพลิเคชันจริง ควรเชื่อมต่อกับ backend หรือฐานข้อมูลจริง
const mockAccounts = [
  {
    "id": "EMP001",
    "email": "faijai@gmail.com",
    "phone": "0812345678",
    "password": "123456", // password ทดสอบ
    "name": "ศิริพร ใจดี",
    "nickname": "ฝ้าย",
    "level": "Senior",
    "position": "HR Manager",
  },
  // เพิ่ม user test อื่นๆ ได้
];

class LoginScreen extends StatefulWidget {
  final String orgCode;
  final String orgName; // ชื่อองค์กรที่ดึงมาจาก backend

  const LoginScreen({super.key, required this.orgCode, required this.orgName});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _showPassword = false;

  @override
  void dispose() {
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() {
    if (_formKey.currentState!.validate()) {
      final input = _idController.text.trim();
      final password = _passwordController.text;
      final user = mockAccounts.firstWhere(
        (u) =>
            (u["id"] == input || u["email"] == input || u["phone"] == input) &&
            u["password"] == password,
        orElse: () => <String, String>{},
      );
      if (user.isNotEmpty) {
        // ไปหน้า Dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const MainResponsiveShell()),
        );
      } else {
        // --- SnackBar สำหรับแจ้งเตือน Error (ปรับสีให้เข้าธีม) ---
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'ID หรือรหัสผ่านไม่ถูกต้อง',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: const Color(
              0xFFFF4500,
            ), // Deep Red-Orange สำหรับ Error
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _onForgotPassword() {
    // --- AlertDialog (ปรับสีและสไตล์ให้เข้าธีม) ---
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white, // พื้นหลังสีขาว
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: const Text(
          'ลืมรหัสผ่าน',
          style: TextStyle(
            color: Color(0xFF8B4513), // Saddle Brown
            fontWeight: FontWeight.bold,
          ),
        ),
        content: const Text(
          'โปรดติดต่อฝ่าย HR ขององค์กรคุณ\nเพื่อขอความช่วยเหลือ',
          style: TextStyle(
            color: Color(0xFF8B4513), // Saddle Brown
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            // --- TextButton (ปรับสีให้เข้าธีม) ---
            child: const Text(
              'ตกลง',
              style: TextStyle(
                color: Color(0xFFFF8C00), // Vibrant Orange
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // --- AppBar (ใช้ Gradient และสีตัวอักษรเดียวกับ OrgCodeScreen) ---
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
        title: Text(
          widget.orgName,
          style: const TextStyle(
            color: Colors.white,
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
        elevation: 0,
        automaticallyImplyLeading: false, // ปิดปุ่มย้อนกลับตามเดิม
      ),
      body: Container(
        // --- Background Gradient (ใช้ LinearGradient แบบอ่อนโยน) ---
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
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Center(
              // ใช้ Center เพื่อจัดให้ Column อยู่กึ่งกลางหน้าจอ
              child: ConstrainedBox(
                // ใช้ ConstrainedBox เพื่อจำกัดความกว้างบนหน้าจอขนาดใหญ่
                constraints: const BoxConstraints(
                  maxWidth: 400,
                ), // กำหนดความกว้างสูงสุดของฟอร์ม
                child: ListView(
                  shrinkWrap: true, // ทำให้ ListView ใช้พื้นที่เท่าที่จำเป็น
                  children: [
                    // --- เพิ่ม Logo ของ App (ถ้ามี) ---
                    // Image.asset(
                    //   'assets/logo.png', // ต้องมีไฟล์ assets/logo.png
                    //   width: 100,
                    //   height: 100,
                    // ),
                    // const SizedBox(height: 24),
                    Text(
                      'ยินดีต้อนรับสู่ ${widget.orgName}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B4513), // Saddle Brown
                      ),
                    ),
                    const SizedBox(height: 32),
                    // --- TextFormField (ปรับสไตล์ตามที่เคยแนะนำ) ---
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _idController,
                        decoration: InputDecoration(
                          labelText: 'รหัสพนักงาน / อีเมล / เบอร์โทร',
                          labelStyle: TextStyle(color: Color(0xFF8B4513)),
                          hintStyle: TextStyle(color: Color(0xFF8B4513)),
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF8B4513).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF8C00),
                              width: 2,
                            ), // Focus with Vibrant Orange
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: Icon(
                            Icons.person,
                            color: Color(0xFF8B4513),
                          ), // เพิ่มไอคอน
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'กรุณากรอก ID, อีเมล หรือเบอร์โทร';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF8B4513).withOpacity(0.1),
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'รหัสผ่าน',
                          labelStyle: TextStyle(color: Color(0xFF8B4513)),
                          hintStyle: TextStyle(color: Color(0xFF8B4513)),
                          filled: true,
                          fillColor: Colors.transparent,
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Color(0xFF8B4513).withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              color: Color(0xFFFF8C00),
                              width: 2,
                            ), // Focus with Vibrant Orange
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Color(0xFF8B4513),
                          ), // เพิ่มไอคอน
                          suffixIcon: IconButton(
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xFF8B4513), // สีไอคอน
                            ),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            },
                          ),
                        ),
                        obscureText: !_showPassword,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'กรุณากรอกรหัสผ่าน';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: const Color(0xFF8B4513),
                          checkColor: Colors.white,
                          side: WidgetStateBorderSide.resolveWith((states) {
                            if (states.contains(WidgetState.selected)) {
                              return const BorderSide(
                                color: Color(0xFF8B4513),
                                width: 2,
                              );
                            }
                            return const BorderSide(
                              color: Color(0xFFE08D46),
                              width: 2,
                            ); //
                          }),
                        ),
                        const Text(
                          'จดจำฉัน',
                          style: TextStyle(
                            color: Color(0xFFFF8C00), // Saddle Brown
                          ),
                        ),
                        const Spacer(),
                        // --- TextButton (ลืมรหัสผ่าน? - ปรับสี) ---
                        TextButton(
                          onPressed: _onForgotPassword,
                          child: const Text(
                            'ลืมรหัสผ่าน?',
                            style: TextStyle(
                              color: Color(0xFFFF8C00), // Vibrant Orange
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    // --- ElevatedButton (ปุ่มเข้าสู่ระบบ - ใช้สไตล์ Primary Sun Button) ---
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _onLoginPressed,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 5,
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
                              'เข้าสู่ระบบ',
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
      ),
    );
  }
}
