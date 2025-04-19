import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:workify/pages/order/view_order_page.dart';
import 'package:workify/services/orders/order_services.dart';

class MyOrdersPage extends StatelessWidget {
  MyOrdersPage({super.key});

  final _orderService = OrderServices();
  final _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Your Orders",
          style: GoogleFonts.ubuntu(),
        ),
        centerTitle: true,
      ),
      body: _buildGigsList(context),
    );
  }

  Widget _buildGigsList(BuildContext context) {
    return FutureBuilder(
        future: _orderService.getMyOrders(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Error");
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text("Loading...");
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No Orders Here",
                style: GoogleFonts.ubuntu(
                    fontSize: 24,
                    color: Theme.of(context).colorScheme.inversePrimary),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildChatItem(doc, context))
                .toList(),
          );
        });
  }

  Widget _buildChatItem(DocumentSnapshot doc, BuildContext context) {
    // DateTime now = DateTime.now();
    bool checkCompleted = doc['status'] == "Completed";
    String? submitDate;
    if (checkCompleted) {
      DateTime submittedAt = DateTime.parse(doc['timestamps']['submittedAt']);
      submitDate =
          "${submittedAt.day}-${submittedAt.month}-${submittedAt.year}";
    }

    DateTime orderedAt = DateTime.parse(doc['timestamps']['createdAt']);
    DateTime dueDate = orderedAt.add(Duration(hours: doc['deliveryTime']));

    String due = "${dueDate.day}-${dueDate.month}-${dueDate.year}";
    return FutureBuilder(
        future: _firestore.collection("Users").doc(doc['freelancerId']).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          var userDoc = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ViewOrderPage(orderDoc: doc)));
              },
              child: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  height: 70,
                  width: 100,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        Icon(Icons.person_2_outlined),
                        SizedBox(
                          width: 25,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "${userDoc['firstName']} ${userDoc['lastName']}",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 19,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                              Text(
                                "${doc['additionalRequests']}",
                                style: GoogleFonts.ubuntu(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                softWrap: false,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Status: ${doc['status']}",
                                style: GoogleFonts.ubuntu(
                                    fontSize: 16,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary)),
                            checkCompleted
                                ? Text(
                                    "Submitted On : $submitDate",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary),
                                  )
                                : Text(
                                    "Due on: $due",
                                    style: GoogleFonts.ubuntu(
                                        fontSize: 16,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary),
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
