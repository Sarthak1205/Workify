import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get currently logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      // Update last login timestamp and ensure required fields exist
      await _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .update({
        'lastLogin': FieldValue.serverTimestamp(),
      }).catchError((e) {
        // If the document doesn't exist, create it (only for safety)
        _firestore.collection("Users").doc(userCredential.user!.uid).set({
          'uid': userCredential.user!.uid,
          'email': email,
          'freelancer': null,
          'userInfoSet': false,
          'lastLogin': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<UserCredential> signUp(String email, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _firestore.collection("Users").doc(userCredential.user!.uid).set({
        'uid': userCredential.user!.uid,
        'email': email,
        'freelancer': null,
        'userInfoSet': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      return userCredential;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.code);
    }
  }

  Future<void> signOut() async {
    return await _auth.signOut();
  }

  Future<void> setFreelancer() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'freelancer': true,
      });
    }
  }

  Future<void> setClient() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).update({
        'freelancer': false,
      });
    }
  }
}
