import 'package:flutter/material.dart';
import 'package:perpusgo/page/listbuku.dart';


class PerpustakaanHomePage extends StatefulWidget {
  @override
  _PerpustakaanHomePageState createState() => _PerpustakaanHomePageState();
}

class _PerpustakaanHomePageState extends State<PerpustakaanHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PerpusGo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.library_books,
              size: 100.0,
              color: Colors.blue,
            ),
            SizedBox(height: 20.0),
            Text(
              'Selamat datang di Perpustakaan Mobile',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            SizedBox(
                height:
                    20.0), // Tambahkan jarak antara tombol "Jelajahi Buku" dan tombol "Login"
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => BukuListPage(),
                  ),
                  (route) => false, //To disable back feature set to false
                );
              },
              child: Text('List Buku'),
            ),
          ],
        ),
      ),
    );
  }
}
