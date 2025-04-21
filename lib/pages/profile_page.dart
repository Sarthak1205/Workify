// ignore_for_file: must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/edit_profile_page.dart';

class ProfilePage extends StatelessWidget {
  final String userId;
  ProfilePage({super.key, required this.userId});

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Profile",
          style: GoogleFonts.ubuntu(),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(userId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var userDoc = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.only(bottom: 40.0, right: 25, left: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      Container(
                        height: 150,
                        width: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(90),
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: userDoc['photoURL'] == ""
                              ? CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                    "lib/images/profile.png",
                                  ),
                                )
                              : CircleAvatar(
                                  radius: 20,
                                  backgroundImage:
                                      NetworkImage(userDoc["photoURL"]),
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Text(
                        "${userDoc['firstName']} ${userDoc['lastName']}",
                        style: GoogleFonts.ubuntu(
                          fontSize: 24,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${userDoc['email']}",
                        style: GoogleFonts.ubuntu(
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      _buildSubtitle(icon: Icons.edit, text: "Bio"),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "${userDoc['bio']}",
                        style: GoogleFonts.ubuntu(
                            fontSize: 18,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                        textAlign: TextAlign.left,
                        softWrap: true,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      _buildSubtitle(
                          icon: Icons.date_range, text: "${userDoc['dob']}"),
                      SizedBox(
                        height: 20,
                      ),
                      _buildSubtitle(
                          icon: Icons.location_on,
                          text: "${userDoc['city']}, ${userDoc['country']}"),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      EditProfilePage(userId: user!.uid)));
                        },
                        icon: Icon(
                          Icons.edit,
                          size: 30,
                        )),
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
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
        width: 10,
      ),
      Text(
        text,
        style: GoogleFonts.ubuntu(
          fontSize: 24,
        ),
      ),
    ]);
  }
}
