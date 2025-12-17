import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ManajemenJadwalPage extends StatefulWidget {
  const ManajemenJadwalPage({super.key});

  @override
  State<ManajemenJadwalPage> createState() => _ManajemenJadwalPageState();
}

class _ManajemenJadwalPageState extends State<ManajemenJadwalPage> {
  final _mapelController = TextEditingController();
  final _jamController = TextEditingController();
  final _ruanganController = TextEditingController();

  String? _hari;
  String? _kelasId;
  String? _guruId;

  bool _loading = false;

  List<Map<String, dynamic>> jadwalList = [];
  List<Map<String, dynamic>> kelasList = [];
  List<Map<String, dynamic>> guruList = [];

  final List<String> hariList = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    jadwalList = await AuthService.getJadwalList();
    kelasList = await AuthService.getKelasList();
    guruList = await AuthService.getGuruList();
    setState(() => _loading = false);
  }

  // ================= TAMBAH =================
  Future<void> _addJadwal() async {
    if (_hari == null || _kelasId == null || _guruId == null) return;

    final ok = await AuthService.addJadwal({
      'hari': _hari!,
      'mapel': _mapelController.text,
      'kelas_id': _kelasId!,
      'guru_id': _guruId!,
      'jam': _jamController.text,
      'ruangan': _ruanganController.text,
    });

    if (ok) {
      Navigator.pop(context);
      _loadData();
    }
  }

  // ================= EDIT =================
  void _editJadwal(Map<String, dynamic> j) {
    _hari = j['hari'];
    _kelasId = j['kelas_id'].toString();
    _guruId = j['guru_id'].toString();
    _mapelController.text = j['mapel'] ?? '';
    _jamController.text = j['jam'] ?? '';
    _ruanganController.text = j['ruangan'] ?? '';

    _showFormDialog(
      title: 'Edit Jadwal',
      onSave: () async {
        final ok = await AuthService.updateJadwal(j['id'].toString(), {
          'hari': _hari!,
          'mapel': _mapelController.text,
          'kelas_id': _kelasId!,
          'guru_id': _guruId!,
          'jam': _jamController.text,
          'ruangan': _ruanganController.text,
        });

        if (ok) {
          Navigator.pop(context);
          _loadData();
        }
      },
    );
  }

  // ================= HAPUS =================
  Future<void> _deleteJadwal(String id) async {
    final ok = await AuthService.deleteJadwal(id);
    if (ok) _loadData();
  }

  // ================= FORM =================
  void _showFormDialog({required String title, required VoidCallback onSave}) {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  DropdownButtonFormField<String>(
                    value: hariList.contains(_hari) ? _hari : null,
                    decoration: const InputDecoration(labelText: 'Hari'),
                    items:
                        hariList
                            .map(
                              (h) => DropdownMenuItem(value: h, child: Text(h)),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _hari = v),
                  ),
                  DropdownButtonFormField<String>(
                    value:
                        kelasList.any((k) => k['id'].toString() == _kelasId)
                            ? _kelasId
                            : null,
                    decoration: const InputDecoration(labelText: 'Kelas'),
                    items:
                        kelasList
                            .map(
                              (k) => DropdownMenuItem(
                                value: k['id'].toString(),
                                child: Text(k['nama']),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _kelasId = v),
                  ),
                  DropdownButtonFormField<String>(
                    value:
                        guruList.any((g) => g['id'].toString() == _guruId)
                            ? _guruId
                            : null,
                    decoration: const InputDecoration(labelText: 'Guru'),
                    items:
                        guruList
                            .map(
                              (g) => DropdownMenuItem(
                                value: g['id'].toString(),
                                child: Text(g['nama']),
                              ),
                            )
                            .toList(),
                    onChanged: (v) => setState(() => _guruId = v),
                  ),
                  TextField(
                    controller: _mapelController,
                    decoration: const InputDecoration(labelText: 'Mapel'),
                  ),
                  TextField(
                    controller: _jamController,
                    decoration: const InputDecoration(labelText: 'Jam'),
                  ),
                  TextField(
                    controller: _ruanganController,
                    decoration: const InputDecoration(labelText: 'Ruangan'),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(onPressed: onSave, child: const Text('Simpan')),
            ],
          ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Jadwal'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _hari = null;
              _kelasId = null;
              _guruId = null;
              _mapelController.clear();
              _jamController.clear();
              _ruanganController.clear();
              _showFormDialog(title: 'Tambah Jadwal', onSave: _addJadwal);
            },
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: jadwalList.length,
                itemBuilder: (_, i) {
                  final j = jadwalList[i];
                  return Card(
                    child: ListTile(
                      title: Text('${j['hari']} - ${j['mapel']}'),
                      subtitle: Text(
                        'Jam: ${j['jam']}\nRuangan: ${j['ruangan']}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editJadwal(j),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteJadwal(j['id'].toString()),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
    );
  }

  @override
  void dispose() {
    _mapelController.dispose();
    _jamController.dispose();
    _ruanganController.dispose();
    super.dispose();
  }
}
