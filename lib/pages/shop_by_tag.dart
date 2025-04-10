import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/components/shop_tile.dart';
import 'package:workify/pages/shop_page.dart';
import 'package:workify/services/tag/tag_services.dart';

class ShopByTag extends StatelessWidget {
  final String tag;
  const ShopByTag({super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
      future: TagServices().getShopsByTag(tag),
      builder: (context, tagSnapshot) {
        if (!tagSnapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        List<Map<String, dynamic>> shopDocs =
            tagSnapshot.data!.docs.map((doc) => doc.data()).toList();

        return Scaffold(
          appBar: AppBar(
              title: Text(
            "Results For $tag",
            style: GoogleFonts.ubuntu(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.inversePrimary),
          )),
          body: shopDocs.isEmpty
              ? Center(
                  child: Text(
                  "No shops found for $tag",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.inversePrimary),
                ))
              : Column(
                  children: [
                    SizedBox(
                      height: 35,
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: shopDocs.length,
                          itemBuilder: (context, index) {
                            return _buildShopViewItem(shopDocs[index], context);
                          }),
                    )
                  ],
                ),
        );
      },
    );
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
