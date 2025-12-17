// main.dart
import 'package:flutter/material.dart';
import 'login_page.dart';
import 'home_siswa.dart';
import 'home_guru.dart';
import 'home_admin.dart';
import 'notif_page.dart';
import 'profile_page.dart';
import 'jadwal_page.dart';
import 'nilai_page.dart';
import 'tugas_page.dart';
import 'input_nilai_page.dart';
import 'input_tugas_page.dart';
import 'manajemen_kelas_page.dart';
import 'manajemen_siswa_page.dart';
import 'manajemen_guru_page.dart';
import 'manajemen_jadwal_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MAN Cipasung',
      theme: ThemeData(primarySwatch: Colors.green),
      initialRoute: '/',
      routes: {
        '/login': (context) => const LoginPage(),
        '/home_siswa': (context) => const HomeSiswa(),
        '/home_guru': (context) => const HomeGuru(),
        '/home_admin': (context) => const HomeAdmin(),
        '/notif': (context) => const NotifPage(),
        '/profile_siswa': (context) => const ProfilePage(role: 'siswa'),
        '/profile_guru': (context) => const ProfilePage(role: 'guru'),
        '/profile_admin': (context) => const ProfilePage(role: 'admin'),
        '/jadwal': (context) => const JadwalPage(),
        '/nilai': (context) => const NilaiPage(),
        '/tugas': (context) => const TugasPage(),
        '/input_nilai': (context) => const InputNilaiPage(),
        '/input_tugas': (context) => const InputTugasPage(),
        '/manajemen_kelas': (context) => const ManajemenKelasPage(),
        '/manajemen_siswa': (context) => const ManajemenSiswaPage(),
        '/manajemen_guru': (context) => const ManajemenGuruPage(),
        '/manajemen_jadwal': (context) => const ManajemenJadwalPage(),
      },
    );
  }
}
