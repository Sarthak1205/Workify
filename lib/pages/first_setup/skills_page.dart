import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_selector.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  List<Map<String, String>> selectedSkills = [];

  void updateSkills(List<Map<String, String>> newSkills) {
    setState(() {
      selectedSkills = newSkills;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 800,
                width: 500,
                decoration: BoxDecoration(
                  border: Border.all(
                      width: 3, color: Theme.of(context).colorScheme.primary),
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(30.0),
                  child: Column(
                    children: [
                      Text(
                        "Step 2: Add Upto 5 Skills",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      FreelancerSkillsWidget(
                        skills: [
                          "Flutter",
                          "Dart",
                          "Firebase",
                          "UI/UX",
                          "Voice Over"
                        ],
                        maxSkills: 5,
                        initialSkills: selectedSkills,
                        onSkillsUpdated: updateSkills,
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MyButton(text: "Next"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
