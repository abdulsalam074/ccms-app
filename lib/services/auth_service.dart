import 'package:ccms/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  //--------------------------------
  // Get Current User
  //--------------------------------
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  //--------------------------------
  // Register
  //--------------------------------

  Future<String> register(
      String name,
      String email,
      String password
      ) async {

    try {

      UserCredential credential =
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      UserModel user = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
      );

      await _firestore
          .collection("users")
          .doc(user.uid)
          .set(user.toMap());

      return "success";

    } catch (e) {

      return e.toString();

    }

  }

  //--------------------------------
  // Login
  //--------------------------------

  Future<String> login(String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      return "success";
    } catch (e) {
      return e.toString();
    }
  }

  //--------------------------------
  // Logout
  //--------------------------------

  Future<void> logout() async {

    await _auth.signOut();

  }

}
