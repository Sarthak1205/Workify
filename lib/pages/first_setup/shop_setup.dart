import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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

  // Controllers
  final orgController = TextEditingController();
  final positionController = TextEditingController();
  final experienceController = TextEditingController();
  final shopIntroductionController = TextEditingController();
  final shopDescriptionController = TextEditingController();
  final shopCategoryController = TextEditingController();
  final priceController = TextEditingController();
  final deliveryController = TextEditingController();

  // Category selection
  bool isCategoryEditing = false;
  String categorySearch = '';
  String? selectedCategory;

  final List<String> allCategories = [
    "Graphic Design",
    "Illustration",
    "UI/UX Design",
    "Web Design",
    "Frontend Development",
    "Backend Development",
    "Full-Stack Development",
    "Flutter Development",
    "React Development",
    "Mobile App Development",
    "Android Development",
    "iOS Development",
    "Game Development",
    "WordPress Development",
    "Copywriting",
    "Content Writing",
    "SEO Writing",
    "Technical Writing",
    "Ghostwriting",
    "Social Media Marketing",
    "SEO Optimization",
    "Email Marketing",
    "PPC Advertising",
    "Affiliate Marketing",
    "Video Editing",
    "Motion Graphics",
    "3D Animation",
    "YouTube Video Editing",
    "After Effects Editing",
    "Data Entry",
    "Virtual Assistance",
    "Customer Support",
    "Project Management",
    "Data Analysis",
    "Machine Learning",
    "AI Development",
    "Data Science",
    "Deep Learning",
    "Computer Vision",
    "Cybersecurity",
    "Penetration Testing",
    "Ethical Hacking",
    "Network Security",
    "Blockchain Development",
    "Finance Consulting",
    "Business Planning",
    "Market Research",
    "Legal Consulting",
    "HR & Recruiting"
  ];

  void updateCategoryField() {
    shopCategoryController.text = selectedCategory ?? '';
  }

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
    List<String> filteredCategories = allCategories
        .where((cat) =>
            cat.toLowerCase().contains(categorySearch.toLowerCase()) &&
            cat != selectedCategory)
        .toList();

    return Scaffold(
      body: Center(
        child: Container(
          height: 850,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 3,
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: SingleChildScrollView(
            // padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 8,
                ),
                Text(
                  "Step 1: Professional Info",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                MyTextfield(
                    hintText: "Organization", controller: orgController),
                SizedBox(height: 15),
                MyTextfield(
                    hintText: "Position", controller: positionController),
                SizedBox(height: 15),
                MyTextfield(
                  hintText: "Experience (in months)",
                  controller: experienceController,
                ),
                SizedBox(height: 15),
                MyTextfield(
                  hintText: "Shop Introduction",
                  controller: shopIntroductionController,
                ),
                SizedBox(height: 15),

                // 🔽 Shop Category Selector
                isCategoryEditing
                    ? Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TextField(
                              // autofocus: true,
                              onChanged: (value) {
                                setState(() {
                                  categorySearch = value;
                                  shopCategoryController.text = value;
                                });
                              },
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                filled: true,
                                hintText: "Search Category",
                                hintStyle: GoogleFonts.ubuntu(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                            SizedBox(height: 1),
                            if (categorySearch.isNotEmpty)
                              Wrap(
                                spacing: 8,
                                children: filteredCategories.map((cat) {
                                  return ChoiceChip(
                                    label: Text(cat),
                                    selected: false,
                                    onSelected: (_) {
                                      setState(() {
                                        selectedCategory = cat;
                                        updateCategoryField();
                                        isCategoryEditing = false;
                                        categorySearch = '';
                                      });
                                    },
                                  );
                                }).toList(),
                              ),
                          ],
                        ),
                      )
                    : GestureDetector(
                        onTap: () {
                          setState(() {
                            isCategoryEditing = true;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25.0),
                          child: AbsorbPointer(
                            absorbing: true,
                            child: TextField(
                              controller: shopCategoryController,
                              readOnly: true,
                              decoration: InputDecoration(
                                enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                  color: Theme.of(context).colorScheme.primary,
                                )),
                                focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .secondary)),
                                fillColor:
                                    Theme.of(context).colorScheme.surface,
                                filled: true,
                                hintText: "Search Category",
                                hintStyle: GoogleFonts.ubuntu(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                SizedBox(height: 15),
                MyTextfield(
                  hintText: "Service Pricing",
                  controller: priceController,
                ),
                SizedBox(height: 15),
                MyTextfield(
                    hintText: "Delivery Time (in hours)",
                    controller: deliveryController),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: TextField(
                    controller: shopDescriptionController,
                    maxLines: 6,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      fillColor: Theme.of(context).colorScheme.surface,
                      filled: true,
                      hintText: "Shop Description...",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 25),
                MyButton(text: "Next", onTap: setShopData),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
