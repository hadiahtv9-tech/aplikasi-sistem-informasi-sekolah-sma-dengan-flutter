import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'admin_notif_page.dart';
import 'admin_profile_page.dart';

class HomeAdmin extends StatefulWidget {
  const HomeAdmin({super.key});

  @override
  State<HomeAdmin> createState() => _HomeAdminState();
}

class _HomeAdminState extends State<HomeAdmin> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    _AdminDashboard(),
    AdminNotifPage(),
    AdminProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (i) => setState(() => _currentIndex = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notif',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/* ===========================================================
   DASHBOARD ADMIN
   =========================================================== */
class _AdminDashboard extends StatelessWidget {
  const _AdminDashboard();

  Future<int> _getCount(String role) async {
    // WAJIB ADA DI AuthService
    // Endpoint PHP: count_users.php?role=siswa / guru
    return await AuthService.getUserCountByRole(role);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          /// HEADER ADMIN
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3498DB), Color(0xFF2C3E50)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '👋 Selamat Datang, Administrator',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  'Kelola data sekolah dengan aman & terpusat',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          /// STATISTIK SISWA & GURU
          FutureBuilder(
            future: Future.wait([_getCount('siswa'), _getCount('guru')]),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final siswa = snapshot.data![0];
              final guru = snapshot.data![1];

              return Column(
                children: [
                  _statCard('Total Siswa', siswa.toString(), Colors.blue),
                  const SizedBox(height: 12),
                  _statCard('Total Guru', guru.toString(), Colors.green),
                ],
              );
            },
          ),

          const SizedBox(height: 24),

          const Text(
            'Manajemen Sekolah',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 16),

          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: [
              _menuCard(
                context,
                Icons.class_,
                'Manajemen Kelas',
                '/manajemen_kelas',
              ),
              _menuCard(
                context,
                Icons.person,
                'Manajemen Siswa',
                '/manajemen_siswa',
              ),
              _menuCard(
                context,
                Icons.school,
                'Manajemen Guru',
                '/manajemen_guru',
              ),
              _menuCard(
                context,
                Icons.calendar_today,
                'Manajemen Jadwal',
                '/manajemen_jadwal',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Icon(Icons.bar_chart, color: color),
        title: Text(title),
        trailing: Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ),
    );
  }

  Widget _menuCard(
    BuildContext context,
    IconData icon,
    String title,
    String route,
  ) {
    return InkWell(
      onTap: () => Navigator.pushNamed(context, route),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 40, color: Colors.blueAccent),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
