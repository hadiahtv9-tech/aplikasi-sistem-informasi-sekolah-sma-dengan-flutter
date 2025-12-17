import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ManajemenGuruPage extends StatefulWidget {
  const ManajemenGuruPage({super.key});

  @override
  State<ManajemenGuruPage> createState() => _ManajemenGuruPageState();
}

class _ManajemenGuruPageState extends State<ManajemenGuruPage> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Map<String, dynamic>> guruList = [];
  List<Map<String, dynamic>> kelasList = [];

  String? _selectedWaliKelasId;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    guruList = await AuthService.getGuruList();
    kelasList = await AuthService.getKelasList();
    setState(() => _loading = false);
  }

  // ================= TAMBAH GURU =================
  Future<void> _addGuru() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedWaliKelasId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Semua field wajib diisi')));
      return;
    }

    setState(() => _loading = true);

    final ok = await AuthService.createUser(
      nama: _namaController.text,
      email: _emailController.text,
      password: _passwordController.text,
      role: 'guru',
      waliKelasId: _selectedWaliKelasId!,
    );

    setState(() => _loading = false);

    if (ok) {
      Navigator.pop(context);
      _loadData();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Guru berhasil ditambahkan')),
      );
    }
  }

  // ================= EDIT GURU =================
  void _editGuru(Map<String, dynamic> guru) {
    _namaController.text = guru['nama'] ?? '';
    _emailController.text = guru['email'] ?? '';
    _passwordController.clear();
    _selectedWaliKelasId = guru['wali_kelas_id']?.toString();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Guru'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password (kosongkan jika tidak diubah)',
                    ),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedWaliKelasId,
                    decoration: const InputDecoration(labelText: 'Wali Kelas'),
                    items:
                        kelasList
                            .map(
                              (k) => DropdownMenuItem<String>(
                                value: k['id'].toString(),
                                child: Text(k['nama']),
                              ),
                            )
                            .toList(),
                    onChanged: (v) {
                      setState(() => _selectedWaliKelasId = v);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final data = {
                    'nama': _namaController.text,
                    'email': _emailController.text,
                    'wali_kelas_id': _selectedWaliKelasId!,
                  };

                  if (_passwordController.text.isNotEmpty) {
                    data['password'] = _passwordController.text;
                  }

                  final ok = await AuthService.updateUserProfile(
                    id: guru['id'].toString(), // ✅ FINAL, TANPA UID
                    data: data,
                  );

                  if (ok) {
                    Navigator.pop(context);
                    _loadData();
                  }
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // ================= HAPUS GURU =================
  Future<void> _deleteGuru(String id) async {
    final ok = await AuthService.deleteGuru(id);
    if (ok) {
      _loadData();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Guru berhasil dihapus')));
    }
  }

  String _kelasName(String kelasId) {
    final k = kelasList.firstWhere(
      (e) => e['id'].toString() == kelasId,
      orElse: () => {'nama': '-'},
    );
    return k['nama'];
  }

  // ================= DIALOG TAMBAH =================
  void _showTambahGuruDialog() {
    _namaController.clear();
    _emailController.clear();
    _passwordController.clear();
    _selectedWaliKelasId = null;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Tambah Guru'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: _namaController,
                    decoration: const InputDecoration(labelText: 'Nama'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(labelText: 'Email'),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                  ),
                  const SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedWaliKelasId,
                    decoration: const InputDecoration(labelText: 'Wali Kelas'),
                    items:
                        kelasList
                            .map(
                              (k) => DropdownMenuItem<String>(
                                value: k['id'].toString(),
                                child: Text(k['nama']),
                              ),
                            )
                            .toList(),
                    onChanged: (v) {
                      setState(() => _selectedWaliKelasId = v);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await _addGuru();
                },
                child: const Text('Simpan'),
              ),
            ],
          ),
    );
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manajemen Guru'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showTambahGuruDialog,
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: guruList.length,
                itemBuilder: (_, i) {
                  final g = guruList[i];
                  return Card(
                    child: ListTile(
                      title: Text(g['nama']),
                      subtitle: Text(
                        'Email: ${g['email']}\n'
                        'Wali Kelas: ${_kelasName(g['wali_kelas_id'].toString())}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editGuru(g),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteGuru(g['id'].toString()),
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
    _namaController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
