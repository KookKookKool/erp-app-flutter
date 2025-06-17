import 'package:flutter/material.dart';
import 'package:erp_app/screens/login/login_screen.dart'; // ต้องมีไฟล์นี้ในโฟลเดอร์เดียวกัน

class OrgCodeScreen extends StatefulWidget {
  const OrgCodeScreen({super.key});

  @override
  State<OrgCodeScreen> createState() => _OrgCodeScreenState();
}

class _OrgCodeScreenState extends State<OrgCodeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orgCodeController = TextEditingController();

  @override
  void dispose() {
    _orgCodeController.dispose();
    super.dispose();
  }

Future<String> fetchOrgName(String orgCode) async {
  // จำลองดึงชื่อองค์กรจากฐานข้อมูล (mock)
  await Future.delayed(const Duration(seconds: 1)); // จำลองโหลดข้อมูล
  // จะให้ return ค่าอะไรก็ได้ (สมมติรหัส orgCode เป็น "abc123" = "บจก.ไทยเทค")
  if (orgCode == "abc123") {
    return "บจก.ไทยเทค";
  }
  // ค่า default
  return "องค์กรตัวอย่าง";
}

void _onNextPressed() async {
  if (_formKey.currentState!.validate()) {
    final orgCode = _orgCodeController.text.trim();
    // TODO: ดึง orgName จาก backend ด้วย orgCode
    final orgName = await fetchOrgName(orgCode); // ตัวอย่าง function
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => LoginScreen(orgCode: orgCode, orgName: orgName),
      ),
    );
  }
}

  void _onRegisterPressed() {
    // ตอนนี้ยังไม่ต้องทำอะไร (future: เชื่อม LINE หรืออื่นๆ)
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('ฟีเจอร์นี้กำลังพัฒนา')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('เข้าสู่องค์กร'),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'กรอกรหัสองค์กรของคุณ',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _orgCodeController,
                decoration: const InputDecoration(
                  labelText: 'รหัสองค์กร',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'กรุณากรอกรหัสองค์กร';
                  }
                  // เพิ่ม validation อื่นได้
                  return null;
                },
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onNextPressed,
                  child: const Text('ถัดไป'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _onRegisterPressed,
                child: const Text('สมัครสมาชิก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
