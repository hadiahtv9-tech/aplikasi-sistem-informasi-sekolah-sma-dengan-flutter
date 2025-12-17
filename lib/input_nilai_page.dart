import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class InputNilaiPage extends StatefulWidget {
  const InputNilaiPage({super.key});

  @override
  State<InputNilaiPage> createState() => _InputNilaiPageState();
}

class _InputNilaiPageState extends State<InputNilaiPage> {
  String? selectedKelasId;
  String? selectedMapel;

  List<Map<String, dynamic>> kelasList = [];
  List<String> mapelList = [];
  List<Map<String, dynamic>> siswaList = [];

  final Map<String, TextEditingController> utsControllers = {};
  final Map<String, TextEditingController> uasControllers = {};

  bool isLoading = true;
  bool isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadKelas();
  }

  // ================= LOAD DATA =================

  Future<void> _loadKelas() async {
    kelasList = await AuthService.getKelasList();
    setState(() => isLoading = false);
  }

  Future<void> _loadMapel(String kelasId) async {
    final user = AuthService.currentUser;
    if (user == null) return;

    final guruId = user['id'].toString();

    mapelList = await AuthService.getMapelByKelasGuru(
      kelasId: kelasId,
      guruId: guruId,
    );

    setState(() {
      selectedMapel = null;
    });
  }

  Future<void> _loadSiswa(String kelasId) async {
    siswaList = await AuthService.getSiswaByKelas(kelasId);

    utsControllers.clear();
    uasControllers.clear();

    for (var s in siswaList) {
      final id = s['id'].toString();
      utsControllers[id] = TextEditingController();
      uasControllers[id] = TextEditingController();
    }

    setState(() {});
  }

  // ================= SUBMIT =================

  Future<void> _submitNilai() async {
    if (selectedKelasId == null) {
      _msg('Pilih kelas terlebih dahulu');
      return;
    }

    if (selectedMapel == null) {
      _msg('Pilih mata pelajaran');
      return;
    }

    if (siswaList.isEmpty) {
      _msg('Tidak ada siswa');
      return;
    }

    setState(() => isSubmitting = true);

    try {
      for (var s in siswaList) {
        final id = s['id'].toString();

        final utsCtrl = utsControllers[id];
        final uasCtrl = uasControllers[id];

        if (utsCtrl == null || uasCtrl == null) continue;

        final utsText = utsCtrl.text.trim();
        final uasText = uasCtrl.text.trim();

        if (utsText.isEmpty && uasText.isEmpty) continue;

        final uts = utsText.isEmpty ? null : int.tryParse(utsText);
        final uas = uasText.isEmpty ? null : int.tryParse(uasText);

        if ((uts != null && (uts < 0 || uts > 100)) ||
            (uas != null && (uas < 0 || uas > 100))) {
          _msg('Nilai ${s['nama']} harus 0–100');
          setState(() => isSubmitting = false);
          return;
        }

        await AuthService.submitNilaiUTSUAS(
          siswaId: id,
          mapelId: selectedMapel!,
          uts: uts?.toString(),
          uas: uas?.toString(),
        );
      }

      _msg('Nilai berhasil disimpan');
    } catch (e) {
      _msg('Gagal menyimpan nilai');
    } finally {
      setState(() => isSubmitting = false);
    }
  }

  // ================= UI =================

  void _msg(String m) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Input Nilai')),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(12),
                child: ListView(
                  children: [
                    /// KELAS
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Kelas'),
                      value: selectedKelasId,
                      items:
                          kelasList
                              .map(
                                (k) => DropdownMenuItem(
                                  value: k['id'].toString(),
                                  child: Text(k['nama']),
                                ),
                              )
                              .toList(),
                      onChanged: (v) {
                        if (v == null) return;
                        setState(() {
                          selectedKelasId = v;
                          selectedMapel = null;
                          siswaList.clear();
                        });
                        _loadMapel(v);
                        _loadSiswa(v);
                      },
                    ),

                    const SizedBox(height: 12),

                    /// MAPEL
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: 'Mata Pelajaran',
                      ),
                      value: selectedMapel,
                      items:
                          mapelList
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                      onChanged: (v) {
                        setState(() => selectedMapel = v);
                      },
                    ),

                    const SizedBox(height: 20),

                    /// HEADER
                    Row(
                      children: const [
                        Expanded(flex: 3, child: Text('Nama')),
                        Expanded(child: Text('UTS')),
                        Expanded(child: Text('UAS')),
                      ],
                    ),
                    const Divider(),

                    /// DATA SISWA
                    ...siswaList.map((s) {
                      final id = s['id'].toString();
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            Expanded(flex: 3, child: Text(s['nama'])),
                            Expanded(
                              child: TextField(
                                controller: utsControllers[id],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '0-100',
                                ),
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: uasControllers[id],
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: '0-100',
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),

                    const SizedBox(height: 24),

                    /// SUBMIT
                    ElevatedButton(
                      onPressed: isSubmitting ? null : _submitNilai,
                      child:
                          isSubmitting
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text('Simpan Nilai'),
                    ),
                  ],
                ),
              ),
    );
  }
}
