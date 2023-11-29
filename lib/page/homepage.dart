import 'package:flutter/material.dart';
import 'package:perpusgo/page/loginpage.dart';

class PerpustakaanHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PerpusGo'),
        centerTitle: true,
        actions: [
          // Tombol login di AppBar
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
            child: Text(
              'Login',
              style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),
            ),
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Image.asset(
                'assets/perpus.jpeg',
                height: 300,
              ),
              SizedBox(height: 16),
              Text(
                'Selamat datang di PerpusGo!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Jl. Melayang No. 68, Kota Saranjana',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              Text(
                'PerpusGo menyediakan berbagai koleksi buku yang dapat diakses oleh masyarakat. '
                'Bergabunglah dengan kegiatan-kegiatan menarik yang kami adakan secara rutin! '
                'Klik tombol Login untuk melihat koleksi buku yang tersedia',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: PerpustakaanHomePage(),
  ));
}
