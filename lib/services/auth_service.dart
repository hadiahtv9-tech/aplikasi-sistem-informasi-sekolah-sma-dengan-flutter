import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  // ================================
  // HITUNG USER BERDASARKAN ROLE
  // ================================
  static Future<int> getUserCountByRole(String role) async {
    try {
      final url = Uri.parse('$baseUrl/count_users.php?role=$role');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['count'] ?? 0;
      }
    } catch (e) {
      print('[AuthService] Error getUserCountByRole: $e');
    }
    return 0;
  }

  // Currently logged in user (from custom backend). Set by `login`.
  static Map<String, dynamic>? currentUser;
  // Configure for your network IP (192.168.1.4)
  static const String baseUrl = 'http://192.168.1.4/flutter_api';

  // Register user
  static Future<bool> register({
    required String email,
    required String password,
    required String username,
    required String name,
    required String role,
  }) async {
    final url = Uri.parse('$baseUrl/register.php');
    final resp = await http.post(
      url,
      body: {
        'email': email,
        'password': password,
        'username': username,
        'name': name,
        'role': role,
      },
    );

    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      return data['success'] == 1;
    }
    return false;
  }

  // Login user -> returns a result map with keys: success (0/1), user (map) or error (string)
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/login.php');
    print('[AuthService] 🔍 Login attempt - Email: $email');
    print('[AuthService] 📤 Sending to: $url');

    try {
      final body = {'email': email, 'password': password};
      print('[AuthService] 📨 Request body: $body');
      final resp = await http.post(url, body: body);

      print('[AuthService] 📥 Response status: ${resp.statusCode}');
      print('[AuthService] 📋 Response body: ${resp.body}');

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        print(
          '[AuthService] ✅ Parsed JSON: success=${data['success']}, has_user=${data['user'] != null}',
        );

        if (data['success'] == 1 && data['user'] != null) {
          currentUser = Map<String, dynamic>.from(data['user']);
          print(
            '[AuthService] 🎉 Login SUCCESS! User: ${currentUser?['email']} (${currentUser?['role']})',
          );
          return {'success': 1, 'user': currentUser};
        } else {
          final err = data['error'] ?? 'Unknown error';
          print('[AuthService] ❌ Login FAILED: $err');
          return {'success': 0, 'error': err};
        }
      } else {
        print('[AuthService] ❌ HTTP Error: ${resp.statusCode}');
        return {'success': 0, 'error': 'HTTP ${resp.statusCode}'};
      }
    } catch (e) {
      print('[AuthService] ⚠️ Exception during login: $e');
      return {'success': 0, 'error': e.toString()};
    }
  }

  // Logout (client-side action; optional server invalidation endpoint)
  static Future<void> logout() async {
    // If you implement server-side tokens, call logout endpoint here.
    currentUser = null;
    return;
  }

  // Get user role
  static Future<String?> getUserRole(String id) async {
    final url = Uri.parse(
      '$baseUrl/get_user.php?id=${Uri.encodeComponent(id)}',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['success'] == 1 && data['user'] != null) {
        return data['user']['role'];
      }
    }
    return null;
  }

  // Update user profile
  static Future<bool> updateUserProfile({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final url = Uri.parse('$baseUrl/update_user.php');
    final body = {'id': id};
    data.forEach((k, v) => body[k] = v.toString());
    final resp = await http.post(url, body: body);
    if (resp.statusCode == 200) {
      final d = jsonDecode(resp.body);
      return d['success'] == 1;
    }
    return false;
  }

  // Get user data
  static Future<Map<String, dynamic>?> getUserData(String id) async {
    final url = Uri.parse(
      '$baseUrl/get_user.php?id=${Uri.encodeComponent(id)}',
    );
    final resp = await http.get(url);
    if (resp.statusCode == 200) {
      final data = jsonDecode(resp.body);
      if (data['success'] == 1 && data['user'] != null) {
        return Map<String, dynamic>.from(data['user']);
      }
    }
    return null;
  }

  // ==================== CREATE USER ====================
  static Future<bool> createUser({
    required String nama,
    required String email,
    required String password,
    required String role,
    String? kelasId,
    String? waliKelasId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/create_user.php');
      final body = {
        'nama': nama,
        'email': email,
        'password': password,
        'role': role,
      };

      if (kelasId != null) body['kelasId'] = kelasId;
      if (waliKelasId != null) body['wali_kelas_id'] = waliKelasId;

      final resp = await http.post(url, body: body);

      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] Error createUser: $e');
      return false;
    }
  }

  // Delete user (by admin)
  static Future<bool> deleteUserAccount(String id) async {
    final url = Uri.parse('$baseUrl/delete_user.php');
    final resp = await http.post(url, body: {'id': id});
    if (resp.statusCode == 200) {
      final d = jsonDecode(resp.body);
      return d['success'] == 1;
    }
    return false;
  }

  // ==================== SISWA ====================
  static Future<List<Map<String, dynamic>>> getSiswaList() async {
    try {
      final url = Uri.parse('$baseUrl/users_list.php?role=siswa');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] Error getSiswaList: $e');
      return [];
    }
  }

  static Future<bool> updateSiswa(String id, Map<String, dynamic> data) async {
    final url = Uri.parse('$baseUrl/update_user.php');
    final body = {'id': id};
    data.forEach((k, v) => body[k] = v.toString());

    final resp = await http.post(url, body: body);
    if (resp.statusCode == 200) {
      final d = jsonDecode(resp.body);
      return d['success'] == 1;
    }
    return false;
  }

  static Future<bool> deleteSiswa(String id) async {
    final url = Uri.parse('$baseUrl/delete_user.php');
    final resp = await http.post(url, body: {'id': id});

    if (resp.statusCode == 200) {
      final d = jsonDecode(resp.body);
      return d['success'] == 1;
    }
    return false;
  }

  // ==================== GURU ====================
  static Future<List<Map<String, dynamic>>> getGuruList() async {
    try {
      final url = Uri.parse('$baseUrl/get_guru_list.php');
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['guru'] != null) {
          return List<Map<String, dynamic>>.from(data['guru']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] ⚠️ Error getting guru list: $e');
      return [];
    }
  }

  static Future<bool> updateGuru(
    String gurid,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/update_guru.php');
      final body = {'id': gurid};
      data.forEach((k, v) => body[k] = v.toString());
      final resp = await http.post(url, body: body);
      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] ⚠️ Error updating guru: $e');
      return false;
    }
  }

  static Future<bool> deleteGuru(String gurid) async {
    try {
      final url = Uri.parse('$baseUrl/delete_user.php');
      final resp = await http.post(url, body: {'id': gurid});
      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] ⚠️ Error deleting guru: $e');
      return false;
    }
  }

  // ==================== KELAS ====================

  static Future<List<Map<String, dynamic>>> getKelasList() async {
    try {
      final url = Uri.parse('$baseUrl/kelas_list.php');
      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] ⚠️ Error getting kelas list: $e');
      return [];
    }
  }

  static Future<bool> addKelas(String nama) async {
    try {
      final url = Uri.parse('$baseUrl/kelas_add.php');
      final resp = await http.post(url, body: {'nama': nama});

      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] ⚠️ Error adding kelas: $e');
      return false;
    }
  }

  static Future<bool> updateKelas(String kelasId, String nama) async {
    try {
      final url = Uri.parse('$baseUrl/kelas_update.php');
      final resp = await http.post(url, body: {'id': kelasId, 'nama': nama});

      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] ⚠️ Error updating kelas: $e');
      return false;
    }
  }

  static Future<bool> deleteKelas(String kelasId) async {
    try {
      final url = Uri.parse('$baseUrl/kelas_delete.php');
      final resp = await http.post(url, body: {'id': kelasId});

      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] ⚠️ Error deleting kelas: $e');
      return false;
    }
  }

  // ==================== JADWAL ====================
  static Future<List<Map<String, dynamic>>> getJadwalList() async {
    try {
      final url = Uri.parse('$baseUrl/get_jadwal_list.php');
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['jadwal'] != null) {
          return List<Map<String, dynamic>>.from(data['jadwal']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] getJadwalList error: $e');
      return [];
    }
  }

  static Future<bool> addJadwal(Map<String, dynamic> data) async {
    try {
      final url = Uri.parse('$baseUrl/add_jadwal.php');
      final body = <String, String>{};
      data.forEach((k, v) => body[k] = v.toString());

      final resp = await http.post(url, body: body);
      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] addJadwal error: $e');
      return false;
    }
  }

  static Future<bool> updateJadwal(
    String jadwalId,
    Map<String, dynamic> data,
  ) async {
    try {
      final url = Uri.parse('$baseUrl/update_jadwal.php');
      final body = {'id': jadwalId};
      data.forEach((k, v) => body[k] = v.toString());

      final resp = await http.post(url, body: body);
      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] updateJadwal error: $e');
      return false;
    }
  }

  static Future<bool> deleteJadwal(String jadwalId) async {
    try {
      final url = Uri.parse('$baseUrl/delete_jadwal.php');
      final resp = await http.post(url, body: {'id': jadwalId});

      if (resp.statusCode == 200) {
        final d = jsonDecode(resp.body);
        return d['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] deleteJadwal error: $e');
      return false;
    }
  }

  // ==================== JADWAL GURU ====================
  static Future<List<Map<String, dynamic>>> getJadwalGuru() async {
    try {
      // pastikan user sudah login
      if (currentUser == null) {
        print('[AuthService] getJadwalGuru: currentUser null');
        return [];
      }

      // ambil id guru dari user login
      final guruId = currentUser!['id'].toString();

      final url = Uri.parse('$baseUrl/get_jadwal_by_guru.php?guru_id=$guruId');

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);

        if (data['success'] == 1 && data['jadwal'] != null) {
          return List<Map<String, dynamic>>.from(data['jadwal']);
        }
      }

      return [];
    } catch (e) {
      print('[AuthService] getJadwalGuru error: $e');
      return [];
    }
  }

  // ==================== JADWAL SISWA ====================
  static Future<List<Map<String, dynamic>>> getJadwalSiswa() async {
    try {
      if (currentUser == null) {
        print('[AuthService] getJadwalSiswa: currentUser null');
        return [];
      }

      final kelasId = currentUser!['kelas_id'];

      if (kelasId == null) {
        print('[AuthService] getJadwalSiswa: kelas_id null');
        return [];
      }

      final url = Uri.parse(
        '$baseUrl/get_jadwal_by_kelas.php?kelas_id=$kelasId',
      );

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['jadwal'] != null) {
          return List<Map<String, dynamic>>.from(data['jadwal']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] getJadwalSiswa error: $e');
      return [];
    }
  }

  // ==================== NILAI ====================
  static Future<List<Map<String, dynamic>>> getNilaiList(String siswaId) async {
    try {
      final url = Uri.parse(
        '$baseUrl/get_nilai_list.php?siswa_id=${Uri.encodeComponent(siswaId)}',
      );
      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['nilai'] != null) {
          return List<Map<String, dynamic>>.from(data['nilai']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] ⚠️ Error getting nilai list: $e');
      return [];
    }
  }

  // ==================== INPUT NILAI ====================

  // ambil mapel dari tabel jadwal (kelas + guru)
  static Future<List<String>> getMapelByKelasGuru({
    required String kelasId,
    required String guruId,
  }) async {
    try {
      final url = Uri.parse(
        '$baseUrl/get_mapel_by_kelas_guru.php?kelas_id=$kelasId&guru_id=$guruId',
      );

      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['mapel'] != null) {
          return List<String>.from(data['mapel'].map((e) => e['mapel']));
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] getMapelByKelasGuru error: $e');
      return [];
    }
  }

  // ambil siswa berdasarkan kelas
  static Future<List<Map<String, dynamic>>> getSiswaByKelas(
    String kelasId,
  ) async {
    try {
      final url = Uri.parse(
        '$baseUrl/get_siswa_by_kelas.php?kelas_id=$kelasId',
      );

      final resp = await http.get(url);
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['siswa'] != null) {
          return List<Map<String, dynamic>>.from(data['siswa']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] getSiswaByKelas error: $e');
      return [];
    }
  }

  // submit nilai
  static Future<void> submitNilaiUTSUAS({
    required String siswaId,
    required String mapelId,
    String? uts,
    String? uas,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/nilai_add.php'),
      body: {
        'siswa_id': siswaId,
        'mapel_id': mapelId,
        if (uts != null) 'uts': uts,
        if (uas != null) 'uas': uas,
      },
    );

    final data = json.decode(res.body);
    if (data['success'] != 1) {
      throw data['error'];
    }
  }

  // ==================== TUGAS ====================
  static Future<List<Map<String, dynamic>>> getTugasList() async {
    try {
      if (currentUser == null) return [];

      final kelasId = currentUser!['kelas_id'];
      if (kelasId == null) return [];

      final url = Uri.parse(
        '$baseUrl/get_tugas_by_kelas.php?kelas_id=$kelasId',
      );

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['tugas'] != null) {
          return List<Map<String, dynamic>>.from(data['tugas']);
        }
      }
      return [];
    } catch (e) {
      print('[AuthService] getTugasList error: $e');
      return [];
    }
  }

  static Future<bool> addTugas({
    required String judul,
    required String deskripsi,
    required String deadline,
    required String kelasId,
  }) async {
    try {
      if (currentUser == null) return false;

      final url = Uri.parse('$baseUrl/tugas_add.php');

      final resp = await http.post(
        url,
        body: {
          'guru_id': currentUser!['id'].toString(),
          'kelas_id': kelasId,
          'judul': judul,
          'deskripsi': deskripsi,
          'deadline': deadline,
        },
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        return data['success'] == 1;
      }
      return false;
    } catch (e) {
      print('[AuthService] addTugas error: $e');
      return false;
    }
  }

  // ==================== TUGAS DETAIL ====================
  static Future<Map<String, dynamic>?> getTugasDetail(int tugasId) async {
    try {
      final url = Uri.parse('$baseUrl/get_tugas_detail.php?id=$tugasId');

      final resp = await http.get(url);

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        if (data['success'] == 1 && data['tugas'] != null) {
          return Map<String, dynamic>.from(data['tugas']);
        }
      }
      return null;
    } catch (e) {
      print('[AuthService] getTugasDetail error: $e');
      return null;
    }
  }

  // ==================== Notifikasi ====================
  static Future<bool> sendNotif({
    required String judul,
    required String pesan,
    required String role,
  }) async {
    try {
      final resp = await http.post(
        Uri.parse('$baseUrl/notif_send.php'),
        body: {'judul': judul, 'pesan': pesan, 'role': role},
      );

      final data = jsonDecode(resp.body);
      return resp.statusCode == 200 && data['success'] == 1;
    } catch (e) {
      print('[AuthService] sendNotif error: $e');
      return false;
    }
  }

  static Future<List<Map<String, dynamic>>> getNotif() async {
    final userId = currentUser!['id'].toString();

    final res = await http.get(
      Uri.parse('$baseUrl/get_notif.php?user_id=$userId'),
    );

    return List<Map<String, dynamic>>.from(json.decode(res.body));
  }

  static Future<void> readNotif(String id) async {
    await http.post(Uri.parse('$baseUrl/read_notif.php'), body: {'id': id});
  }
}
