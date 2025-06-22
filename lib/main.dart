// lib/main.dart
import 'package:flutter/material.dart';
import 'package:erp_app/screens/splash/splash_screen.dart';
import 'package:erp_app/screens/org_code/org_code_screen.dart';
import 'package:erp_app/screens/home/myprofile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ERP App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: SplashScreen(),
      routes: {
        '/org': (context) => OrgCodeScreen(),
        '/profile': (context) =>  MyProfileScreen(),
      },
    );
  }
}
