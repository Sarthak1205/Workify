import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';
import 'package:workify/components/square_tile.dart';
import 'package:workify/services/auth/auth_services.dart';

class RegisterPage extends StatelessWidget {
  final void Function()? onTap;
  RegisterPage({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    void signUp(BuildContext context) {
      final auth = AuthService();

      if (passwordController.text == confirmPasswordController.text) {
        try {
          auth.signUp(emailController.text, passwordController.text);
        } catch (e) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: Text(e.toString()),
                  ));
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => const AlertDialog(
                  title: Text("Passwords don't match"),
                ));
      }
    }

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Container(
          height: 650,
          width: 300,
          decoration: BoxDecoration(
              border: Border.all(
                  color: Theme.of(context).colorScheme.primary, width: 3),
              borderRadius: BorderRadius.circular(25)),
          child: Column(
            children: [
              SizedBox(
                height: 50,
              ),
              Icon(
                Icons.person,
                size: 90,
              ),
              SizedBox(
                height: 40,
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
              SizedBox(
                height: 15,
              ),
              MyTextfield(
                  hintText: "Confirm Password",
                  obscureText: true,
                  controller: confirmPasswordController),
              SizedBox(
                height: 15,
              ),
              MyButton(
                text: "Sign Up",
                onTap: () => signUp(context),
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
                    "Already a member? ",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      "Login Now",
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
