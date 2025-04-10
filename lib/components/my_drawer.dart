// ignore_for_file: library_private_types_in_public_api
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/inbox_page.dart';
import 'package:workify/pages/my_shop_page.dart';
import 'package:workify/pages/settings_page.dart';
import 'package:workify/services/auth/auth_services.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  bool isFreelancer = false;

  @override
  void initState() {
    super.initState();
    fetchUserRole();
  }

  void fetchUserRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(user.uid)
          .get();

      setState(() {
        isFreelancer = userDoc["freelancer"] ?? false;
      });
    }
  }

  void logOut() {
    final authService = AuthService();
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(
                child: Center(
                  child: Icon(
                    Icons.message,
                    color: Theme.of(context).colorScheme.secondary,
                    size: 60,
                  ),
                ),
              ),

              _buildDrawerItem(
                icon: Icons.home,
                text: "H O M E",
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                icon: Icons.chat_outlined,
                text: "I N B O X",
                onTap: () {
                  // Navigate to My Inbox page
                  Navigator.pop(context);
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => InboxPage()));
                },
              ),

              if (isFreelancer) ...[
                _buildDrawerItem(
                    icon: Icons.build_outlined,
                    text: "M Y  S H O P",
                    onTap: () {
                      // Navigate to My Shop page
                      Navigator.pop(context);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyShopPage()));
                    }),
                _buildDrawerItem(
                  icon: Icons.work,
                  text: "M Y  G I G S",
                  onTap: () {
                    // Navigate to My Gigs page
                  },
                ),
                _buildDrawerItem(
                  icon: Icons.attach_money,
                  text: "E A R N I N G S",
                  onTap: () {
                    // Navigate to Earnings page
                  },
                ),
              ] else ...[
                _buildDrawerItem(
                    icon: Icons.sell,
                    text: "B E C O M E  A  S E L L E R",
                    onTap: () {
                      // Navigate to Shop Setup Page
                    })
              ],

              _buildDrawerItem(
                icon: Icons.shopping_cart,
                text: "M Y  O R D E R S",
                onTap: () {
                  // Navigate to My Orders page
                },
              ),
              // _buildDrawerItem(
              //   icon: Icons.favorite,
              //   text: "S A V E D  G I G S",
              //   onTap: () {
              //     // Navigate to Saved Gigs page
              //   },
              // ),

              // Settings
              _buildDrawerItem(
                icon: Icons.settings,
                text: "S E T T I N G S",
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsPage()),
                  );
                },
              ),
            ],
          ),

          // Logout
          Padding(
            padding: const EdgeInsets.only(left: 25.0, bottom: 25),
            child: ListTile(
              title: Text(
                "L O G O U T",
                style: GoogleFonts.ubuntu(
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              leading: Icon(
                Icons.logout,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onTap: logOut,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0),
      child: ListTile(
        title: Text(
          text,
          style: GoogleFonts.ubuntu(
              color: Theme.of(context).colorScheme.secondary),
        ),
        leading: Icon(icon, color: Theme.of(context).colorScheme.secondary),
        onTap: onTap,
      ),
    );
  }
}
