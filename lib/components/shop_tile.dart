// ignore_for_file: prefer_interpolation_to_compose_strings, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ShopTile extends StatefulWidget {
  final Map<String, dynamic> shopData;
  void Function()? onTap;

  ShopTile({super.key, required this.shopData, required this.onTap});

  @override
  State<ShopTile> createState() => _ShopTileState();
}

class _ShopTileState extends State<ShopTile> {
  List<dynamic> savedShops = [];
  User? user = FirebaseAuth.instance.currentUser;
  final firestore = FirebaseFirestore.instance;
  bool saved = false;
  Map<String, dynamic> userDoc = {};
  List<dynamic> shopList = [];

  @override
  void initState() {
    super.initState();
    getSaved();
  }

  void getSaved() async {
    var snapshot = await firestore.collection("Users").doc(user!.uid).get();

    setState(() {
      userDoc = snapshot.data()!;
      shopList = userDoc['savedShops'];
      if (shopList.contains(widget.shopData['ownerId'])) {
        saved = true;
      } else {
        saved = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.shopData['ownerId'])
          .get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Text("Owner details not found");
        }

        Map<String, dynamic> ownerData =
            snapshot.data!.data() as Map<String, dynamic>;

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Banner Image
              Container(
                height: 150,
                width: double.infinity,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  child: Image.network(
                    widget.shopData['bannerImage'],
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(height: 1),

              // Bottom Container
              GestureDetector(
                onTap: widget.onTap,
                child: Container(
                  height: 90,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        // Profile image
                        ownerData['profileImage'] == null
                            ? const CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    AssetImage("lib/images/profile.png"),
                              )
                            : CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    NetworkImage(ownerData['profileImage']),
                              ),
                        const SizedBox(width: 12),

                        // User info and shop details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${ownerData["firstName"]} ${ownerData["lastName"]}",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              Text(
                                widget.shopData["shopIntro"],
                                style: GoogleFonts.ubuntu(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                              Text(
                                "₹ ${widget.shopData["price"]}",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        IconButton(
                          onPressed: () {
                            setState(() {
                              print(saved);
                              saved = !saved;
                              print(saved);
                            });
                            if (saved) {
                              shopList.add(widget.shopData['ownerId']);
                            } else {
                              shopList.remove(widget.shopData['ownerId']);
                            }
                            firestore.collection("Users").doc(user!.uid).set(
                                {"savedShops": shopList},
                                SetOptions(merge: true));
                          },
                          icon: saved
                              ? Icon(
                                  Icons.favorite_sharp,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  size: 30,
                                )
                              : Icon(
                                  Icons.favorite_border_outlined,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                  size: 30,
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
