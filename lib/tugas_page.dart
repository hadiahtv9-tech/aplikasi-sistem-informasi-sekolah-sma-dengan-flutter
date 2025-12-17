import 'package:flutter/material.dart';
import 'services/auth_service.dart';
import 'tugas_detail_page.dart';

class TugasPage extends StatefulWidget {
  const TugasPage({super.key});

  @override
  State<TugasPage> createState() => _TugasPageState();
}

class _TugasPageState extends State<TugasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Tugas'), centerTitle: true),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AuthService.getTugasList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final tugasList = snapshot.data ?? [];

          if (tugasList.isEmpty) {
            return const Center(
              child: Text('Tidak ada tugas', style: TextStyle(fontSize: 16)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tugasList.length,
            itemBuilder: (context, index) {
              final tugas = tugasList[index];

              return InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  debugPrint('TUGAS DIKLIK: ${tugas['id']}');

                  final tugasId = int.tryParse(tugas['id'].toString());
                  if (tugasId == null) return;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TugasDetailPage(tugasId: tugasId),
                    ),
                  );
                },
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.assignment,
                          color: Colors.blueAccent,
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tugas['judul'] ?? 'Tidak ada judul',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(tugas['deskripsi'] ?? 'Tidak ada deskripsi'),
                              const SizedBox(height: 8),
                              Text(
                                'Deadline: ${_formatDate(tugas['deadline'])}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  String _formatDate(dynamic deadline) {
    if (deadline == null) return '-';

    try {
      final date = DateTime.parse(deadline.toString());
      return '${date.day}/${date.month}/${date.year}';
    } catch (_) {
      return deadline.toString();
    }
  }
}
