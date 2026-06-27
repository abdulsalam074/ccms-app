import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/complaint_model.dart';

class ComplaintService {

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  final String collection = "complaints";

  // CREATE
  Future<String> addComplaint(
      ComplaintModel complaint) async {

    await _firestore
        .collection(collection)
        .add(complaint.toMap());

    return "Complaint Added";
  }

  // READ
  Stream<List<ComplaintModel>> getComplaints() {

    return _firestore
        .collection(collection)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        ComplaintModel.fromMap(
            doc.data(), doc.id))
        .toList());
  }

  // UPDATE  ✅ ADD THIS
  Future<void> updateComplaint(
      String id,
      ComplaintModel complaint) async {

    await _firestore
        .collection(collection)
        .doc(id)
        .update(complaint.toMap());
  }

  // DELETE
  Future<void> deleteComplaint(String id) async {

    await _firestore
        .collection(collection)
        .doc(id)
        .delete();
  }
}
