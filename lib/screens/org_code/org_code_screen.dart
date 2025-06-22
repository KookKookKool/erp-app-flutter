import 'package:flutter/material.dart';
import 'package:erp_app/screens/login/login_screen.dart';

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
          builder: (_) => LoginScreen(
            orgCode: code,
            orgName: orgName,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('กรุณากรอก Org Code')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('กรอกรหัสองค์กร'),centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('กรุณากรอกรหัสองค์กร', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 24),
            TextField(
              controller: _codeController,
              decoration: const InputDecoration(
                labelText: 'Organization Code',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNextPressed,
                child: const Text('ถัดไป'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
