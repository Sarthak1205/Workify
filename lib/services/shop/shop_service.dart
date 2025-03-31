import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ShopService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> setShopInfo1(
      String org, pos, exp, shopIntro, shopDesc, shopCategory) async {
    User? user = _auth.currentUser;

    final shopId = Uuid().v4();

    try {
      await _firestore
          .collection("Users")
          .doc(user!.uid)
          .collection("portfolio")
          .doc(user.uid)
          .set({"organization": org, "position": pos, "experience": exp},
              SetOptions(merge: true));

      await _firestore.collection("Shops").doc(user.uid).set({
        "shopId": shopId,
        "ownerId": user.uid,
        "shopIntro": shopIntro,
        "shopDesc": shopDesc,
        "shopCategory": shopCategory,
      }, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setShopInfo2(List<Map<String, String>> skills) async {
    User? user = _auth.currentUser;

    try {
      await _firestore
          .collection("Shops")
          .doc(user!.uid)
          .set({"skills": skills}, SetOptions(merge: true));
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> setShopInfo3(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection("Shops")
        .doc(user!.uid)
        .set({"bannerImage": url}, SetOptions(merge: true));
  }
}
