import 'package:flutter/material.dart';

class FreelancerSkillsWidget extends StatefulWidget {
  final List<String> skills;
  final int maxSkills;
  final Function(List<Map<String, String>>) onSkillsUpdated;
  final List<Map<String, String>> initialSkills;

  const FreelancerSkillsWidget({
    super.key,
    required this.skills,
    required this.maxSkills,
    required this.onSkillsUpdated,
    this.initialSkills = const [],
  });

  @override
  _FreelancerSkillsWidgetState createState() => _FreelancerSkillsWidgetState();
}

class _FreelancerSkillsWidgetState extends State<FreelancerSkillsWidget> {
  String? selectedSkill;
  String? selectedExperience;
  late List<Map<String, String>> addedSkills;

  List<String> experienceLevels = ["Beginner", "Intermediate", "Expert"];

  @override
  void initState() {
    super.initState();
    addedSkills = List.from(widget.initialSkills);
  }

  void addSkill() {
    if (selectedSkill != null && selectedExperience != null) {
      if (addedSkills.length < widget.maxSkills) {
        setState(() {
          addedSkills.add(
              {"skill": selectedSkill!, "experience": selectedExperience!});
        });
        widget.onSkillsUpdated(addedSkills);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("You can add only ${widget.maxSkills} skills.")),
        );
      }
    }
  }

  void removeSkill(int index) {
    setState(() {
      addedSkills.removeAt(index);
    });
    widget.onSkillsUpdated(addedSkills);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Skill Dropdown
        DropdownButtonFormField<String>(
          value: selectedSkill,
          hint: Text("Select Skill"),
          onChanged: (String? newValue) {
            setState(() {
              selectedSkill = newValue;
            });
          },
          items: widget.skills.map((String skill) {
            return DropdownMenuItem<String>(
              value: skill,
              child: Text(skill),
            );
          }).toList(),
        ),

        SizedBox(height: 10),

        // Experience Level Dropdown
        DropdownButtonFormField<String>(
          value: selectedExperience,
          hint: Text("Experience Level"),
          onChanged: (String? newValue) {
            setState(() {
              selectedExperience = newValue;
            });
          },
          items: experienceLevels.map((String level) {
            return DropdownMenuItem<String>(
              value: level,
              child: Text(level),
            );
          }).toList(),
        ),

        SizedBox(height: 10),

        // Add Skill Button
        ElevatedButton(
          onPressed: addSkill,
          child: Text("Add Skill"),
        ),

        SizedBox(height: 20),

        // Added Skills List
        ...addedSkills.map((skill) {
          return ListTile(
            title: Text(skill["skill"]!),
            subtitle: Text("Experience: ${skill["experience"]}"),
            trailing: IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () => removeSkill(addedSkills.indexOf(skill)),
            ),
          );
        }).toList(),
      ],
    );
  }
}
