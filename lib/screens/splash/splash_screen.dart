import 'package:flutter/material.dart';
import 'dart:async';
import '../org_code/org_code_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // โหลดข้อมูล 2 วินาที แล้วไปหน้าต่อไป
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const OrgCodeScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ใส่โลโก้ของแอปที่นี่
              Image.asset(
                'assets/logo.png', // ต้องมีไฟล์ assets/logo.png
                width: 120,
                height: 120,
              ),
              const Text(
                'SUN ERP',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF8B4513), // Saddle Brown
                ),
              ),
              const SizedBox(height: 24),
              const CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color(0xFFFF8C00),
                ), // Vibrant Orange
              ),
              const SizedBox(height: 16),
              const Text(
                'Loading...',
                style: TextStyle(fontSize: 16, color: Color(0xFF8B4513)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
