// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/components/my_drawer.dart';
import 'package:workify/components/shop_tile.dart';
import 'package:workify/pages/profile_page.dart';
import 'package:workify/pages/shop_by_tag.dart';
import 'package:workify/pages/shop_page.dart';
import 'package:workify/services/shop/shop_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _shop = ShopService();
  String? imagePath;
  @override
  void initState() {
    super.initState();
    fetchImagePath();
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
        title: Image.asset(
          "lib/images/logo.png",
          scale: 1.7,
          color: Theme.of(context).colorScheme.secondary,
        ),
        iconTheme: IconThemeData(
            color: Theme.of(context).colorScheme.secondary, size: 36),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 5.0),
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search . . .",
                hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Theme.of(context).colorScheme.secondary)),
                fillColor: Theme.of(context).colorScheme.surface,
                filled: true,
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.primary,
                )),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Text(
              "Popular Tags",
              style:
                  GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 9.0),
            child: SizedBox(
              height: 160,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryItem(
                      imagePath: "lib/images/tags/food_tag.jpg", tag: "Food"),
                  _buildCategoryItem(
                      imagePath: "lib/images/tags/Illustration_icons.jpeg",
                      tag: "Illustration"),
                  _buildCategoryItem(
                      imagePath: "lib/images/tags/Logo_Design.png",
                      tag: "Logo Design"),
                  _buildCategoryItem(
                      imagePath: "lib/images/tags/ios_development_logo.png",
                      tag: "iOS Development"),
                  _buildCategoryItem(
                      imagePath: "lib/images/tags/GAme_development_logo.jpeg",
                      tag: "Game Development"),
                  _buildCategoryItem(
                      imagePath: "lib/images/tags/YouTubeVideoEditing.jpeg",
                      tag: "YT Video Editing")
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
            child: Text(
              "Gigs you may like",
              style:
                  GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: _buildShopList())
        ],
      ),
    );
  }

  Widget _buildCategoryItem({required String imagePath, required String tag}) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ShopByTag(tag: tag)));
            },
            child: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: Image.asset(
                    imagePath,
                    height: 40,
                    width: 40,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: 100,
            child: Text(
              tag,
              textAlign: TextAlign.center,
              softWrap: true,
              overflow: TextOverflow.visible,
              style: GoogleFonts.ubuntu(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShopList() {
    return StreamBuilder(
        stream: _shop.getShopStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          return ListView(
            children: snapshot.data!
                .map<Widget>(
                    (shopData) => _buildShopViewItem(shopData, context))
                .toList(),
          );
        });
  }

  Widget _buildShopViewItem(
      Map<String, dynamic> shopData, BuildContext context) {
    return ShopTile(
      shopData: shopData,
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ShopPage(shopId: shopData['ownerId'])));
      },
    );
  }
}
