import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_selector.dart';
import 'package:workify/pages/first_setup/file_upload.dart';
import 'package:workify/services/shop/shop_service.dart';

class SkillsPage extends StatefulWidget {
  const SkillsPage({super.key});

  @override
  State<SkillsPage> createState() => _SkillsPageState();
}

class _SkillsPageState extends State<SkillsPage> {
  String? selectedCategory;
  List<Map<String, String>> selectedSkills = [];

  List<String> availableSkills = [];

  final _firestore = FirebaseFirestore.instance;

  /// This map should include ALL category-to-skills mapping
  /// Truncated for example
  final Map<String, List<String>> categorySkillsMap = {
    "Graphic Design": [
      "Logo Design",
      "Branding",
      "Flyer Design",
      "Brochure Design",
      "Business Card Design",
      "T-shirt Design",
      "Packaging Design",
      "Poster Design",
      "Banner Design",
      "Infographic Design",
    ],
    "Logo Design": [
      "Minimalist Logo",
      "Mascot Logo",
      "Vintage Logo",
      "3D Logo",
      "Signature Logo",
      "Emblem Logo",
      "Typography Logo",
    ],
    "Illustration": [
      "Children's Book Illustration",
      "Character Design",
      "Portrait Illustration",
      "Technical Illustration",
      "Editorial Illustration",
    ],
    "UI/UX Design": [
      "Wireframing",
      "Prototyping",
      "User Research",
      "Mobile UI Design",
      "Web UI Design",
      "Interaction Design",
    ],
    "Web Design": [
      "Landing Page Design",
      "Portfolio Design",
      "eCommerce Web Design",
      "Responsive Design",
      "Figma to HTML",
    ],
    "Frontend Development": [
      "HTML/CSS",
      "JavaScript",
      "React",
      "Vue.js",
      "Tailwind CSS",
      "Bootstrap",
    ],
    "Backend Development": [
      "Node.js",
      "Express.js",
      "Django",
      "Flask",
      "Laravel",
      "Spring Boot",
    ],
    "Full-Stack Development": [
      "MERN Stack",
      "MEAN Stack",
      "LAMP Stack",
      "Firebase Integration",
      "API Development",
    ],
    "Flutter Development": [
      "UI Implementation",
      "State Management",
      "Firebase Integration",
      "Cross-platform Apps",
      "Animations in Flutter",
    ],
    "React Development": [
      "React Hooks",
      "React Router",
      "Next.js",
      "Redux",
      "Styled Components",
    ],
    "Mobile App Development": [
      "Android Development",
      "iOS Development",
      "Flutter",
      "React Native",
      "Cross-Platform Apps",
    ],
    "Android Development": [
      "Kotlin",
      "Java",
      "Jetpack Compose",
      "Room DB",
      "Firebase Android",
    ],
    "iOS Development": [
      "Swift",
      "SwiftUI",
      "Core Data",
      "iOS UI/UX",
      "Firebase iOS",
    ],
    "Game Development": [
      "Unity",
      "Unreal Engine",
      "2D Game Dev",
      "3D Game Dev",
      "Mobile Games",
    ],
    "WordPress Development": [
      "Theme Customization",
      "Plugin Development",
      "WooCommerce",
      "Speed Optimization",
      "Elementor Design",
    ],
    "Copywriting": [
      "Sales Copy",
      "Ad Copy",
      "Landing Page Copy",
      "Product Descriptions",
      "Email Copy",
    ],
    "Content Writing": [
      "Blog Posts",
      "Article Writing",
      "Website Content",
      "Newsletter Writing",
      "Whitepapers",
    ],
    "SEO Writing": [
      "Keyword Research",
      "On-Page SEO",
      "Meta Descriptions",
      "SEO Blogs",
      "Backlink Strategy",
    ],
    "Technical Writing": [
      "API Documentation",
      "User Manuals",
      "Software Guides",
      "Product Specs",
      "Research Papers",
    ],
    "Ghostwriting": [
      "Books",
      "Blogs",
      "Memoirs",
      "Business Writing",
      "Scripts",
    ],
    "Social Media Marketing": [
      "Instagram Marketing",
      "Facebook Marketing",
      "LinkedIn Strategy",
      "Content Calendars",
      "Social Media Ads",
    ],
    "SEO Optimization": [
      "Technical SEO",
      "On-Page SEO",
      "Off-Page SEO",
      "Local SEO",
      "Website Audits",
    ],
    "Email Marketing": [
      "Newsletter Campaigns",
      "Email Automation",
      "Mailchimp",
      "Klaviyo",
      "Drip Campaigns",
    ],
    "PPC Advertising": [
      "Google Ads",
      "Facebook Ads",
      "Instagram Ads",
      "A/B Testing",
      "Conversion Tracking",
    ],
    "Affiliate Marketing": [
      "Affiliate Setup",
      "Content for Affiliates",
      "Affiliate Strategy",
      "Influencer Outreach",
      "Performance Tracking",
    ],
    "Video Editing": [
      "YouTube Video Editing",
      "Reels Editing",
      "Podcast Video Editing",
      "Color Grading",
      "Sound Syncing",
    ],
    "Motion Graphics": [
      "Intro/Outro Animation",
      "Explainer Videos",
      "Text Animation",
      "Social Media Animations",
      "Promo Videos",
    ],
    "3D Animation": [
      "Character Animation",
      "Product Animation",
      "Explainer Animation",
      "3D Modeling",
      "3D Rigging",
    ],
    "YouTube Video Editing": [
      "Thumbnails",
      "Intros/Outros",
      "Sound Effects",
      "Subtitles",
      "Trimming",
    ],
    "After Effects Editing": [
      "Template Customization",
      "Transitions",
      "Motion Typography",
      "Explainers",
      "Visual Effects",
    ],
    "Data Entry": [
      "Excel Data Entry",
      "Web Research",
      "PDF Conversion",
      "CRM Data Input",
      "Manual Typing",
    ],
    "Virtual Assistance": [
      "Inbox Management",
      "Calendar Scheduling",
      "Customer Follow-up",
      "Data Organization",
      "File Management",
    ],
    "Customer Support": [
      "Live Chat Support",
      "Email Support",
      "CRM Tools",
      "Zendesk",
      "Ticketing Systems",
    ],
    "Project Management": [
      "Agile Management",
      "Scrum Master",
      "Trello",
      "JIRA",
      "Team Coordination",
    ],
    "Data Analysis": [
      "Excel Analysis",
      "Power BI",
      "Tableau",
      "SQL Queries",
      "Data Visualization",
    ],
    "Machine Learning": [
      "Model Training",
      "Supervised Learning",
      "Unsupervised Learning",
      "TensorFlow",
      "Scikit-Learn",
    ],
    "AI Development": [
      "Chatbots",
      "NLP",
      "Recommendation Systems",
      "AI APIs",
      "Generative AI",
    ],
    "Data Science": [
      "Data Cleaning",
      "EDA",
      "Predictive Modeling",
      "Big Data Tools",
      "Python for Data Science",
    ],
    "Deep Learning": [
      "Neural Networks",
      "CNNs",
      "RNNs",
      "PyTorch",
      "Image Classification",
    ],
    "Computer Vision": [
      "Image Recognition",
      "Object Detection",
      "Face Recognition",
      "OpenCV",
      "OCR",
    ],
    "Cybersecurity": [
      "Vulnerability Assessment",
      "Security Audits",
      "SIEM Tools",
      "Incident Response",
      "Network Monitoring",
    ],
    "Penetration Testing": [
      "Web App Testing",
      "Mobile App Testing",
      "Network Testing",
      "Exploit Writing",
      "Red Teaming",
    ],
    "Ethical Hacking": [
      "CEH Prep",
      "Social Engineering",
      "Metasploit",
      "Wireless Hacking",
      "Privilege Escalation",
    ],
    "Network Security": [
      "Firewall Configuration",
      "IDS/IPS Setup",
      "VPNs",
      "Network Architecture",
      "Threat Detection",
    ],
    "Blockchain Development": [
      "Smart Contracts",
      "DApps",
      "Ethereum",
      "Solidity",
      "NFT Platforms",
    ],
    "Finance Consulting": [
      "Financial Modeling",
      "Budget Planning",
      "Investment Strategy",
      "Cash Flow Analysis",
      "Tax Advisory",
    ],
    "Business Planning": [
      "Business Plans",
      "Pitch Decks",
      "Feasibility Studies",
      "SWOT Analysis",
      "Growth Strategy",
    ],
    "Market Research": [
      "Competitor Analysis",
      "Consumer Surveys",
      "Industry Trends",
      "SWOT Reports",
      "Product Research",
    ],
    "Legal Consulting": [
      "Contracts",
      "Business Law",
      "IP Rights",
      "Terms & Conditions",
      "Privacy Policy Drafting",
    ],
    "HR & Recruiting": [
      "Talent Sourcing",
      "Resume Screening",
      "Job Descriptions",
      "Interview Scheduling",
      "Onboarding Docs",
    ],
  };

