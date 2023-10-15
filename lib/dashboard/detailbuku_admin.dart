import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:perpusgo/dashboard/editpage.dart';

class DetailBuku extends StatelessWidget {
  final String bukuId;

  DetailBuku(this.bukuId);

  Future<void> _editBuku(BuildContext context) async {
    // Navigasi ke halaman edit dengan membawa ID buku
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => EditBuku(bukuId: '',),
    ));
  }

  Future<void> _deleteBuku(BuildContext context) async {
    // Hapus buku dari database
    await FirebaseFirestore.instance.collection('Buku').doc(bukuId).delete();
    // Kembali ke halaman sebelumnya (BukuListAdmin)
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Buku'),
        actions: [
          IconButton(
            onPressed: () => _editBuku(context),
            icon: Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () => _deleteBuku(context),
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('Buku').doc(bukuId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            DocumentSnapshot documentSnapshot = snapshot.data;
            Map bukuData = documentSnapshot.data() as Map;

            return ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Text('Judul: ${bukuData['judul']}'),
                Text('Penulis: ${bukuData['penulis']}'),
                Text('Tahun Terbit: ${bukuData['tahun']}'),
                SizedBox(height: 16.0),
                bukuData.containsKey('images')
                    ? Image.network(
                        '${bukuData['images']}',
                        width: 200,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                    : Container(
                        width: 200,
                        height: 200,
                        color: Colors.grey, // Warna latar belakang default jika tidak ada gambar
                      ),
              ],
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
