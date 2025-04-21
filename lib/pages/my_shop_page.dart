// ignore_for_file: must_be_immutable, collection_methods_unrelated_type
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workify/pages/image_fetch.dart';

class MyShopPage extends StatefulWidget {
  const MyShopPage({super.key});

  @override
  State<MyShopPage> createState() => _MyShopPageState();
}

class _MyShopPageState extends State<MyShopPage> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("My Shop"),
          centerTitle: true,
        ),
        body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(user!.uid)
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            var userDoc = snapshot.data!;

            return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection("Users")
                    .doc(user!.uid)
                    .collection("portfolio")
                    .doc(user!.uid)
                    .get(),
                builder: (context, portfolioSnapshot) {
                  if (portfolioSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!portfolioSnapshot.hasData ||
                      !portfolioSnapshot.data!.exists) {
                    return const Center(child: Text("No portfolio found"));
                  }

                  var portfolioDoc = portfolioSnapshot.data!;
                  String bannerImage = portfolioDoc['bannerImage'] ?? "";

                  return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("Shops")
                          .doc(user!.uid)
                          .get(),
                      builder: (context, shopSnapshot) {
                        if (shopSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (!shopSnapshot.hasData ||
                            !shopSnapshot.data!.exists) {
                          return const Center(
                              child: Text("No portfolio found"));
                        }

                        DocumentSnapshot<Object?> shopDoc = shopSnapshot.data!;

                        return ListView(children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 5),
                            child: Column(
                              spacing: 11,
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    shopDoc['shopIntro'],
                                    style: GoogleFonts.ubuntu(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 200,
                                  width: 460,
                                  decoration:
                                      BoxDecoration(color: Colors.blueAccent),
                                  child: bannerImage.isNotEmpty
                                      ? Image.network(bannerImage,
                                          fit: BoxFit.cover)
                                      : const Center(
                                          child: Text("No Image Available")),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                _buildSubtitle(
                                    text:
                                        "${userDoc['firstName']}, ${userDoc['lastName']}",
                                    icon: Icons.person_2_rounded),
                                _buildSubtitle(
                                    text:
                                        "${portfolioDoc['position']} at ${portfolioDoc['organization']}",
                                    icon: Icons.badge_outlined),
                                _buildSubtitle(
                                    text:
                                        "${portfolioDoc['experience']} months",
                                    icon: Icons.timelapse_outlined),
                                _buildSubtitle(
                                    text: "Skills",
                                    icon: Icons.skateboarding_outlined),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    spacing: 5,
                                    children: getSkillsList(shopDoc),
                                  ),
                                ),
                                _buildSubtitle(
                                    text: shopDoc['price'].toString(),
                                    icon: Icons.currency_rupee_rounded),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FileViewer(
                                                  freelancerId:
                                                      shopDoc['ownerId'],
                                                )));
                                  },
                                  child: _buildSubtitle(
                                      text: "My PortFolio",
                                      icon: Icons.file_present_outlined),
                                ),
                                _buildSubtitle(
                                    text: "Description",
                                    icon: Icons.notes_rounded),
                                Text(
                                  shopDoc['shopDesc'],
                                  style: GoogleFonts.ubuntu(
                                    fontSize: 15,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                        ]);
                      });
                });
          },
        ));
  }

  List<Widget> getSkillsList(DocumentSnapshot shopDoc) {
    Map<String, dynamic>? data = shopDoc.data() as Map<String, dynamic>?;

    if (data == null ||
        data['skills'] == null ||
        (data['skills'] as List).isEmpty) {
      return [const Text("No skills available")];
    }

    return (data['skills'] as List).map((skill) {
      return Text(
        "${skill['skill']} : ${skill['experience']}",
        style: GoogleFonts.ubuntu(
            color: Theme.of(context).colorScheme.inversePrimary, fontSize: 15),
      );
    }).toList();
  }

  Widget _buildSubtitle({
    IconData? icon,
    required String text,
  }) {
    return Row(children: [
      Icon(
        icon,
        size: 26,
      ),
      SizedBox(
        width: 9,
      ),
      Text(
        text,
        style: GoogleFonts.ubuntu(
          fontSize: 20,
        ),
      ),
    ]);
  }
}
