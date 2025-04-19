import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class FileViewer extends StatefulWidget {
  final String freelancerId;
  const FileViewer({super.key, required this.freelancerId});

  @override
  State<FileViewer> createState() => _FileViewerState();
}

class _FileViewerState extends State<FileViewer> {
  Map<String, List<String>> userFiles = {"images": [], "documents": []};
  bool isLoading = false;
  Map<String, int> fileSizes = {};
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    fetchFiles();
  }

  bool checkCurrFreelancer() {
    return widget.freelancerId == user!.uid;
  }

  Map<String, List<String>> sortFiles(List<String> urls) {
    List<String> imageFiles = [];
    List<String> documentFiles = [];

    for (String url in urls) {
      if (url.contains(".jpg") ||
          url.contains(".png") ||
          url.contains(".jpeg")) {
        imageFiles.add(url);
      } else {
        documentFiles.add(url);
      }
    }

    return {
      "images": imageFiles,
      "documents": documentFiles,
    };
  }

  Future<void> fetchFiles() async {
    setState(() => isLoading = true);

    if (user == null) return;

    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection("Users")
          .doc(widget.freelancerId)
          .collection("portfolio")
          .doc(widget.freelancerId)
          .get();

      if (userDoc.exists && userDoc.data() != null) {
        List<dynamic> urls =
            (userDoc.data() as Map<String, dynamic>)['urls'] ?? [];
        setState(() => userFiles = sortFiles(urls.cast<String>()));
        await fetchFileSizes();
      }
    } catch (e) {
      print("Error fetching files: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> fetchFileSizes() async {
    for (String url in userFiles["documents"]!) {
      try {
        final response = await Dio().head(url);
        if (response.headers.map.containsKey("content-length")) {
          final size =
              int.tryParse(response.headers.value("content-length") ?? '0') ??
                  0;
          fileSizes[url] = size;
        }
      } catch (e) {
        print("Error fetching size for $url: $e");
      }
    }
    setState(() {});
  }

  Future<void> uploadFile() async {
    User? currUser = FirebaseAuth.instance.currentUser;
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    setState(() => isLoading = true);

    PlatformFile file = result.files.first;
    File localFile = File(file.path!);

    try {
      String fileName = file.name;
      final ref = FirebaseStorage.instance.ref(
          'uploads/${currUser!.uid}/${DateTime.now().millisecondsSinceEpoch}_$fileName');
      await ref.putFile(localFile);
      String downloadUrl = await ref.getDownloadURL();

      User? user = FirebaseAuth.instance.currentUser;
      DocumentReference docRef = FirebaseFirestore.instance
          .collection("Users")
          .doc(user!.uid)
          .collection("portfolio")
          .doc(user.uid);

      await docRef.set({
        "urls": FieldValue.arrayUnion([downloadUrl])
      }, SetOptions(merge: true));

      await fetchFiles();
    } catch (e) {
      print("Upload failed: $e");
    } finally {
      setState(() => isLoading = false);
    }
  }

  IconData getFileIcon(String url) {
    final decodedUrl = Uri.decodeFull(url);
    final filename = decodedUrl.split('/').last.split('?').first;
    final cleanName = filename.split('_').skip(1).join('_').toLowerCase();
    if (cleanName.endsWith(".pdf")) return Icons.picture_as_pdf;
    if (cleanName.endsWith(".doc") || cleanName.endsWith(".docx")) {
      return Icons.description;
    }
    if (cleanName.endsWith(".xls") || cleanName.endsWith(".xlsx")) {
      return Icons.table_chart;
    }
    return Icons.insert_drive_file;
  }

  void showPreview(BuildContext context, String fileUrl) async {
    final dir = await getApplicationDocumentsDirectory();
    final filename = Uri.parse(fileUrl).pathSegments.last;
    final path = '${dir.path}/$filename';

    if (!File(path).existsSync()) {
      final file = File(path);
      await Dio().download(fileUrl, path);
      await file.create(recursive: true);
    }

    if (fileUrl.endsWith(".pdf")) {
      Navigator.push(context,
          MaterialPageRoute(builder: (_) => PDFViewerScreen(localPath: path)));
    } else {
      OpenFilex.open(path);
    }
  }

  String formatSize(int bytes) {
    if (bytes < 1024) return "$bytes B";
    if (bytes < 1024 * 1024) return "${(bytes / 1024).toStringAsFixed(2)} KB";
    return "${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Files"),
        centerTitle: true,
        actions: [
          checkCurrFreelancer()
              ? IconButton(
                  icon: const Icon(Icons.upload_file),
                  onPressed: uploadFile,
                )
              : Text("")
        ],
      ),
      body: isLoading
          ? Center(
              child: SpinKitCircle(
                  color: Theme.of(context).colorScheme.primary, size: 50))
          : SingleChildScrollView(
              child: Column(
                children: [
                  if (userFiles["images"]!.isNotEmpty) ...[
                    sectionTitle("Images"),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userFiles["images"]!.length,
                      padding: const EdgeInsets.all(8),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () =>
                              showPreview(context, userFiles["images"]![index]),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(userFiles["images"]![index],
                                fit: BoxFit.cover),
                          ),
                        );
                      },
                    ),
                  ],
                  if (userFiles["documents"]!.isNotEmpty) ...[
                    sectionTitle("Documents"),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: userFiles["documents"]!.length,
                      itemBuilder: (context, index) {
                        final docUrl = userFiles["documents"]![index];
                        return ListTile(
                          leading:
                              Icon(getFileIcon(docUrl), color: Colors.blue),
                          title: Text(
                            Uri.decodeFull(docUrl)
                                .split('/')
                                .last
                                .split('_')
                                .skip(1)
                                .join('_')
                                .split('?')
                                .first,
                          ),
                          subtitle: fileSizes.containsKey(docUrl)
                              ? Text("Size: ${formatSize(fileSizes[docUrl]!)}")
                              : const Text("Fetching size..."),
                          onTap: () => showPreview(context, docUrl),
                        );
                      },
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Padding sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Text(title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}

class PDFViewerScreen extends StatelessWidget {
  final String localPath;

  const PDFViewerScreen({super.key, required this.localPath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("PDF Viewer")),
      body: SfPdfViewer.file(File(localPath)),
    );
  }
}
