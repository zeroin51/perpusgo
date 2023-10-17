import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpusgo/dashboard/editpage.dart';

class DetailBukuAdmin extends StatelessWidget {
  final String bukuId;

  DetailBukuAdmin({required this.bukuId});

  @override
  Widget build(BuildContext context) {
    CollectionReference _reference = FirebaseFirestore.instance.collection('Buku');

    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Buku'),
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
      persistentFooterButtons: <Widget>[
        ElevatedButton(
          onPressed: () {
            // Tambahkan logika untuk tombol Update di sini
            // Contoh: Navigasi ke halaman EditPage dengan membawa bukuId
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => EditBuku(bukuId: bukuId), // Ganti dengan kelas EditPage yang sesuai
              ),
            );
          },
          child: Text('Update'),
        ),
        ElevatedButton(
          onPressed: () {
            // Tambahkan logika untuk tombol Delete di sini
            // Contoh: Tampilkan konfirmasi sebelum menghapus buku
            _showDeleteConfirmationDialog(context);
          },
          child: Text('Delete'),
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
            TextButton(
              onPressed: () async {
                // Tambahkan logika penghapusan buku di sini
                _deleteBuku();
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Hapus'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog konfirmasi
              },
              child: Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  void _deleteBuku() {
    // Tambahkan logika penghapusan buku sesuai dengan bukuId
    // Misalnya:
    FirebaseFirestore.instance.collection('Buku').doc(bukuId).delete();
    // Setelah penghapusan, Anda dapat mengarahkan pengguna ke halaman lain atau melanjutkan tindakan lain yang diperlukan.
  }
}
