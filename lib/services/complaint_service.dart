import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/complaint_model.dart';

class ComplaintService {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String collection = "complaints";

  Future<String> addComplaint(
      ComplaintModel complaint) async {
    try {
      await _firestore
          .collection(collection)
          .add(complaint.toMap());

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  Stream<List<ComplaintModel>> getComplaints() {
    return _firestore
        .collection(collection)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ComplaintModel.fromMap(
          doc.data(),
          doc.id,
        );
      }).toList();
    });
  }

  Future<void> deleteComplaint(String id) async {
    await _firestore.collection(collection).doc(id).delete();
  }

  Future<void> updateStatus(
      String id,
      String status) async {
    await _firestore
        .collection(collection)
        .doc(id)
        .update({
      "status": status,
    });
  }
}
