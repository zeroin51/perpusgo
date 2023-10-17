import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpusgo/page/listbuku.dart';

class DetailBuku extends StatelessWidget {
  final String bukuId;

  DetailBuku({required this.bukuId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _reference = FirebaseFirestore.instance.collection('Buku');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Buku'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Ikonya bisa disesuaikan dengan keinginan Anda
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BukuListPage(), // Ganti dengan kelas EditPage yang sesuai
              ),
            );
          }
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _reference.doc(bukuId).get(),
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              var bukuData = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network(
                      bukuData['images'],
                      width: double.infinity,
                      height: 300,
                      fit: BoxFit.contain,
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Judul: ${bukuData['judul']}',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Penulis: ${bukuData['penulis']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    Text(
                      'Tahun Terbit: ${bukuData['tahun']}',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              );
            }
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
