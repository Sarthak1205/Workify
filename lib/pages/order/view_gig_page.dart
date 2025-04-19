// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/pages/chat/chat_page.dart';
import 'package:workify/pages/order/order_submissions_page.dart';
import 'package:workify/services/orders/order_services.dart';

class ViewGigPage extends StatefulWidget {
  final DocumentSnapshot orderDoc;
  const ViewGigPage({super.key, required this.orderDoc});

  @override
  State<ViewGigPage> createState() => _ViewGigPageState();
}

class _ViewGigPageState extends State<ViewGigPage> {
  String docId = "";
  int activeStep = 0;
  final int totalSteps = 3;
  final _firestore = FirebaseFirestore.instance;
  String status = "";
  Map<String, dynamic> clientDoc = {};
  List<PlatformFile> selectedFiles = [];
  final _order = OrderServices();

  @override
  void initState() {
    super.initState();
    fetchDocId();
    getClientDetails();
  }

  Future<void> pickFiles() async {
    final result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.any);
    if (result != null) {
      if (result.files.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            content:
                _buildChildText(text: "Add files to complete your order")));
      } else {
        setState(() {
          selectedFiles = result.files;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool checkCompleted = widget.orderDoc['status'] == "Completed";
    String? submitDate;
    if (checkCompleted) {
      DateTime submittedAt =
          DateTime.parse(widget.orderDoc['timestamps']['submittedAt']);
      submitDate =
          "${submittedAt.day}-${submittedAt.month}-${submittedAt.year}";
    }
    DateTime now = DateTime.now();
    DateTime orderedAt =
        DateTime.parse(widget.orderDoc['timestamps']['createdAt']);
    DateTime dueDate =
        orderedAt.add(Duration(hours: widget.orderDoc['deliveryTime']));
    DateTime remainingTime =
        dueDate.subtract(Duration(days: now.day, hours: now.hour));
    String due = "${dueDate.day}-${dueDate.month}-${dueDate.year}";
    return Scaffold(
      appBar: AppBar(
        title: Text("Gig Details"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildTitle(text: "Status"),
            _buildProgressBar(),
            _buildProgressBarSubtitle(),
            SizedBox(
              height: 6,
            ),
            _buildTitle(text: "Order Details"),
            _buildSubTitle(text: "Client Name  "),
            _buildChildText(
                text: "${clientDoc['firstName']} ${clientDoc['lastName']}"),
            _buildSubTitle(text: "Additional Requests"),
            _buildChildText(text: "${widget.orderDoc['additionalRequests']}"),
            _buildSubTitle(text: "Amount Paid"),
            _buildChildText(text: "₹ ${widget.orderDoc['price']}"),
            checkCompleted
                ? _buildSubTitle(text: "Submitted On")
                : _buildSubTitle(text: "Due On"),
            checkCompleted
                ? _buildChildText(text: "$submitDate")
                : _buildChildText(
                    text:
                        "$due    ( ${remainingTime.day} day(s) ${remainingTime.hour} hour(s) remaining )"),
            checkCompleted
                ? Row(
                    spacing: 30,
                    children: [
                      _buildSubTitle(text: "Work Submission"),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OrderSubmissionsPage(
                                              orderId: docId)));
                            },
                            icon: Icon(
                              Icons.file_open_outlined,
                              size: 24,
                            )),
                      )
                    ],
                  )
                : Row(
                    spacing: 150,
                    children: [
                      _buildSubTitle(text: "Work Submission"),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 8),
                        child: IconButton(
                            onPressed: pickFiles,
                            icon: Icon(
                              Icons.file_upload_outlined,
                              size: 24,
                            )),
                      )
                    ],
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16),
              child: Text(
                checkCompleted
                    ? "This order has been completed you can see your submitted work by clicking the icon above!"
                    : "* Upload the order files here and keep changing the status as you go, so your client can know what you're up to! Once you set the order to *Completed* you cannot change it back",
                style: GoogleFonts.ubuntu(
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            checkCompleted
                ? SizedBox(
                    height: 4,
                  )
                : selectedFiles.isNotEmpty
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: selectedFiles.map((file) {
                          final fileName = file.name;
                          final fileSize =
                              (file.size / 1024).toStringAsFixed(2);
                          final fileType = file.extension ?? "Unknown";
                          return Padding(
                            padding:
                                const EdgeInsets.only(left: 16.0, bottom: 8),
                            child: Text(
                              "$fileName | $fileSize KB | Type: $fileType",
                              textAlign: TextAlign.left,
                              style: GoogleFonts.ubuntu(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary),
                            ),
                          );
                        }).toList(),
                      )
                    : Text("No file selected"),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatPage(
                        receiverEmail: clientDoc['email'],
                        receiverID: clientDoc['uid'])));
          },
          child: Container(
              height: 50,
              width: 50,
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(50)),
              child: Icon(
                Icons.chat_outlined,
                color: Theme.of(context).colorScheme.inversePrimary,
              )),
        ),
      ),
    );
  }

  Widget _buildTitle({
    required String text,
  }) {
    return Row(spacing: 15, children: [
      Text(
        text,
        style: GoogleFonts.ubuntu(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    ]);
  }

  Widget _buildSubTitle({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 12),
      child: Row(children: [
        Text(
          text,
          style: GoogleFonts.ubuntu(
            fontSize: 18,
            fontWeight: FontWeight.normal,
          ),
        ),
      ]),
    );
  }

  Widget _buildChildText({
    required String text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 5),
      child: Row(children: [
        Text(
          text,
          style: GoogleFonts.ubuntu(
              fontSize: 16,
              fontWeight: FontWeight.normal,
              color: Theme.of(context).colorScheme.inversePrimary),
        ),
      ]),
    );
  }

  Widget _buildProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(totalSteps, (index) {
        return Row(
          children: [
            IconButton(
              icon: Icon(
                index <= activeStep
                    ? Icons.circle_sharp
                    : Icons.circle_outlined,
                color: Theme.of(context).colorScheme.secondary,
              ),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(
                            "Are you sure you want to update the status of the order?",
                            style: GoogleFonts.ubuntu(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                          ),
                          actions: [
                            MyButton(
                              text: "Yes",
                              onTap: () {
                                if (index == 2 && selectedFiles.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          backgroundColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          content: _buildChildText(
                                              text:
                                                  "Add files to complete your order!")));
                                } else {
                                  setState(() {
                                    activeStep = index;
                                  });
                                  setStatus();
                                  if (activeStep == 2) {
                                    _order.uploadWorkFiles(
                                        selectedFiles, docId);
                                  }
                                }
                                Navigator.pop(context);
                              },
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MyButton(
                              text: "No, Go Back",
                              onTap: () {
                                Navigator.pop(context);
                              },
                            )
                          ],
                        ));
              },
            ),
            if (index < totalSteps - 1)
              Text(
                "•••••••••••••••••••••••",
                style:
                    TextStyle(color: Theme.of(context).colorScheme.secondary),
              ),
          ],
        );
      }),
    );
  }

  Widget _buildProgressBarSubtitle() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        spacing: 15,
        children: [
          Text(
            "Pending",
            style: GoogleFonts.ubuntu(
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
          SizedBox(
            width: 35,
          ),
          Text(
            "In Progress",
            style: GoogleFonts.ubuntu(
                color: Theme.of(context).colorScheme.inversePrimary),
          ),
          SizedBox(
            width: 20,
          ),
          Text(
            "Completed",
            style: GoogleFonts.ubuntu(
                color: Theme.of(context).colorScheme.inversePrimary),
          )
        ],
      ),
    );
  }

  void setIndicator() {
    if (activeStep == 1) {
      setState(() {
        status = "In Progress";
      });
    } else if (activeStep == 2) {
      setState(() {
        status = "Completed";
      });
    } else if (activeStep == 0) {
      setState(() {
        status = "Pending";
      });
    }
  }

  void setStatus() async {
    setIndicator();
    await _firestore
        .collection("Orders")
        .doc(docId)
        .set({"status": status}, SetOptions(merge: true));
  }

  void fetchDocId() async {
    final snapshot = await _firestore.collection('Orders').get();
    for (var doc in snapshot.docs) {
      if (doc.data()['orderId'] == widget.orderDoc['orderId']) {
        setState(() {
          docId = doc.id;
        });
        break;
      }
    }
    if (widget.orderDoc['status'] == "Pending") {
      setState(() {
        activeStep = 0;
      });
    } else if (widget.orderDoc['status'] == "In Progress") {
      setState(() {
        activeStep = 1;
      });
    } else if (widget.orderDoc['status'] == "Completed") {
      setState(() {
        activeStep = 2;
      });
    }
  }

  void getClientDetails() async {
    var snapshot = await _firestore
        .collection("Users")
        .doc(widget.orderDoc['clientId'])
        .get();

    setState(() {
      clientDoc = snapshot.data()!;
    });
  }
}
