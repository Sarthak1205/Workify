import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class TagServices {
  //final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<QuerySnapshot<Map<String, dynamic>>> getShopsByTag(String tag) {
    return _firestore
        .collection("Shops")
        .where("shopCategory", isEqualTo: tag)
        .get();
  }
}
