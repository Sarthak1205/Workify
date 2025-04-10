import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/components/my_button.dart';

class BillPage extends StatelessWidget {
  final String ownerId;
  BillPage({super.key, required this.ownerId});

  final firestore = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final int platformFee = 3;

    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: firestore.collection("Users").doc(auth.currentUser!.uid).get(),
        builder: (context, clientSnapshot) {
          if (clientSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!clientSnapshot.hasData || !clientSnapshot.data!.exists) {
            return const Center(child: Text("Portfolio not found!"));
          }

          var clientDoc = clientSnapshot.data!;
          return FutureBuilder(
              future: firestore.collection("Users").doc(ownerId).get(),
              builder: (context, freelancerSnapshot) {
                if (freelancerSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!freelancerSnapshot.hasData ||
                    !freelancerSnapshot.data!.exists) {
                  return const Center(child: Text("Portfolio not found!"));
                }
                var freelancerDoc = freelancerSnapshot.data!;

                return FutureBuilder(
                    future: firestore.collection("Shops").doc(ownerId).get(),
                    builder: (context, shopSnapshot) {
                      if (shopSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!shopSnapshot.hasData || !shopSnapshot.data!.exists) {
                        return const Center(
                            child: Text("Portfolio not found!"));
                      }
                      var shopDoc = shopSnapshot.data!;
                      return Scaffold(
                        appBar: AppBar(
                          title: Text("Bill", style: GoogleFonts.ubuntu()),
                          centerTitle: true,
                        ),
                        body: Center(
                          child: Container(
                            height: 650,
                            width: 350,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 3),
                                borderRadius: BorderRadius.circular(25)),
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 25,
                                ),
                                _buildSubtitle(text: "Service Provider"),
                                _buildChild(
                                    text:
                                        "${freelancerDoc['firstName']} ${freelancerDoc['lastName']}",
                                    context: context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildSubtitle(text: "Service Type"),
                                _buildChild(
                                    text: shopDoc['shopCategory'],
                                    context: context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildSubtitle(text: "Service"),
                                _buildChild(
                                    text: shopDoc['shopIntro'],
                                    context: context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildSubtitle(text: "Name"),
                                _buildChild(
                                    text: clientDoc['firstName'],
                                    context: context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildSubtitle(text: "Service Price"),
                                _buildChild(
                                    text: "₹ ${shopDoc['price']}",
                                    context: context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildSubtitle(text: "Platform Fee"),
                                _buildChild(
                                    text: "₹ $platformFee", context: context),
                                SizedBox(
                                  height: 10,
                                ),
                                _buildSubtitle(text: "Total Price"),
                                _buildChild(
                                    text: "₹ ${shopDoc['price'] + platformFee}",
                                    context: context),
                                SizedBox(
                                  height: 40,
                                ),
                                MyButton(
                                  text:
                                      "Buy Now (₹ ${shopDoc['price'] + platformFee})",
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              });
        });
  }

  Widget _buildSubtitle({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
      child: Row(
        children: [
          Text(
            text,
            style:
                GoogleFonts.ubuntu(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildChild({required String text, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 1),
      child: Row(
        children: [
          Text(
            text,
            style: GoogleFonts.ubuntu(
                fontSize: 16,
                fontWeight: FontWeight.normal,
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
        ],
      ),
    );
  }
}
