import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> getBukuIdByJudul(String judul) async {
    String? bukuId;

    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Buku')
          .where('judul', isEqualTo: judul) // Ganti kondisi sesuai yang Anda butuhkan
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        bukuId = querySnapshot.docs.first.id;
      }
    } catch (e) {
      print('Error fetching bukuId: $e');
    }

    return bukuId;
  }
}