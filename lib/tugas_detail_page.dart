import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class TugasDetailPage extends StatelessWidget {
  final int tugasId;

  const TugasDetailPage({super.key, required this.tugasId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Tugas')),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: AuthService.getTugasDetail(tugasId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Terjadi error: ${snapshot.error}'));
          }

          final tugas = snapshot.data;

          if (tugas == null) {
            return const Center(child: Text('Data tugas tidak ditemukan'));
          }

          final deadline = DateTime.tryParse(tugas['deadline'] ?? '');

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // JUDUL
                    Text(
                      tugas['judul'] ?? '-',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 12),

                    // GURU
                    if (tugas['nama_guru'] != null)
                      Row(
                        children: [
                          const Icon(Icons.person, size: 18),
                          const SizedBox(width: 6),
                          Text('Guru: ${tugas['nama_guru']}'),
                        ],
                      ),

                    const SizedBox(height: 12),

                    // DEADLINE
                    Row(
                      children: [
                        const Icon(Icons.calendar_month, color: Colors.red),
                        const SizedBox(width: 6),
                        Text(
                          'Deadline: ${_formatDate(deadline)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),

                    const Divider(height: 32),

                    // DESKRIPSI
                    const Text(
                      'Deskripsi Tugas',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      tugas['deskripsi'] ?? '-',
                      style: const TextStyle(fontSize: 14),
                    ),

                    const SizedBox(height: 24),

                    // STATUS DEADLINE
                    _buildDeadlineStatus(deadline),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  // ==================== FORMAT TANGGAL ====================
  static String _formatDate(DateTime? date) {
    if (date == null) return '-';
    return '${date.day}/${date.month}/${date.year} '
        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  // ==================== STATUS DEADLINE ====================
  Widget _buildDeadlineStatus(DateTime? deadline) {
    if (deadline == null) return const SizedBox();

    final now = DateTime.now();
    final isLate = now.isAfter(deadline);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isLate ? Colors.red.shade50 : Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            isLate ? Icons.warning : Icons.check_circle,
            color: isLate ? Colors.red : Colors.green,
          ),
          const SizedBox(width: 8),
          Text(
            isLate ? 'Deadline telah lewat' : 'Masih dalam batas waktu',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isLate ? Colors.red : Colors.green,
            ),
          ),
        ],
      ),
    );
  }
}
