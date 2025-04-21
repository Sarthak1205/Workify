import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInfoServices {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  bool isFreelancer = false;
  bool userProfileSet = false;

  Future<void> fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      isFreelancer = userDoc["freelancer"] ?? false;
      userProfileSet = userDoc["userInfoSet"] ?? false;
    }
  }

  bool checkFreelancer() {
    fetchUserRole();
    return isFreelancer;
  }

  bool checkUserInfoSet() {
    fetchUserRole();
    return userProfileSet;
  }

  Future<void> setUserInfo(
      String firstName, lastName, gender, city, country, bio, dob) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        bool profileSetCheck = !checkFreelancer();
        await _firestore.collection("Users").doc(user.uid).set({
          "firstName": firstName,
          "lastName": lastName,
          "gender": gender,
          "city": city,
          "country": country,
          "bio": bio,
          "dob": dob,
          "userInfoSet": profileSetCheck,
          "photoURL": ""
        }, SetOptions(merge: true));
      } on FirebaseException catch (e) {
        print(e.toString());
        return;
      }
    }
  }

  Future<bool> isUserFieldNull(String fieldName) async {
    User? user = FirebaseAuth.instance.currentUser; // Get logged-in user

    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      if (userDoc.exists) {
        Map<String, dynamic>? userData =
            userDoc.data() as Map<String, dynamic>?;

        if (userData != null && userData.containsKey(fieldName)) {
          return userData[fieldName] == null; // Returns true if field is null
        } else {
          return true; // Field does not exist, consider it null
        }
      }
    }

    return true; // User is not logged in or document doesn't exist
  }
}
