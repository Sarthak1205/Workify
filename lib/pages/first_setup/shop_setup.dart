import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';
import 'package:workify/pages/first_setup/skills_page.dart';
import 'package:workify/services/shop/shop_service.dart';

class ShopSetupPage extends StatefulWidget {
  const ShopSetupPage({super.key});

  @override
  State<ShopSetupPage> createState() => _ShopSetupPageState();
}

class _ShopSetupPageState extends State<ShopSetupPage> {
  final _shop = ShopService();
  TextEditingController orgController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController shopIntroductionController = TextEditingController();
  TextEditingController shopDescriptionController = TextEditingController();
  TextEditingController shopCategoryController = TextEditingController();
  final priceController = TextEditingController();
  final deliveryController = TextEditingController();

  void setShopData() {
    bool valid = true;

    for (String s in [
      orgController.text,
      positionController.text,
      experienceController.text,
      shopIntroductionController.text,
      shopDescriptionController.text,
      shopCategoryController.text,
      priceController.text,
      deliveryController.text
    ]) {
      if (s.trim().isEmpty) {
        valid = false;
        break;
      }
    }

    if (valid) {
      _shop.setShopInfo1(
        orgController.text,
        positionController.text,
        experienceController.text,
        shopIntroductionController.text,
        shopDescriptionController.text,
        shopCategoryController.text,
        double.parse(priceController.text),
        double.parse(deliveryController.text),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SkillsPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Text Fields cannot be empty!",
            textAlign: TextAlign.center,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Container(
        height: 800,
        width: 350,
        decoration: BoxDecoration(
            border: Border.all(
                color: Theme.of(context).colorScheme.primary, width: 3),
            borderRadius: BorderRadius.circular(16)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 8,
          children: [
            Text(
              "Step 1: Professional Info",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            MyTextfield(hintText: "Organization", controller: orgController),
            MyTextfield(hintText: "Position", controller: positionController),
            MyTextfield(
                hintText: "Experience (in months)",
                controller: experienceController),
            MyTextfield(
                hintText: "Shop Introduction",
                controller: shopIntroductionController),
            MyTextfield(
                hintText: "Shop Category", controller: shopCategoryController),
            MyTextfield(
                hintText: "Service Pricing", controller: priceController),
            MyTextfield(
                hintText: "Delivery Time", controller: deliveryController),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: shopDescriptionController,
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
              height: 10,
            ),
            MyButton(text: "Next", onTap: setShopData)
          ],
        ),
      )),
    );
  }
}
