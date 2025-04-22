import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OrderServices {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  final User? user = FirebaseAuth.instance.currentUser;
  final _storage = FirebaseStorage.instance;

  Stream<QuerySnapshot> getPendingGigs() {
    List<String> queryList = ["Pending", "In Progress"];
    return _firestore
        .collection("Orders")
        .where(
          'freelancerId',
          isEqualTo: _auth.currentUser!.uid,
        )
        .where("status", whereIn: queryList)
        .snapshots();
  }

  Stream<QuerySnapshot> getEarningGigs() {
    return _firestore
        .collection("Orders")
        .where(
          'freelancerId',
          isEqualTo: _auth.currentUser!.uid,
        )
        .where("status", isEqualTo: "Completed")
        .snapshots();
  }

  Future<QuerySnapshot> getMyOrders() {
    return _firestore
        .collection("Orders")
        .where(
          'clientId',
          isEqualTo: _auth.currentUser!.uid,
        )
        .get();
  }

  Future<void> uploadWorkFiles(List<PlatformFile> files, String orderId) async {
    List<String> urls = [];

    for (var file in files) {
      if (file.path == null) continue;

      File localFile = File(file.path!);
      String fileName = file.name;

      try {
        Reference storageRef =
            _storage.ref().child("OrderSubmissions/$orderId/$fileName");
        UploadTask uploadTask = storageRef.putFile(localFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        urls.add(downloadUrl);

        print("Uploaded: $fileName | URL: $downloadUrl");
      } catch (e) {
        print("Error uploading $fileName: $e");
      }
    }
    saveFileUrls(urls, orderId);
  }

  Future<void> saveFileUrls(List<String> urls, String orderId) async {
    await _firestore.collection("Orders").doc(orderId).update({
      "workSubmission": urls,
      "timestamps.submittedAt": DateTime.now().toString()
    });
  }
}
