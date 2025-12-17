import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class JadwalPage extends StatefulWidget {
  const JadwalPage({super.key});

  @override
  State<JadwalPage> createState() => _JadwalPageState();
}

class _JadwalPageState extends State<JadwalPage> {
  late Future<List<Map<String, dynamic>>> _jadwalFuture;

  @override
  void initState() {
    super.initState();

    final role = AuthService.currentUser?['role'];

    if (role == 'guru') {
      _jadwalFuture = AuthService.getJadwalGuru();
    } else {
      _jadwalFuture = AuthService.getJadwalSiswa();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Jadwal Pelajaran')),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _jadwalFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final jadwalList = snapshot.data ?? [];

          if (jadwalList.isEmpty) {
            return const Center(child: Text('Tidak ada jadwal'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: jadwalList.length,
            itemBuilder: (context, index) {
              final jadwal = jadwalList[index];
              return Card(
                elevation: 4,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: const Icon(Icons.schedule),
                  title: Text(
                    jadwal['mapel'] ?? '-',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hari: ${jadwal['hari']}'),
                      Text('Jam: ${jadwal['jam']}'),
                      Text('Ruangan: ${jadwal['ruangan']}'),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
