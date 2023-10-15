import 'package:flutter/material.dart';
import 'package:perpusgo/dashboard/listbuku_admin.dart';
import 'package:perpusgo/dashboard/addpage.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Dashboard'), // Ganti judul sesuai kebutuhan Anda
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.dashboard,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(height: 20.0),
            Text(
              'Selamat datang, Admin!',
              style: TextStyle(fontSize: 18.0),
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
              child: Text('Tambah Buku'),
            ),
            
          ],
        ),
      ),
    );
  }
}
