import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workify/pages/buyer_seller_selector.dart';
import 'package:workify/pages/home_page.dart';
import 'package:workify/services/auth/auth_services.dart';
import 'package:workify/services/auth/register_or_login.dart';
import 'package:workify/services/userinfo/user_info_services.dart';

class AuthPage extends StatelessWidget {
  AuthPage({super.key});
  final authService = AuthService();
  final userInfo = UserInfoServices();

  Future<bool> checkNull() async {
    return await userInfo.isUserFieldNull("freelancer");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // If user is logged in
          if (snapshot.hasData) {
            return FutureBuilder<bool>(
              future: checkNull(),
              builder: (context, roleSnapshot) {
                if (roleSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (roleSnapshot.hasData && roleSnapshot.data == true) {
                  return BuyerSellerSelector();
                } else {
                  return HomePage();
                }
              },
            );
          } else {
            return LoginOrRegister();
          }
        },
      ),
    );
  }
}
