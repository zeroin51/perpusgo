import 'package:flutter/material.dart';
import 'package:perpusgo/dashboard/listbuku_admin.dart';
import 'package:perpusgo/dashboard/addpage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminHomePage extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      // Hapus status login dari SharedPreferences
      _clearLoginStatus();

      // Arahkan kembali ke halaman login
      Navigator.of(context).pushReplacementNamed('/login');
    } catch (e) {
      print('Terjadi kesalahan saat logout: $e');
    }
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
        title: Text('Admin Dashboard'),
        backgroundColor: Colors.redAccent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              'assets/perpus.jpeg',
              width: 30,
              height: 30,
              color: Colors.white,
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Panggil _signOut dengan mengirimkan context
              _signOut(context);
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 7,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/perpus.jpeg',
                      width: 200.0,
                      height: 200.0,
                    ),
                    SizedBox(height: 20.0),
                    Text(
                      'Selamat datang, Admin!',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => BukuListAdmin(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.redAccent,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text('Kelola Buku'),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: () {
                  Navigator.push<dynamic>(
                    context,
                    MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) => AddBuku(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                ),
                child: Text('Tambah Buku'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
