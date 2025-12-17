import 'package:flutter/material.dart';
import 'notif_page.dart';
import 'profile_page.dart';

class HomeGuru extends StatefulWidget {
  const HomeGuru({super.key});

  @override
  State<HomeGuru> createState() => _HomeGuruState();
}

class _HomeGuruState extends State<HomeGuru> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> homeMenuItems = const [
    {'icon': Icons.edit_note, 'label': 'Input Nilai', 'route': '/input_nilai'},
    {
      'icon': Icons.upload_file,
      'label': 'Input Tugas',
      'route': '/input_tugas',
    },
    {'icon': Icons.book, 'label': 'Lihat Jadwal', 'route': '/jadwal'},
  ];

  Widget _buildHomeMenu() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: homeMenuItems.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          final item = homeMenuItems[index];
          return GestureDetector(
            onTap: () => Navigator.pushNamed(context, item['route']),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 6,
              color: Colors.white,
              shadowColor: Colors.green.shade100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item['icon'], size: 48, color: Colors.green),
                  const SizedBox(height: 12),
                  Text(
                    item['label'],
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      _buildHomeMenu(),
      const NotifPage(),
      const ProfilePage(role: 'guru'),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Guru - MAN Cipasung"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.green,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.green,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: "Notif",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
