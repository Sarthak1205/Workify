import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class EditProfilePage extends StatefulWidget {
  final String userId;
  const EditProfilePage({super.key, required this.userId});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  File? _image;
  Map<String, dynamic>? userDoc;

  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _bioController;
  late TextEditingController _dobController;
  late TextEditingController _cityController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final doc = await FirebaseFirestore.instance
        .collection('Users')
        .doc(widget.userId)
        .get();
    final data = doc.data();
    setState(() {
      userDoc = data;
    });
    if (data != null) {
      _firstNameController =
          TextEditingController(text: data['firstName'] ?? '');
      _lastNameController = TextEditingController(text: data['lastName'] ?? '');
      _bioController = TextEditingController(text: data['bio'] ?? '');
      _dobController = TextEditingController(text: data['dob'] ?? '');
      _cityController = TextEditingController(text: data['city'] ?? '');
      _countryController = TextEditingController(text: data['country'] ?? '');
      setState(() {});
    }
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<String?> _uploadProfileImage(String uid) async {
    if (_image == null) return null;
    final ref = FirebaseStorage.instance
        .ref()
        .child('profile_photos')
        .child('$uid.jpg');
    await ref.putFile(_image!);
    return await ref.getDownloadURL();
  }

  Future<void> _saveChanges() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    String? photoURL = await _uploadProfileImage(uid);

    await FirebaseFirestore.instance.collection('Users').doc(uid).set({
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'bio': _bioController.text,
      'dob': _dobController.text,
      'city': _cityController.text,
      'country': _countryController.text,
      'photoURL': photoURL,
    }, SetOptions(merge: true));

    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile", style: GoogleFonts.ubuntu()),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: userDoc!['photoURL'] != ""
                      ? NetworkImage(userDoc!['photoURL'])
                      : AssetImage("lib/images/profile.png"),
                  child: _image == null
                      ? Align(
                          alignment: Alignment.bottomRight,
                          child: Container(
                              height: 42,
                              width: 42,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(60),
                                  color: Theme.of(context).colorScheme.surface),
                              child: Icon(
                                Icons.camera_alt,
                                size: 25,
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary,
                              )))
                      : null,
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField("First Name", _firstNameController),
              _buildTextField("Last Name", _lastNameController),
              _buildTextField("Bio", _bioController, maxLines: 3),
              _buildTextField("Date of Birth", _dobController),
              _buildTextField("City", _cityController),
              _buildTextField("Country", _countryController),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: _saveChanges,
                icon: const Icon(Icons.save),
                label: const Text("Save Changes"),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
