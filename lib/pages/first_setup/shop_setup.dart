import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';
import 'package:workify/pages/first_setup/skills_page.dart';

class ShopSetupPage extends StatefulWidget {
  const ShopSetupPage({super.key});

  @override
  State<ShopSetupPage> createState() => _ShopSetupPageState();
}

class _ShopSetupPageState extends State<ShopSetupPage> {
  TextEditingController orgController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController shopIntroductionController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: 500,
        width: 350,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 3),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Step 1: Professional Info",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 40,
            ),
            MyTextfield(hintText: "Organization", controller: orgController),
            SizedBox(
              height: 15,
            ),
            MyTextfield(hintText: "Position", controller: positionController),
            SizedBox(
              height: 15,
            ),
            MyTextfield(
                hintText: "Experience (in months)",
                controller: experienceController),
            SizedBox(
              height: 15,
            ),
            MyTextfield(
                hintText: "Shop Introduction", controller: positionController),
            SizedBox(
              height: 30,
            ),
            MyButton(
              text: "Next",
              onTap: () {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => SkillsPage()));
              },
            )
          ],
        ),
      )),
    );
  }
}
