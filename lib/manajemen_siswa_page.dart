import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class ManajemenSiswaPage extends StatefulWidget {
  const ManajemenSiswaPage({super.key});

  @override
  State<ManajemenSiswaPage> createState() => _ManajemenSiswaPageState();
}

class _ManajemenSiswaPageState extends State<ManajemenSiswaPage> {
  final _namaController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  List<Map<String, dynamic>> siswaList = [];
  List<Map<String, dynamic>> kelasList = [];

  String? _selectedKelasId;
  bool _loading = false;

  // ================= LOAD DATA =================
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    siswaList = await AuthService.getSiswaList();
    kelasList = await AuthService.getKelasList();
    setState(() => _loading = false);
  }

  // ================= TAMBAH SISWA =================
  Future<void> _addSiswa() async {
    if (_namaController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _selectedKelasId == null) {
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
      role: 'siswa',
      kelasId: _selectedKelasId!,
    );

    setState(() => _loading = false);

    if (ok) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Siswa berhasil ditambahkan')),
      );
      _loadData();
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menambahkan siswa')));
    }
  }

  // ================= EDIT SISWA =================
  void _editSiswa(Map<String, dynamic> siswa) {
    _namaController.text = siswa['nama'] ?? '';
    _emailController.text = siswa['email'] ?? '';
    _passwordController.clear();
    _selectedKelasId = siswa['kelas_id']?.toString();

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Edit Siswa'),
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
                    value: _selectedKelasId,
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
                    onChanged: (v) => setState(() => _selectedKelasId = v),
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
                    'kelas_id': _selectedKelasId!,
                  };

                  if (_passwordController.text.isNotEmpty) {
                    data['password'] = _passwordController.text;
                  }

                  final ok = await AuthService.updateUserProfile(
                    id: siswa['id'].toString(), // ✅ FIXED
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

  // ================= HAPUS SISWA =================
  Future<void> _deleteSiswa(String id) async {
    final ok = await AuthService.deleteSiswa(id);
    if (ok) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Siswa berhasil dihapus')));
      _loadData();
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
  void _showTambahSiswaDialog() {
    _namaController.clear();
    _emailController.clear();
    _passwordController.clear();
    _selectedKelasId = null;

    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('Tambah Siswa'),
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
                    value: _selectedKelasId,
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
                    onChanged: (v) => setState(() => _selectedKelasId = v),
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
                  Navigator.pop(context);
                  await _addSiswa();
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
        title: const Text('Manajemen Siswa'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showTambahSiswaDialog,
          ),
        ],
      ),
      body:
          _loading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: siswaList.length,
                itemBuilder: (_, i) {
                  final s = siswaList[i];
                  return Card(
                    child: ListTile(
                      title: Text(s['nama']),
                      subtitle: Text(
                        'Email: ${s['email']}\n'
                        'Kelas: ${_kelasName(s['kelas_id'].toString())}',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => _editSiswa(s),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed:
                                () =>
                                    _deleteSiswa(s['id'].toString()), // ✅ FIXED
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
