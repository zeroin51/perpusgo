import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpusgo/page/detailbuku.dart';

class BukuListPage extends StatelessWidget {
  BukuListPage({Key? key}) : super(key: key);

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('Buku');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buku'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _reference.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Tidak ada data.'));
          }

          final documents = snapshot.data!.docs;

          return ListView.builder(
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              final thisItem = documents[index].data() as Map<String, dynamic>;

              return ListTile(
                title: Text('${thisItem['judul']}'),
                subtitle: Text(
                  'Penulis: ${thisItem['penulis']}, Tahun Terbit: ${thisItem['tahun']}',
                ),
                leading: Container(
                  height: 80,
                  width: 80,
                  child: thisItem.containsKey('images')
                      ? Image.network('${thisItem['images']}')
                      : Container(),
                ),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailBuku(thisItem['id']),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
