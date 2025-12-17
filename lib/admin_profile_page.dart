import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AdminProfilePage extends StatelessWidget {
  const AdminProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text('Profil Admin')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 30),

            const CircleAvatar(
              radius: 55,
              child: Icon(Icons.admin_panel_settings, size: 55),
            ),

            const SizedBox(height: 16),

            Text(
              user?['nama'] ?? 'Administrator',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            Text(user?['email'] ?? '-'),

            const SizedBox(height: 10),

            Chip(
              label: Text(
                user?['role']?.toUpperCase() ?? 'ADMIN',
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blueGrey,
            ),

            const Spacer(),

            ElevatedButton.icon(
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 14,
                ),
              ),
              onPressed: () {
                AuthService.logout();
                Navigator.pushReplacementNamed(context, '/login');
              },
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