  @override
  void initState() {
    super.initState();
    fetchCategoryFromFirestore();
  }

  Future<void> fetchCategoryFromFirestore() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      DocumentSnapshot shopDoc = await FirebaseFirestore.instance
          .collection("Shops")
          .doc(user.uid)
          .get();

      if (shopDoc.exists && shopDoc.data() != null) {
        Map<String, dynamic> data = shopDoc.data() as Map<String, dynamic>;
        selectedCategory = data["shopCategory"];

        setState(() {
          availableSkills = categorySkillsMap[selectedCategory] ?? [];
        });
      }
    }
  }

  void updateSkills(List<Map<String, String>> newSkills) {
    setState(() {
      selectedSkills = newSkills;
    });
  }

  Future<void> setSkills() async {
    User? user = FirebaseAuth.instance.currentUser;

    await _firestore
        .collection("Users")
        .doc(user!.uid)
        .collection("portfolio")
        .doc(user.uid)
        .set({"skills": selectedSkills}, SetOptions(merge: true));

    await ShopService().setShopInfo2(selectedSkills);
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
                        "Step 2: Add Up to 5 Skills",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 25),

                      // Skill Selector - only shown when availableSkills is ready
                      availableSkills.isNotEmpty
                          ? FreelancerSkillsWidget(
                              skills: availableSkills,
                              maxSkills: 5,
                              initialSkills: selectedSkills,
                              onSkillsUpdated: updateSkills,
                            )
                          : CircularProgressIndicator(),

                      SizedBox(height: 15),
                      MyButton(
                        text: "Next",
                        onTap: () async {
                          await setSkills();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FileUpload()),
                          );
                        },
                      ),
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
