import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/components/shop_tile.dart';
import 'package:workify/pages/shop_page.dart';
import 'package:workify/services/shop/shop_service.dart';

class SavedGigs extends StatefulWidget {
  const SavedGigs({super.key});

  @override
  State<SavedGigs> createState() => _SavedGigsState();
}

class _SavedGigsState extends State<SavedGigs> {
  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;
  User? user = FirebaseAuth.instance.currentUser;
  Map<String, dynamic> userDoc = {};
  List<dynamic> shopList = [];

  @override
  void initState() {
    super.initState();
    getList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Saved Gigs",
            style: GoogleFonts.ubuntu(),
          ),
          centerTitle: true,
        ),
        body: _buildShopList());
  }

  Widget _buildShopList() {
    return StreamBuilder(
        stream: ShopService().getSavedShop(shopList),
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
    if (shopData["ownerId"] == FirebaseAuth.instance.currentUser!.uid) {
      return SizedBox(
        height: 1,
      );
    } else {
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

  void getList() async {
    var snapshot = await firestore.collection("Users").doc(user!.uid).get();

    setState(() {
      userDoc = snapshot.data()!;
      shopList = userDoc['savedShops'];
    });
    if (userDoc['savedShops'] == []) {
      Text("No data");
    }
  }
}
