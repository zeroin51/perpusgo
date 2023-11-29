import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Check login status when the page is initialized
    _checkLoginStatus();
  }

  // Check login status and navigate to the home page if already logged in
  Future<void> _checkLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isAdminLoggedIn = prefs.getBool('isAdminLoggedIn') ?? false;

    if (isAdminLoggedIn) {
      // If admin is already logged in, navigate to the admin home page
      Navigator.of(context).pushReplacementNamed('/admin');
    }
  }

  Future<void> _signInWithEmailAndPassword() async {
    try {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();

      if (email.isNotEmpty && password.isNotEmpty) {
        final UserCredential userCredential =
            await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        final User? user = userCredential.user;
        if (user != null) {
          // Login berhasil, lanjutkan ke halaman beranda atau halaman admin sesuai dengan email admin
          print('Login berhasil: ${user.email}');

          if (user.email == 'admin@admin.com') {
            // Jika email adalah email admin, simpan status login admin
            _saveAdminLoginStatus();
            // Arahkan ke halaman admin
            Navigator.of(context).pushReplacementNamed('/admin');
          } else {
            // Jika bukan akun admin, simpan status login pengguna biasa
            _saveUserLoginStatus();
            // Arahkan ke halaman beranda
            Navigator.of(context).pushReplacementNamed('/home');
          }
        } else {
          // Login gagal, tampilkan pesan kesalahan atau tindakan yang sesuai
          print('Login gagal');
        }
      } else {
        // Email atau password kosong
        print('Masukkan email dan password');
      }
    } catch (e) {
      // Handle error
      print('Terjadi kesalahan: $e');
    }
  }

  // Simpan status login admin
  Future<void> _saveAdminLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAdminLoggedIn', true);
  }

  // Simpan status login pengguna biasa
  Future<void> _saveUserLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isAdminLoggedIn', false);
  }

  // Hapus status login dari SharedPreferences
  Future<void> _clearLoginStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('isAdminLoggedIn');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login dengan Email'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                prefixIcon: Icon(Icons.email),
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: Icon(Icons.lock),
              ),
              obscureText: true, // Sembunyikan teks password
            ),
            SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _signInWithEmailAndPassword,
              child: Text('Login'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
              ),
            ),
            SizedBox(height: 16.0),
            TextButton(
              onPressed: () {
                // Arahkan pengguna ke halaman beranda
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: Text('Login as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
