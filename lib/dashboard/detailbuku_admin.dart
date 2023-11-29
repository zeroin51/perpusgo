import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpusgo/dashboard/editpage.dart';

class DetailBukuAdmin extends StatelessWidget {
  final String bukuId;

  DetailBukuAdmin({required this.bukuId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _reference =
        FirebaseFirestore.instance.collection('Buku');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Buku'),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditBuku(bukuId: bukuId),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _reference.doc(bukuId).get(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                  child: Text('Terjadi kesalahan: ${snapshot.error}'));
            }
            if (snapshot.hasData) {
              var bukuData = snapshot.data!.data() as Map<String, dynamic>;
              return SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ClipRRect(
                      child: Image.network(
                        bukuData['images'],
                        width: double.infinity,
                        height: 300,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Text(
                      'Judul: ${bukuData['judul']}',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      'Penulis: ${bukuData['penulis']}',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 8.0),
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
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {
            _showDeleteConfirmationDialog(context);
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
          ),
          child: Text('Hapus'),
        ),
      ],
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus buku ini?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () async {
                _deleteBuku();
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.red,
              ),
              child: Text('Hapus'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.grey,
              ),
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBuku() {
    FirebaseFirestore.instance.collection('Buku').doc(bukuId).delete();
  }
}
