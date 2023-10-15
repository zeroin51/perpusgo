import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DetailBuku extends StatefulWidget {
  DetailBuku(this.itemId, {Key? key}) : super(key: key);

  final String itemId;

  @override
  _DetailBukuState createState() => _DetailBukuState();
}

class _DetailBukuState extends State<DetailBuku> {
  final CollectionReference _reference = FirebaseFirestore.instance.collection('Buku');
  late Future<DocumentSnapshot> _futureData;

  @override
  void initState() {
    super.initState();
    _futureData = _reference.doc(widget.itemId).get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Buku'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _futureData,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData) {
            return Center(child: Text('Data tidak ditemukan.'));
          }

          final data = snapshot.data!.data() as Map<String, dynamic>;

          return Column(
            children: [
              Text('${data['judul']}'),
              Text('${data['penulis']}'),
              Text('${data['tahun']}'),
            ],
          );
        },
      ),
    );
  }
}
