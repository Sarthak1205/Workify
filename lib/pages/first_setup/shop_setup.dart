import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';

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
  TextEditingController shopDescriptionController = TextEditingController();

  void setShopData() {
    List<String> text = [
      orgController.text,
      positionController.text,
      experienceController.text,
      shopIntroductionController.text,
      shopDescriptionController.text
    ];
    bool valid = true;
    for (String s in text) {
      if (s.isEmpty) {
        valid = false;
        break;
      }
    }

    if (valid) {
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
        "Text Fields cannot be empty!",
        textAlign: TextAlign.center,
      )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: 700,
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
              height: 45,
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
                hintText: "Shop Introduction",
                controller: shopIntroductionController),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                maxLines: 6,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  )),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary)),
                  fillColor: Theme.of(context).colorScheme.surface,
                  filled: true,
                  hintText: "Shop Description...",
                  hintStyle: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 25,
            ),
            MyButton(text: "Next", onTap: setShopData)
          ],
        ),
      )),
    );
  }
}
