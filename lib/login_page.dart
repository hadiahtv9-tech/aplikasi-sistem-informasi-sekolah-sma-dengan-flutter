import 'package:flutter/material.dart';
import 'services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = '';
  bool isLoading = false;

  void _login() async {
    print('[LoginPage] 🚀 Login button pressed');

    setState(() {
      isLoading = true;
      error = '';
    });

    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    print(
      '[LoginPage] 📝 Input - Email: $email, Password length: ${password.length}',
    );

    if (email.isEmpty || password.isEmpty) {
      print('[LoginPage] ⚠️ Empty fields detected');
      setState(() {
        error = 'Email dan password tidak boleh kosong';
        isLoading = false;
      });
      return;
    }

    try {
      print('[LoginPage] ⏳ Calling AuthService.login()...');
      var loginResult = await AuthService.login(
        email: email,
        password: password,
      );

      print(
        '[LoginPage] 📨 Login result received: ${loginResult['success'] == 1}',
      );
      print('[LoginPage] 🔎 Full login result: $loginResult');

      if (!mounted) {
        print('[LoginPage] ⚠️ Widget unmounted, returning');
        return;
      }

      if (loginResult['success'] == 1 && loginResult['user'] != null) {
        final user = Map<String, dynamic>.from(loginResult['user']);
        String role = user['role'];
        print('[LoginPage] ✅ Login successful! Role: $role');

        if (role == 'siswa') {
          print('[LoginPage] 🎓 Navigating to home_siswa');
          Navigator.pushReplacementNamed(context, '/home_siswa');
        } else if (role == 'guru') {
          print('[LoginPage] 👨‍🏫 Navigating to home_guru');
          Navigator.pushReplacementNamed(context, '/home_guru');
        } else if (role == 'admin') {
          print('[LoginPage] 👨‍💼 Navigating to home_admin');
          Navigator.pushReplacementNamed(context, '/home_admin');
        } else {
          print('[LoginPage] ❌ Unknown role: $role');
          setState(() {
            error = 'Role tidak dikenal';
            isLoading = false;
          });
        }
      } else {
        final msg =
            loginResult['error'] ??
            'Akun belum terdaftar di sistem (minta admin buatkan)';
        print('[LoginPage] ❌ Login failed: $msg');
        setState(() {
          error = msg;
          isLoading = false;
        });
      }
    } catch (e) {
      print('[LoginPage] 💥 Exception: $e');
      if (!mounted) return;
      setState(() {
        error = 'Terjadi kesalahan: $e';
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F6),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo.png', height: 100),
              const SizedBox(height: 24),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                elevation: 10,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Login Aplikasi Sekolah',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2C3E50),
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          prefixIcon: const Icon(Icons.email),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(Icons.lock),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            backgroundColor: const Color(0xFF3498DB),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child:
                              isLoading
                                  ? CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  )
                                  : const Text(
                                    'Login',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (error.isNotEmpty)
                        Text(error, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 12),
                    ],
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
