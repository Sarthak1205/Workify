import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/components/animated_button.dart';
import 'package:workify/services/auth/auth.dart';

class GetStartedPage extends StatelessWidget {
  const GetStartedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 20,
            children: [
              Image.asset(
                "lib/images/logo.png",
                color: Theme.of(context).colorScheme.primary,
              ),
              Text(
                'Welcome to Workify!',
                style: GoogleFonts.ubuntu(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
              ),
              Text(
                "\"Chase the vision, not the money. The money will end up following you.\" \n— Tony Hsieh (Zappos CEO)",
                style: GoogleFonts.ubuntu(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              MyButton(
                text: "Get Started",
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => AuthPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
