import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpusgo/page/detailbuku.dart';
import 'package:perpusgo/page/homepage.dart';
import '../service/bukuid.dart';

class BukuListPage extends StatelessWidget {
  BukuListPage({Key? key}) : super(key: key) {
    _stream = _reference.snapshots();
  }

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Buku');

  late Stream<QuerySnapshot> _stream;

  FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => PerpustakaanHomePage(),
              ),
            );
          },
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _stream,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            QuerySnapshot querySnapshot = snapshot.data!;
            List<QueryDocumentSnapshot> documents = querySnapshot.docs;
            List<Map> items = documents.map((e) => e.data() as Map).toList();

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (BuildContext context, int index) {
                Map thisItem = items[index];

                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(16),
                    title: Text('${thisItem['judul']}'),
                    subtitle: Text(
                      'Penulis: ${thisItem['penulis']}, Tahun Terbit: ${thisItem['tahun']}',
                    ),
                    leading: thisItem.containsKey('images')
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              '${thisItem['images']}',
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 80,
                            height: 80,
                            color: Colors.grey,
                          ),
                    onTap: () async {
                      String judul = thisItem['judul'];
                      String? bukuId =
                          await _firestoreService.getBukuIdByJudul(judul);

                      if (bukuId != null) {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailBuku(bukuId: bukuId),
                          ),
                        );
                      } else {
                        // Handle the case where bukuId is null
                        // You can display an error message or take any other action.
                      }
                    },
                  ),
                );
              },
            );
          }

          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
