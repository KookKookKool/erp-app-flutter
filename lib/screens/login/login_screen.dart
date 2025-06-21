import 'package:flutter/material.dart';
import 'package:erp_app/screens/home/myprofile_screen.dart';

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
          MaterialPageRoute(builder: (_) => const DashboardScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID หรือรหัสผ่านไม่ถูกต้อง')),
        );
      }
    }
  }

  void _onForgotPassword() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('ลืมรหัสผ่าน'),
        content: const Text(
          'โปรดติดต่อฝ่าย HR ขององค์กรคุณ\nเพื่อขอความช่วยเหลือ',
        ),
        actions: [
          TextButton(
            child: const Text('ตกลง'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.orgName),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: ListView(
            shrinkWrap: true,
            children: [
              const SizedBox(height: 32),
              TextFormField(
                controller: _idController,
                decoration: const InputDecoration(
                  labelText: 'รหัสพนักงาน / อีเมล / เบอร์โทร',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอก ID, อีเมล หรือเบอร์โทร';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'รหัสผ่าน',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
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
                  ),
                  const Text('จดจำฉัน'),
                  const Spacer(),
                  TextButton(
                    onPressed: _onForgotPassword,
                    child: const Text('ลืมรหัสผ่าน?'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onLoginPressed,
                  child: const Text('เข้าสู่ระบบ'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
