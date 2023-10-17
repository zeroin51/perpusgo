import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

class AddBuku extends StatefulWidget {
  const AddBuku({Key? key}) : super(key: key);

  @override
  State<AddBuku> createState() => _AddBukuState();
}

class _AddBukuState extends State<AddBuku> {
  TextEditingController _controllerJudul = TextEditingController();
  TextEditingController _controllerPenulis = TextEditingController();
  TextEditingController _controllerTahun = TextEditingController();

  final firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  final firebase_storage.Reference _storageRef =
      firebase_storage.FirebaseStorage.instance.ref('images');

  Uint8List? _imageBytes; // Untuk menyimpan byte array gambar

  String imageUrl = ''; // Memperbarui imageUrl

  Future<void> _uploadImage() async {
    try {
      if (_imageBytes != null) {
        final fileName = DateTime.now().millisecondsSinceEpoch.toString();
        final imageRef = _storageRef.child('$fileName.png');
        final uploadTask = imageRef.putData(_imageBytes!);

        await uploadTask;

        imageUrl = await imageRef.getDownloadURL();
        print('Image uploaded successfully. URL: $imageUrl');

        // Set nilai `imageUrl` ke variabel lokal untuk digunakan saat mengirim data buku ke Firebase Firestore
        setState(() {
          imageUrl = imageUrl;
          print('Image uploaded successfully. URL: $imageUrl');
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

  CollectionReference _reference =
      FirebaseFirestore.instance.collection('Buku');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Buku'),
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
                child: Text('Pick Image'),
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
                  // Validasi input data
                  if (_imageBytes == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Upload Foto Sampul Dahulu')),
                    );
                    return;
                  }

                  if (!key.currentState!.validate()) {
                    return;
                  }

                  String judulBuku = _controllerJudul.text;
                  String penulisBuku = _controllerPenulis.text;
                  String tahunBuku = _controllerTahun.text;

                  // Pastikan semua data telah diisi
                  if (judulBuku.isEmpty || penulisBuku.isEmpty || tahunBuku.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Semua data harus diisi')),
                    );
                    return;
                  }

                  // Upload gambar dan tambahkan data buku ke Firestore
                  await _uploadImage();
                  if (imageUrl.isNotEmpty) {
                    Map<String, String> dataToSend = {
                      'judul': judulBuku,
                      'penulis': penulisBuku,
                      'tahun': tahunBuku,
                      'images': imageUrl,
                    };
                    await _reference.add(dataToSend);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Data buku telah ditambahkan.'),
                      ),
                    );

                    // Kembali ke halaman utama (BukuListAdmin)
                    Navigator.of(context).pop();
                  }
                },
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
