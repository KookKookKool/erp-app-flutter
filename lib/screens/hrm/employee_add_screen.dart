import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EmployeeAddScreen extends StatefulWidget {
  const EmployeeAddScreen({super.key});
  @override
  State<EmployeeAddScreen> createState() => _EmployeeAddScreenState();
}

class _EmployeeAddScreenState extends State<EmployeeAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final Map<String, dynamic> emp = {
    "empId": "",
    "name": "",
    "nickname": "",
    "level": "",
    "position": "",
    "email": "",
    "phone": "",
    "profilePic": "", // default: ยังไม่มี
    "password": "",
  };

  late TextEditingController _imgController;
  late TextEditingController _passwordController;
  bool _showPassword = false;
  File? _pickedImageFile;

  @override
  void initState() {
    _imgController = TextEditingController();
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _imgController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? imgFile = await picker.pickImage(source: ImageSource.gallery);
    if (imgFile != null) {
      setState(() {
        _pickedImageFile = File(imgFile.path);
        emp['profilePic'] = imgFile.path;
        _imgController.text = imgFile.path;
      });
    }
  }

  void _updateImagePreview(String url) {
    setState(() {
      emp['profilePic'] = url;
      _pickedImageFile = null; // หากใช้ URL จะไม่โชว์ไฟล์
    });
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      emp['profilePic'] = _imgController.text.isNotEmpty
          ? _imgController.text
          : (_pickedImageFile != null ? _pickedImageFile!.path : "");
      emp['password'] = _passwordController.text;
      Navigator.pop(context, emp);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatarWidget;
    if (_pickedImageFile != null) {
      avatarWidget = CircleAvatar(
        backgroundImage: FileImage(_pickedImageFile!),
        radius: 40,
      );
    } else if (_imgController.text.isNotEmpty) {
      avatarWidget = CircleAvatar(
        backgroundImage: NetworkImage(_imgController.text),
        radius: 40,
      );
    } else {
      avatarWidget = const CircleAvatar(
        child: Icon(Icons.person, size: 40),
        radius: 40,
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("เพิ่มพนักงานใหม่")),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: Column(
                  children: [
                    GestureDetector(onTap: _pickImage, child: avatarWidget),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _imgController,
                      decoration: const InputDecoration(
                        labelText: "URL รูปโปรไฟล์ (หรือเลือกไฟล์ได้)",
                        suffixIcon: Icon(Icons.image),
                      ),
                      onChanged: (v) => _updateImagePreview(v),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "แตะที่รูปเพื่อเลือกรูปจากเครื่อง",
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(labelText: "รหัสพนักงาน"),
                onChanged: (v) => emp['empId'] = v,
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "ชื่อ-นามสกุล"),
                onChanged: (v) => emp['name'] = v,
                validator: (v) => v == null || v.isEmpty ? "จำเป็น" : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "ชื่อเล่น"),
                onChanged: (v) => emp['nickname'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Level"),
                onChanged: (v) => emp['level'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "ตำแหน่ง"),
                onChanged: (v) => emp['position'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "Email"),
                onChanged: (v) => emp['email'] = v,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: "เบอร์โทร"),
                onChanged: (v) => emp['phone'] = v,
              ),
              // ช่องรหัสผ่านพร้อมปุ่มลูกตา
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: "รหัสผ่าน",
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () =>
                        setState(() => _showPassword = !_showPassword),
                  ),
                ),
                obscureText: !_showPassword,
                onChanged: (v) => emp['password'] = v,
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _save,
                      child: const Text("บันทึก"),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("ยกเลิก"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
