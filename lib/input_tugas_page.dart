import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';

class InputTugasPage extends StatefulWidget {
  const InputTugasPage({super.key});

  @override
  State<InputTugasPage> createState() => _InputTugasPageState();
}

class _InputTugasPageState extends State<InputTugasPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _deadlineController = TextEditingController();

  DateTime? _selectedDate;

  List<Map<String, dynamic>> _kelasList = [];
  String? _selectedKelasId;
  bool _loadingKelas = true;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  Future<void> _loadKelas() async {
    final data = await AuthService.getKelasList();
    setState(() {
      _kelasList = data;
      _loadingKelas = false;
    });
  }

  /// ===== DATE PICKER =====
  Future<void> _pickDeadline() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _deadlineController.text = DateFormat(
          'dd-MM-yyyy',
        ).format(picked); // tampil ke user
      });
    }
  }

  Future<void> _submitTugas() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedDate == null) return;

    setState(() => _submitting = true);

    final success = await AuthService.addTugas(
      judul: _judulController.text,
      deskripsi: _deskripsiController.text,
      deadline: DateFormat('yyyy-MM-dd').format(_selectedDate!), // ke DB
      kelasId: _selectedKelasId!,
    );

    setState(() => _submitting = false);

    if (success) {
      _judulController.clear();
      _deskripsiController.clear();
      _deadlineController.clear();
      _selectedDate = null;
      setState(() => _selectedKelasId = null);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Tugas berhasil disimpan')));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Gagal menyimpan tugas')));
    }
  }

  @override
  void dispose() {
    _judulController.dispose();
    _deskripsiController.dispose();
    _deadlineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Tugas'),
        backgroundColor: const Color.fromARGB(255, 247, 247, 247),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// ===== DROPDOWN KELAS =====
              _loadingKelas
                  ? const CircularProgressIndicator()
                  : DropdownButtonFormField<String>(
                    value: _selectedKelasId,
                    decoration: const InputDecoration(
                      labelText: 'Pilih Kelas',
                      prefixIcon: Icon(Icons.class_),
                      border: OutlineInputBorder(),
                    ),
                    items:
                        _kelasList.map((k) {
                          return DropdownMenuItem<String>(
                            value: k['id'].toString(),
                            child: Text(k['nama']),
                          );
                        }).toList(),
                    onChanged: (val) => setState(() => _selectedKelasId = val),
                    validator:
                        (val) => val == null ? 'Kelas wajib dipilih' : null,
                  ),
              const SizedBox(height: 16),

              /// ===== JUDUL =====
              TextFormField(
                controller: _judulController,
                decoration: const InputDecoration(
                  labelText: 'Judul Tugas',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Judul wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),

              /// ===== DESKRIPSI =====
              TextFormField(
                controller: _deskripsiController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Deskripsi Tugas',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Deskripsi wajib diisi'
                            : null,
              ),
              const SizedBox(height: 16),

              /// ===== DEADLINE (KALENDER) =====
              TextFormField(
                controller: _deadlineController,
                readOnly: true,
                onTap: _pickDeadline,
                decoration: const InputDecoration(
                  labelText: 'Deadline',
                  hintText: 'Pilih tanggal',
                  prefixIcon: Icon(Icons.calendar_today),
                  border: OutlineInputBorder(),
                ),
                validator:
                    (value) =>
                        value == null || value.isEmpty
                            ? 'Deadline wajib dipilih'
                            : null,
              ),
              const SizedBox(height: 24),

              /// ===== SUBMIT =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _submitting ? null : _submitTugas,
                  icon: const Icon(Icons.send),
                  label:
                      _submitting
                          ? const Text('Menyimpan...')
                          : const Text('Kirim Tugas'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
