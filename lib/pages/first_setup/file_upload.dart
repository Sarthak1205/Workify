import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/services/auth/auth.dart';
import 'package:workify/services/shop/shop_service.dart';
import 'package:workify/services/userinfo/portfolio_services.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  bool readyToNext = false;
  // File? profileImage;
  File? bannerImage;
  List<PlatformFile> selectedFiles = [];
  String buttonText = "Next 🚫";
  final _portfolio = PortfolioServices();

// Future<void> _pickProfilefromCamera() async {
//     final returnedImage =
//         await ImagePicker().pickImage(source: ImageSource.camera);
//     if (returnedImage == null) return;
//     setState(() {
//       bannerImage = File(returnedImage.path);
//     });
//   }

//   Future<void> _pickProfilefromGallery() async {
//     final returnedImage =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (returnedImage == null) return;
//     setState(() {
//       bannerImage = File(returnedImage.path);
//     });
//   }

  Future<void> _pickBannerfromCamera() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (returnedImage == null) return;
    setState(() {
      bannerImage = File(returnedImage.path);
    });
  }

  Future<void> _pickBannerfromGallery() async {
    final returnedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (returnedImage == null) return;
    setState(() {
      bannerImage = File(returnedImage.path);
    });
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.any);
    if (result != null) {
      if (result.files.length > 5 || result.files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Cannot add more that 5 files")));
      } else {
        setState(() {
          selectedFiles = result.files;
          readyToNext = true;
          buttonText = "Next";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 740,
          width: 350,
          decoration: BoxDecoration(
            border: Border.all(
                width: 3, color: Theme.of(context).colorScheme.primary),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "Step 3: Upload Files",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 12),
                child: Row(
                  children: [
                    Text(
                      "Pick a banner for your shop  ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: _pickBannerfromCamera,
                        icon: Icon(Icons.camera_alt_outlined)),
                    IconButton(
                        onPressed: _pickBannerfromGallery,
                        icon: Icon(Icons.drive_folder_upload)),
                  ],
                ),
              ),
              SizedBox(height: 15),
              bannerImage != null
                  ? Image.file(
                      bannerImage!,
                      width: 200,
                      height: 200,
                      fit: BoxFit.fill,
                    )
                  : Text("Please upload an image"),
              SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(
                    left: 16.0, top: 12, bottom: 11, right: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Please upload files for Portfolio (5)",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                        onPressed: pickFiles,
                        icon: Icon(Icons.file_upload_outlined)),
                  ],
                ),
              ),
              selectedFiles.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: selectedFiles.map((file) {
                        final fileName = file.name;
                        final fileSize = (file.size / 1024).toStringAsFixed(2);
                        final fileType = file.extension ?? "Unknown";

                        return Padding(
                          padding: const EdgeInsets.only(left: 16.0, bottom: 8),
                          child: Text(
                            "$fileName | $fileSize KB | Type: $fileType",
                            textAlign: TextAlign.left,
                          ),
                        );
                      }).toList(),
                    )
                  : Text("No file selected"),
              SizedBox(height: 25),
              MyButton(
                text: buttonText,
                onTap: () => {
                  if (readyToNext)
                    {
                      _portfolio.uploadImageToFirebase(
                          bannerImage!.path, "banners"),
                      _portfolio.uploadMultipleFiles(selectedFiles),
                      ShopService().setShopInfo3,
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                title: Text("Files Uploaded"),
                              )),
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => AuthPage()))
                    }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
