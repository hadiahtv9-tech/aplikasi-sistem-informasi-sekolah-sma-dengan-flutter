import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ManajemenKelasPage extends StatefulWidget {
  const ManajemenKelasPage({super.key});

  @override
  State<ManajemenKelasPage> createState() => _ManajemenKelasPageState();
}

class _ManajemenKelasPageState extends State<ManajemenKelasPage> {
  final TextEditingController _namaController = TextEditingController();
  List<Map<String, dynamic>> kelasList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadKelasList();
  }

  Future<void> _loadKelasList() async {
    setState(() => _isLoading = true);
    kelasList = await AuthService.getKelasList();
    setState(() => _isLoading = false);
  }

  Future<void> _addKelas() async {
    if (_namaController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nama kelas tidak boleh kosong')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      bool success = await AuthService.addKelas(_namaController.text);
      if (!mounted) return;
      if (success) {
        _namaController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Kelas berhasil ditambahkan')),
        );
        await _loadKelasList();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menambahkan kelas')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error menambahkan kelas: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateKelas(String kelasId, String currentNama) async {
    _namaController.text = currentNama;
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Kelas'),
            content: TextField(
              controller: _namaController,
              decoration: const InputDecoration(labelText: 'Nama Kelas'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);
                  final messenger = ScaffoldMessenger.of(context);
                  bool success = await AuthService.updateKelas(
                    kelasId,
                    _namaController.text,
                  );
                  if (success) {
                    navigator.pop();
                    _namaController.clear();
                    messenger.showSnackBar(
                      const SnackBar(
                        content: Text('Kelas berhasil diperbarui'),
                      ),
                    );
                    if (mounted) _loadKelasList();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  Future<void> _deleteKelas(String kelasId) async {
    bool? confirm = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Hapus Kelas'),
            content: const Text('Apakah Anda yakin ingin menghapus kelas ini?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Hapus'),
              ),
            ],
          ),
    );

    if (confirm == true) {
      bool success = await AuthService.deleteKelas(kelasId);
      if (success) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Kelas berhasil dihapus')));
        _loadKelasList();
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal menghapus kelas')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manajemen Kelas')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        TextField(
                          controller: _namaController,
                          decoration: InputDecoration(
                            labelText: 'Nama Kelas (contoh: 10 IPA 1)',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _addKelas,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(45),
                          ),
                          child: const Text('Tambah Kelas'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child:
                        kelasList.isEmpty
                            ? const Center(
                              child: Text(
                                'Belum ada kelas. Tambahkan kelas baru.',
                              ),
                            )
                            : ListView.builder(
                              padding: const EdgeInsets.all(16),
                              itemCount: kelasList.length,
                              itemBuilder: (context, index) {
                                final kelas = kelasList[index];
                                return Card(
                                  elevation: 3,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(
                                      Icons.class_,
                                      color: Colors.blueAccent,
                                    ),
                                    title: Text(
                                      kelas['nama'] ?? 'Nama tidak tersedia',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          onPressed:
                                              () => _updateKelas(
                                                kelas['id'].toString(), // ✅ FIX
                                                kelas['nama'],
                                              ),
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.orange,
                                          ),
                                        ),

                                        IconButton(
                                          onPressed:
                                              () => _deleteKelas(
                                                kelas['id'].toString(), // ✅ FIX
                                              ),
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                  ),
                ],
              ),
    );
  }

  @override
  void dispose() {
    _namaController.dispose();
    super.dispose();
  }
}
