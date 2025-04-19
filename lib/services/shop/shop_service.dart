import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class ShopService {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  Future<void> setShopInfo1(String org, pos, exp, shopIntro, shopDesc,
      shopCategory, price, deliveryTime) async {
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
        "price": price,
        "deliveryTime": deliveryTime
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

  Stream<List<Map<String, dynamic>>> getShopStream() {
    return _firestore.collection("Shops").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        //go through individual shop
        final shop = doc.data();
        //return shop
        return shop;
      }).toList();
    });
  }
}
