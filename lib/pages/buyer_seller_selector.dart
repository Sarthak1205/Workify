// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:workify/pages/first_setup/client_profile_setup.dart';
import 'package:workify/services/auth/auth_services.dart';

class BuyerSellerSelector extends StatelessWidget {
  const BuyerSellerSelector({super.key});

  void setFreelancer(BuildContext context) async {
    final authService = AuthService();
    await authService.setFreelancer();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ClientProfileSetup()), // Navigate to HomePage
    );
  }

  void setClient(BuildContext context) async {
    final authService = AuthService();
    await authService.setClient();

    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ClientProfileSetup()), // Navigate to HomePage
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          height: 650,
          width: 350,
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.purple),
              image: DecorationImage(
                  image: AssetImage("lib/images/choose_page.jpg"),
                  fit: BoxFit.cover,
                  opacity: 0.3),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "What Are You Here For ?",
                style: TextStyle(
                    fontSize: 31,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
              SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () => setFreelancer(context),
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.deepPurpleAccent,
                                Colors.blueAccent
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "I am a Freelancer",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () => setClient(context),
                    child: Container(
                      height: 60,
                      width: 300,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [
                                Colors.deepPurpleAccent,
                                Colors.blueAccent
                              ],
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft),
                          borderRadius: BorderRadius.circular(12)),
                      child: Center(
                        child: Text(
                          "I am a Client",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
