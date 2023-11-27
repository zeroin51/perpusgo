import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class EditBuku extends StatefulWidget {
  final String bukuId;

  EditBuku({required this.bukuId});

  @override
  _EditBukuState createState() => _EditBukuState();
}

class _EditBukuState extends State<EditBuku> {
  TextEditingController _controllerJudul = TextEditingController();
  TextEditingController _controllerPenulis = TextEditingController();
  TextEditingController _controllerTahun = TextEditingController();

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final firebase_storage.Reference _storageRef =
      firebase_storage.FirebaseStorage.instance.ref('images');

  Uint8List? _imageBytes; // To store the image byte array
  String imageUrl = ''; // Update imageUrl

  @override
  void initState() {
    super.initState();
    // Fetch existing data from Firestore when the widget is initialized
    _fetchExistingData();
  }

  Future<void> _fetchExistingData() async {
    try {
      DocumentSnapshot snapshot = await FirebaseFirestore.instance
          .collection('Buku')
          .doc(widget.bukuId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        setState(() {
          _controllerJudul.text = data['judul'] ?? '';
          _controllerPenulis.text = data['penulis'] ?? '';
          _controllerTahun.text = data['tahun'] ?? '';
          imageUrl = data['images'] ?? '';
          // Fetch and display image if imageUrl is not empty
          if (imageUrl.isNotEmpty) {
            _loadImage();
          }
        });
      }
    } catch (error) {
      print('Error fetching existing data: $error');
    }
  }

  Future<void> _loadImage() async {
  try {
    // Load image from Firebase Storage based on imageUrl
    firebase_storage.Reference imageRef = storage.refFromURL(imageUrl);
    final imageBytes = await imageRef.getData();
    setState(() {
      _imageBytes = imageBytes;
    });
  } catch (error) {
    print('Error loading image: $error');
  }
}



  Future<void> _uploadImage() async {
    try {
      if (_imageBytes != null) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = _storageRef.child('$fileName.png');
        final uploadTask = imageRef.putData(_imageBytes!);

        await uploadTask;

        imageUrl = await imageRef.getDownloadURL();
        print('Image uploaded successfully. URL: $imageUrl');

        setState(() {
          imageUrl = imageUrl;
        });
      }
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final Uint8List imageBytes = await pickedFile.readAsBytes();

      setState(() {
        _imageBytes = imageBytes;
      });
    }
  }

  GlobalKey<FormState> key = GlobalKey();

  CollectionReference _reference = FirebaseFirestore.instance.collection('Buku');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Buku'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: key,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              if (_imageBytes != null)
                Image.memory(
                  _imageBytes!,
                  width: 200,
                  height: 200,
                  fit: BoxFit.cover,
                )
              else
                Text('No image selected'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _pickImage,
                child: Text('Change Image'),
              ),
              TextFormField(
                controller: _controllerJudul,
                decoration: InputDecoration(hintText: 'Masukkan Judul Buku'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Judul Buku Dahulu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerPenulis,
                decoration: InputDecoration(hintText: 'Masukkan Penulis Buku'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Penulis Buku Dahulu';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _controllerTahun,
                decoration:
                    InputDecoration(hintText: 'Masukkan Tahun Buku Terbit'),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan Tahun Buku Terbit Dahulu';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () async {
                  await _uploadImage();
                  if (imageUrl.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Masukkan Gambar terlebih dahulu!')));
                    return;
                  }

                  if (key.currentState!.validate()) {
                    String judulBuku = _controllerJudul.text;
                    String penulisBuku = _controllerPenulis.text;
                    String tahunBuku = _controllerTahun.text;

                    Map<String, String> dataToUpdate = {
                      'judul': judulBuku,
                      'penulis': penulisBuku,
                      'tahun': tahunBuku,
                      'images': imageUrl,
                    };

                    await _reference.doc(widget.bukuId).update(dataToUpdate);

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Book data has been updated.'),
                      ),
                    );

                    // Go back to the previous page (BukuListAdmin)
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
