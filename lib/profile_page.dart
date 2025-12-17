import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class ProfilePage extends StatelessWidget {
  final String role;
  const ProfilePage({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 30),
          const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
          const SizedBox(height: 16),

          Text(
            user?['nama'] ?? '',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          Text(user?['email'] ?? ''),
          const SizedBox(height: 8),

          Chip(
            label: Text(role.toUpperCase()),
            backgroundColor: Colors.green.shade200,
          ),

          const Spacer(),

          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              AuthService.logout();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
