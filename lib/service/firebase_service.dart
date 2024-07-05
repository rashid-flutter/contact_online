import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Map<String, dynamic>>> getContacts() {
    return _db.collection('contacts').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList());
  }

  Future<void> addContact(String name, String phone) async {
    await _db.collection('contacts').add({'name': name, 'phone': phone});
  }

  Future<void> deleteContact(String id) async {
    await _db.collection('contacts').doc(id).delete();
  }

  Future<void> updateContact(String id, String name, String phone) async {
    await _db
        .collection('contacts')
        .doc(id)
        .update({'name': name, 'phone': phone});
  }
}
