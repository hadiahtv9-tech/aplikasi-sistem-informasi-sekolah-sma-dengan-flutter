import 'package:flutter/material.dart';
import '../../services/auth_service.dart';

class NotifPage extends StatefulWidget {
  const NotifPage({super.key});

  @override
  State<NotifPage> createState() => _NotifPageState();
}

class _NotifPageState extends State<NotifPage> {
  late Future<List<Map<String, dynamic>>> _future;

  @override
  void initState() {
    super.initState();
    _future = AuthService.getNotif();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final list = snapshot.data!;
          if (list.isEmpty) {
            return const Center(child: Text('Tidak ada notifikasi'));
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (context, i) {
              final n = list[i];
              final isRead = n['dibaca'] == 1;

              return ListTile(
                leading: Icon(
                  isRead ? Icons.mark_email_read : Icons.mark_email_unread,
                  color: isRead ? Colors.grey : Colors.green,
                ),
                title: Text(
                  n['judul'],
                  style: TextStyle(
                    fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                  ),
                ),
                subtitle: Text(n['pesan']),
                trailing: Text(
                  n['created_at'].toString().substring(0, 10),
                  style: const TextStyle(fontSize: 12),
                ),
                onTap: () async {
                  if (!isRead) {
                    await AuthService.readNotif(n['id'].toString());
                    setState(() {
                      _future = AuthService.getNotif();
                    });
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
