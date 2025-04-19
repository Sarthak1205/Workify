import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/chat/chat_page.dart';
import 'package:workify/pages/order/order_submissions_page.dart';
import 'package:workify/pages/shop_page.dart';

class ViewOrderPage extends StatefulWidget {
  final DocumentSnapshot orderDoc;
  const ViewOrderPage({super.key, required this.orderDoc});

  @override
  State<ViewOrderPage> createState() => _ViewOrderPageState();
}

class _ViewOrderPageState extends State<ViewOrderPage> {
  String docId = "";
  int activeStep = 0;
  final int totalSteps = 3;
  final _firestore = FirebaseFirestore.instance;
  String status = "";
  Map<String, dynamic> clientDoc = {};
  Map<String, dynamic> freelancerDoc = {};

  @override
  void initState() {
    super.initState();
    fetchDocId();
    getClientDetails();
    getFreelancerDetails();
    getSteps();
  }

  void getSteps() {
    if (widget.orderDoc['status'] == "In Progress") {
      setState(() {
        activeStep = 1;
      });
    } else if (widget.orderDoc['status'] == "Completed") {
      setState(() {
        activeStep = 2;
      });
    } else if (widget.orderDoc['status'] == "Pending") {
      setState(() {
        activeStep = 0;
      });
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
            SizedBox(
              height: 20,
            ),
            _buildTitle(text: "Order Status"),
            SizedBox(
              height: 15,
            ),
            _buildProgressBar(),
            _buildProgressBarSubtitle(),
            SizedBox(
              height: 10,
            ),
            _buildTitle(text: "Order Details"),
            _buildSubTitle(text: "Client Name  "),
            _buildChildText(
                text: "${clientDoc['firstName']} ${clientDoc['lastName']}"),
            _buildSubTitle(text: "Freelancer Name"),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShopPage(shopId: freelancerDoc['uid'])));
              },
              child: _buildChildText(
                  text:
                      "${freelancerDoc['firstName']} ${freelancerDoc['lastName']}"),
            ),
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
                : Column(
                    children: [
                      _buildSubTitle(text: "Work Submission"),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 16.0, right: 16, top: 5),
                        child: Text(
                          "Order Submitted will be available once the order is completed",
                          style: GoogleFonts.ubuntu(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ),
                    ],
                  ),
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
            Icon(
              index <= activeStep ? Icons.circle_sharp : Icons.circle_outlined,
              color: Theme.of(context).colorScheme.secondary,
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

  void getFreelancerDetails() async {
    var snapshot = await _firestore
        .collection("Users")
        .doc(widget.orderDoc['freelancerId'])
        .get();

    setState(() {
      freelancerDoc = snapshot.data()!;
    });
  }
}
