import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';
import 'package:workify/components/square_tile.dart';
import 'package:workify/services/auth/auth_services.dart';

class LoginPage extends StatelessWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    void signIn() async {
      final authService = AuthService();
      authService.signInWithEmailPassword(
          emailController.text, passwordController.text);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          height: 612,
          width: 300,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 3),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              SizedBox(
                height: 55,
              ),
              Container(
                height: 100,
                padding: EdgeInsets.all(20),
                child: Image.asset(
                  "lib/images/logo.png",
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              MyTextfield(
                  hintText: "Email",
                  obscureText: false,
                  controller: emailController),

              SizedBox(
                height: 15,
              ),

              MyTextfield(
                  hintText: "Password",
                  obscureText: true,
                  controller: passwordController),
              const SizedBox(height: 20),

              //forgot password
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 15,
              ),

              MyButton(
                text: "Login",
                onTap: signIn,
              ),

              const SizedBox(
                height: 25,
              ),

              SquareTile(
                imagePath: "lib/images/google.png",
                onTap: () => {},
              ),

              const SizedBox(
                height: 25,
              ),
              // register now
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Not a member? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Register Now",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
