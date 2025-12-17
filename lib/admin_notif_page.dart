import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class AdminNotifPage extends StatefulWidget {
  const AdminNotifPage({super.key});

  @override
  State<AdminNotifPage> createState() => _AdminNotifPageState();
}

class _AdminNotifPageState extends State<AdminNotifPage> {
  final TextEditingController _judulCtrl = TextEditingController();
  final TextEditingController _pesanCtrl = TextEditingController();

  String _role = 'siswa';
  bool _loading = false;

  Future<void> _kirimNotif() async {
    if (_judulCtrl.text.isEmpty || _pesanCtrl.text.isEmpty) {
      _msg('Judul dan pesan wajib diisi');
      return;
    }

    setState(() => _loading = true);

    final success = await AuthService.sendNotif(
      judul: _judulCtrl.text,
      pesan: _pesanCtrl.text,
      role: _role,
    );

    setState(() => _loading = false);

    if (success) {
      _judulCtrl.clear();
      _pesanCtrl.clear();
      _msg('Notifikasi berhasil dikirim');
    } else {
      _msg('Gagal mengirim notifikasi');
    }
  }

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifikasi Admin')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            const Text(
              'Kirim Notifikasi',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            /// ROLE
            DropdownButtonFormField<String>(
              value: _role,
              decoration: const InputDecoration(labelText: 'Kirim ke'),
              items: const [
                DropdownMenuItem(value: 'siswa', child: Text('Siswa')),
                DropdownMenuItem(value: 'guru', child: Text('Guru')),
              ],
              onChanged: (v) => setState(() => _role = v!),
            ),

            const SizedBox(height: 16),

            /// JUDUL
            TextField(
              controller: _judulCtrl,
              decoration: const InputDecoration(labelText: 'Judul Notifikasi'),
            ),

            const SizedBox(height: 16),

            /// PESAN
            TextField(
              controller: _pesanCtrl,
              maxLines: 4,
              decoration: const InputDecoration(labelText: 'Isi Pesan'),
            ),

            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon:
                  _loading
                      ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : const Icon(Icons.send),
              label: const Text('Kirim Notifikasi'),
              onPressed: _loading ? null : _kirimNotif,
            ),
          ],
        ),
      ),
    );
  }
}
