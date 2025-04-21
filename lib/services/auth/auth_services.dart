import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  // Firebase instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool freelancer = true;

  // Get currently logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Sign In with Google
  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
      if (gUser == null) return null;

      final GoogleSignInAuthentication gAuth = await gUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: gAuth.accessToken,
        idToken: gAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      // Upload to Firestore
      final user = userCredential.user;
      if (user != null) {
        final userDocRef = _firestore.collection('Users').doc(user.uid);
        final userDoc = await userDocRef.get();

        if (!userDoc.exists) {
          // Create the user document if it doesn't exist
          await userDocRef.set({
            'uid': user.uid,
            'email': user.email,
            'photoURL': user.photoURL,
            'freelancer': null,
            'userInfoSet': false,
            'createdAt': FieldValue.serverTimestamp(),
          });
        } else {
          // Update login timestamp or other fields if needed
          await userDocRef.set({
            'lastLogin': FieldValue.serverTimestamp(),
          }, SetOptions(merge: true));
        }
      }

      return userCredential;
    } catch (e) {
      print('Google Sign-In error: $e');
      return null;
    }
  }

  // Sign In
  Future<UserCredential> signInWithEmailPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);

      await _firestore
          .collection("Users")
          .doc(userCredential.user!.uid)
          .update({
        'lastLogin': FieldValue.serverTimestamp(),
      }).catchError((e) {
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
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

  Future<void> setFreelancer() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).set({
        'freelancer': freelancer,
      }, SetOptions(merge: true));
    }
  }

  Future<void> setClient() async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore.collection('Users').doc(user.uid).set({
        'freelancer': !freelancer,
      }, SetOptions(merge: true));
    }
  }
}
