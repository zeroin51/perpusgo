import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
            // Jika email adalah email admin, arahkan ke halaman admin
            Navigator.of(context).pushReplacementNamed(
                '/admin'); // Ganti '/admin' dengan rute halaman admin Anda
          } else {
            // Jika bukan akun admin, arahkan ke halaman beranda
            Navigator.of(context).pushReplacementNamed(
                '/home'); // Ganti '/home' dengan rute halaman beranda Anda
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
                Navigator.of(context).pushReplacementNamed(
                    '/home'); // Ganti '/home' dengan rute halaman beranda Anda
              },
              child: Text('Login as Guest'),
            ),
          ],
        ),
      ),
    );
  }
}
