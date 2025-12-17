import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class NilaiPage extends StatefulWidget {
  const NilaiPage({super.key});

  @override
  State<NilaiPage> createState() => _NilaiPageState();
}

class _NilaiPageState extends State<NilaiPage>
    with SingleTickerProviderStateMixin {
  late String siswaId;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    siswaId = AuthService.currentUser?['id']?.toString() ?? '';
    _tabController = TabController(length: 2, vsync: this);
  }

  Color warnaNilai(int? nilai) {
    if (nilai == null) return Colors.grey;
    if (nilai >= 85) return Colors.green;
    if (nilai >= 75) return Colors.orange;
    return Colors.red;
  }

  Widget buildList(List<Map<String, dynamic>> list, String jenis) {
    if (list.isEmpty) {
      return const Center(child: Text('Belum ada nilai'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final item = list[index];
        final nilai =
            jenis == 'uts' ? item['uts'] as int? : item['uas'] as int?;

        if (nilai == null) return const SizedBox.shrink();

        return Card(
          elevation: 4,
          margin: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: warnaNilai(nilai),
              child: Text(
                nilai.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(
              item['mapel_id'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('Semester: ${item['semester'] ?? '-'}'),
            trailing: Icon(
              jenis == 'uts' ? Icons.assignment : Icons.school,
              color: Colors.blue,
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nilai Siswa'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [Tab(text: 'UTS'), Tab(text: 'UAS')],
        ),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: AuthService.getNilaiList(siswaId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final list = snapshot.data ?? [];

          return TabBarView(
            controller: _tabController,
            children: [buildList(list, 'uts'), buildList(list, 'uas')],
          );
        },
      ),
    );
  }
}
