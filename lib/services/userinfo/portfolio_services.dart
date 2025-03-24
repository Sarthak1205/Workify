import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PortfolioServices {
  final _firestore = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  Future<void> saveImageURL(String url) async {
    User? user = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection("Users")
        .doc(user!.uid)
        .collection("portfolio")
        .doc(user.uid)
        .set({"bannerImage": url}, SetOptions(merge: true));
  }

  Future<void> saveFileUrls(List<String> urls) async {
    User? user = FirebaseAuth.instance.currentUser;
    await _firestore
        .collection("Users")
        .doc(user!.uid)
        .collection("portfolio")
        .doc(user.uid)
        .set({"urls": urls}, SetOptions(merge: true));
  }

  Future<void> uploadMultipleFiles(List<PlatformFile> files) async {
    List<String> urls = [];
    for (var file in files) {
      if (file.path == null) continue; // Skip files without a path

      File localFile = File(file.path!);
      String fileName = file.name;

      try {
        Reference storageRef = _storage.ref().child("uploads/$fileName");
        UploadTask uploadTask = storageRef.putFile(localFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        urls.add(downloadUrl);

        print("Uploaded: $fileName | URL: $downloadUrl");
      } catch (e) {
        print("Error uploading $fileName: $e");
      }
    }
    saveFileUrls(urls);
  }

  Future<void> uploadImageToFirebase(
      String imagePath, String folderName) async {
    if (imagePath.isEmpty) return;

    File file = File(imagePath);
    String fileName = imagePath.split('/').last;

    try {
      Reference storageRef = _storage.ref().child("$folderName/$fileName");

      UploadTask uploadTask = storageRef.putFile(file);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      saveImageURL(downloadUrl);

      print("Image Uploaded! Download URL: $downloadUrl");
    } catch (e) {
      print("Error uploading image: $e");
    }
  }
}
