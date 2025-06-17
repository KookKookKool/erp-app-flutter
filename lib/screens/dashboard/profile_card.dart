import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final Map<String, dynamic> profile;
  const ProfileCard({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(profile['profilePic']),
                radius: 52,
              ),
              const SizedBox(height: 16),
              Text(
                '${profile['empId']}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${profile['name']} (${profile['nickname']})',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${profile['level']}  |  ${profile['position']}',
                style: const TextStyle(fontSize: 16, color: Colors.blueGrey),
              ),
              const SizedBox(height: 12),
              Text('อีเมล: ${profile['email']}'),
              Text('เบอร์ติดต่อ: ${profile['phone']}'),
            ],
          ),
        ),
      ),
    );
  }
}
