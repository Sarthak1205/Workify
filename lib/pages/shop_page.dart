import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/buy_preview_page.dart';
import 'package:workify/pages/chat/chat_page.dart';

class ShopPage extends StatefulWidget {
  final String shopId;
  const ShopPage({super.key, required this.shopId});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: firestore.collection("Shops").doc(widget.shopId).get(),
      builder: (context, shopSnapshot) {
        if (shopSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!shopSnapshot.hasData || !shopSnapshot.data!.exists) {
          return const Center(child: Text("Shop not found!"));
        }

        var shopDoc = shopSnapshot.data!;
        String? ownerId = shopDoc['ownerId'];

        if (ownerId == null || ownerId.isEmpty) {
          return const Center(child: Text("Owner not found!"));
        }

        // Combine user and portfolio queries
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: firestore.collection("Users").doc(ownerId).get(),
          builder: (context, ownerSnapshot) {
            if (ownerSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!ownerSnapshot.hasData || !ownerSnapshot.data!.exists) {
              return const Center(child: Text("Owner not found!"));
            }

            var ownerDoc = ownerSnapshot.data!;
            String ownerName =
                "${ownerDoc['firstName']} ${ownerDoc['lastName']}'s Shop";

            return Scaffold(
              appBar: AppBar(
                title: Text(
                  ownerName,
                  style: GoogleFonts.ubuntu(
                      color: Theme.of(context).colorScheme.secondary),
                ),
                centerTitle: true,
              ),
              body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                future: firestore
                    .collection("Users")
                    .doc(ownerId)
                    .collection('portfolio')
                    .doc(ownerId)
                    .get(),
                builder: (context, portfolioSnapshot) {
                  if (portfolioSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!portfolioSnapshot.hasData ||
                      !portfolioSnapshot.data!.exists) {
                    return const Center(child: Text("Portfolio not found!"));
                  }

                  var portfolioDoc = portfolioSnapshot.data!;
                  String bannerImage = portfolioDoc['bannerImage'] ?? "";
                  // String profileImage = portfolioDoc['profileImage'] ?? "";
                  return ListView(children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 5),
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
                            width: 480,
                            decoration: BoxDecoration(color: Colors.blueAccent),
                            child: bannerImage.isNotEmpty
                                ? Image.network(bannerImage, fit: BoxFit.cover)
                                : const Center(
                                    child: Text("No Image Available")),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Row(
                            children: [
                              // add profile to firebase
                              shopDoc['bannerImage'] == null
                                  ? CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          AssetImage("lib/images/profile.png"),
                                    )
                                  : CircleAvatar(
                                      radius: 25,
                                      backgroundImage:
                                          NetworkImage(shopDoc['bannerImage']),
                                    ),
                              SizedBox(
                                width: 25,
                              ),

                              _buildSubtitle(
                                  text:
                                      "${ownerDoc['firstName']}, ${ownerDoc['lastName']}",
                                  icon: Icons.person_2_rounded),

                              SizedBox(
                                width: 100,
                              ),

                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ChatPage(
                                              receiverEmail: ownerDoc['email'],
                                              receiverID: ownerDoc['uid'])));
                                },
                                child: Container(
                                  height: 40,
                                  width: 87,
                                  decoration: BoxDecoration(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      borderRadius: BorderRadius.circular(60)),
                                  child: Center(
                                      child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Icon(Icons.message_outlined),
                                      Text(
                                        "Chat",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  )),
                                ),
                              ),
                            ],
                          ),
                          _buildSubtitle(
                              text:
                                  "${portfolioDoc['position']} at ${portfolioDoc['organization']}",
                              icon: Icons.badge_outlined),
                          _buildSubtitle(
                              text: "${portfolioDoc['experience']} months",
                              icon: Icons.timelapse_outlined),
                          _buildSubtitle(
                              text: "Skills",
                              icon: Icons.skateboarding_outlined),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              spacing: 5,
                              children: getSkillsList(shopDoc, context),
                            ),
                          ),
                          _buildSubtitle(
                              text: _displayPrice(shopDoc),
                              icon: Icons.currency_rupee_rounded),
                          _buildSubtitle(
                              text: "My PortFolio",
                              icon: Icons.file_present_outlined),
                          _buildSubtitle(
                              text: "Description", icon: Icons.notes_rounded),
                          Row(
                            children: [
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
                        ],
                      ),
                    ),
                  ]);
                },
              ),
              floatingActionButton: _buildButton(context),
            );
          },
        );
      },
    );
  }

  List<Widget> getSkillsList(DocumentSnapshot shopDoc, BuildContext context) {
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

  String _displayPrice(DocumentSnapshot shopDoc) {
    Map<String, dynamic>? data = shopDoc.data() as Map<String, dynamic>?;
    if (data == null || data['price'] == null) {
      return "No price available";
    }
    double start = data['price'] - (data['price'] * 0.3);
    double end = data['price'] + (data['price'] * 0.3);
    return '$start - $end';
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

  Widget? _buildButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => BuyPreviewPage()));
      },
      child: Container(
        height: 60,
        width: 120,
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(60)),
        child: Center(
            child: Text(
          "Buy Service",
          style: GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.bold),
        )),
      ),
    );
  }
}
