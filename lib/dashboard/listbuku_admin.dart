import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:perpusgo/dashboard/detailbuku_admin.dart';
import '../service/bukuid.dart'; // Impor FirestoreService
import 'package:perpusgo/dashboard/addpage.dart';

class BukuListAdmin extends StatefulWidget {
  @override
  _BukuListAdminState createState() => _BukuListAdminState();
}

class _BukuListAdminState extends State<BukuListAdmin> {
  CollectionReference _reference = FirebaseFirestore.instance.collection('Buku');
  late Stream<QuerySnapshot> _stream;
  FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _stream = _reference.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Buku'),
        backgroundColor: Colors.red,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/home');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                suffixIcon: IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),
              onChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi kesalahan: ${snapshot.error}'));
                }

                if (snapshot.hasData) {
                  QuerySnapshot querySnapshot = snapshot.data!;
                  List<QueryDocumentSnapshot> documents = querySnapshot.docs;
                  List<Map> items = documents.map((e) => e.data() as Map).toList();

                  List<Map> filteredItems = items.where((item) {
                    return item['judul'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        item['penulis'].toLowerCase().contains(_searchQuery.toLowerCase()) ||
                        item['tahun'].toLowerCase().contains(_searchQuery.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (BuildContext context, int index) {
                      Map thisItem = filteredItems[index];

                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        child: ListTile(
                          title: Text('${thisItem['judul']}'),
                          subtitle: Text(
                            'Penulis: ${thisItem['penulis']}, Tahun Terbit: ${thisItem['tahun']}',
                          ),
                          leading: thisItem.containsKey('images')
                              ? Image.network(
                                  '${thisItem['images']}',
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                )
                              : Container(
                                  width: 80,
                                  height: 80,
                                  color: Colors.grey,
                                ),
                          onTap: () async {
                            String judul = thisItem['judul'];
                            String? bukuId = await _firestoreService.getBukuIdByJudul(judul);

                            if (bukuId != null) {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => DetailBukuAdmin(bukuId: bukuId),
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
          ),
        ],
      ),
    );
  }
}

class BukuSearchDelegate extends SearchDelegate {
  final Stream<QuerySnapshot> items;

  BukuSearchDelegate({required this.items});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [IconButton(icon: Icon(Icons.clear), onPressed: () => query = '')];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Implementasi tampilan hasil pencarian
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: items,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator());
        }

        List<Map> searchResults = [];

        QuerySnapshot querySnapshot = snapshot.data;
        List<QueryDocumentSnapshot> documents = querySnapshot.docs;
        List<Map> allItems = documents.map((e) => e.data() as Map).toList();

        if (query.isNotEmpty) {
          searchResults = allItems
              .where((item) =>
                  item['judul'].toLowerCase().contains(query.toLowerCase()))
              .toList();
        }

        return ListView.builder(
          itemCount: searchResults.length,
          itemBuilder: (context, index) {
            final suggestion = searchResults[index];
            return ListTile(
              title: Text(suggestion['judul']),
              onTap: () {
                close(context, suggestion['judul']);
              },
            );
          },
        );
      },
    );
  }
}
