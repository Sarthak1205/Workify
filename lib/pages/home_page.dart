import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workify/components/my_drawer.dart';
import 'package:workify/pages/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? imagePath;
  @override
  void initState() {
    super.initState();
    fetchImagePath(); // Fetch image path when widget loads
  }

  Future<void> fetchImagePath() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final firestore = FirebaseFirestore.instance;
    DocumentSnapshot userDoc = await firestore
        .collection("Users")
        .doc(user.uid)
        .collection("portfolio")
        .doc(user.uid)
        .get();

    if (userDoc.exists && userDoc.data() != null) {
      setState(() {
        imagePath = (userDoc.data() as Map<String, dynamic>)['bannerImage'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Workify",
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        iconTheme:
            IconThemeData(color: Theme.of(context).colorScheme.secondary),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: GestureDetector(
              onTap: () => {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ProfilePage()))
              },
              child: Container(
                height: 45,
                width: 45,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(40)),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: imagePath == null
                      ? CircularProgressIndicator(
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : CircleAvatar(
                          radius: 20,
                          backgroundImage: NetworkImage(imagePath!),
                        ),
                ),
              ),
            ),
          )
        ],
      ),
      drawer: MyDrawer(),
    );
  }
}
