import 'package:flutter/material.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';
import 'package:workify/pages/first_setup/shop_setup.dart';
import 'package:workify/services/auth/auth.dart';
import 'package:workify/services/userinfo/user_info_services.dart';

class ClientProfileSetup extends StatefulWidget {
  const ClientProfileSetup({super.key});

  @override
  State<ClientProfileSetup> createState() => _ClientProfileSetupState();
}

class _ClientProfileSetupState extends State<ClientProfileSetup> {
  final _info = UserInfoServices();

  @override
  Widget build(BuildContext context) {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();
    final genderController = TextEditingController();
    final cityController = TextEditingController();
    final countryController = TextEditingController();
    final bioController = TextEditingController();
    final dobController = TextEditingController();

    void setUserInfo() {
      List<String> userInfo = [
        firstNameController.text.trim(),
        lastNameController.text.trim(),
        genderController.text.trim(),
        cityController.text.trim(),
        countryController.text.trim(),
        bioController.text,
        dobController.text.trim()
      ];
      bool valid = true;

      for (String i in userInfo) {
        if (i.isEmpty || i.trim().isEmpty) {
          valid = false;
          break;
        }
      }

      if (valid) {
        //add to firestore
        _info.setUserInfo(
            firstNameController.text,
            lastNameController.text,
            genderController.text,
            cityController.text,
            countryController.text,
            bioController.text,
            dobController.text);
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => AuthPage()));
      } else {
        showDialog(
            context: context,
            builder: (context) => AboutDialog(
                  children: [Text("Text Fields Cannot be empty")],
                ));
        return;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Workify"),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 30.0),
        child: Column(
          children: [
            Text(
              "Welcome! Let's start with some basic information",
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 30.0),
                child: Container(
                  height: 650,
                  width: 350,
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Theme.of(context).colorScheme.primary,
                          width: 3),
                      borderRadius: BorderRadius.circular(25)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 25,
                      ),
                      MyTextfield(
                          hintText: "First Name",
                          controller: firstNameController),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextfield(
                          hintText: "Last Name",
                          controller: lastNameController),
                      SizedBox(
                        height: 15,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          GestureDetector(
                            onTap: () => {genderController.text = "Male"},
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              child: Icon(
                                Icons.male_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => {
                              genderController.text = "Female",
                            },
                            child: Container(
                              height: 65,
                              width: 65,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                      width: 3,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              child: Icon(
                                Icons.female_outlined,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextfield(hintText: "City", controller: cityController),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextfield(
                          hintText: "Country", controller: countryController),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextfield(hintText: "Bio", controller: bioController),
                      SizedBox(
                        height: 15,
                      ),
                      MyTextfield(
                          hintText: "Date of Birth", controller: dobController),
                      SizedBox(
                        height: 35,
                      ),
                      if (_info.checkFreelancer()) ...[
                        MyButton(
                          text: "Next",
                          onTap: () {
                            setUserInfo();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShopSetupPage()));
                          },
                        )
                      ] else ...[
                        MyButton(
                          text: "Finish",
                          onTap: setUserInfo,
                        )
                      ]
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
