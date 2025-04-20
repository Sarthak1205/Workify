// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:workify/components/my_button.dart';
import 'package:workify/components/my_textfield.dart';
import 'package:workify/models/order.dart';

class UpiPaymentPage extends StatefulWidget {
  final String freelancerId;
  const UpiPaymentPage({super.key, required this.freelancerId});

  @override
  State<UpiPaymentPage> createState() => _UpiPaymentPageState();
}

class _UpiPaymentPageState extends State<UpiPaymentPage> {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  late Razorpay _razorpay;

  User? client;
  DocumentSnapshot<Map<String, dynamic>>? shop;

  Orders order = Orders(
    timestamps: {},
    workSubmission: [],
    clientId: "clientId",
    freelancerId: "freelancerId",
    orderId: "orderId",
    status: "status",
    price: 4,
    deliveryTime: 4,
    additionalRequests: "additionalRequests",
    paymentStatus: "paymentStatus",
    transactionId: "transactionId",
  );

  final requestController = TextEditingController();
  final phoneController = TextEditingController();
  String? transactionId = "";

  @override
  void initState() {
    super.initState();
    client = _auth.currentUser;
    fetchShop();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  Future<void> fetchShop() async {
    try {
      var shopSnapshot =
          await _firestore.collection("Shops").doc(widget.freelancerId).get();

      if (shopSnapshot.exists) {
        setState(() {
          shop = shopSnapshot;
        });
      } else {
        print("Shop document does not exist.");
      }
    } catch (e) {
      print("Error fetching shop: $e");
    }
  }

  void createOrder() async {
    if (client == null || shop == null) return;

    final newOrder = Orders(
      timestamps: {"createdAt": DateTime.now().toString(), "submittedAt": ""},
      workSubmission: [],
      clientId: client!.uid,
      freelancerId: widget.freelancerId,
      orderId: Uuid().v4(),
      status: "Pending",
      price: shop!['price'],
      deliveryTime: shop!['deliveryTime'],
      additionalRequests: requestController.text,
      paymentStatus: "Success",
      transactionId: "$transactionId",
    );

    setState(() {
      order = newOrder;
    });

    await _firestore.collection("Orders").add(order.toMap());
    await _firestore
        .collection("Users")
        .doc(client!.uid)
        .set({"phoneNo": phoneController.text}, SetOptions(merge: true));
  }

  void _openCheckout() {
    if (shop == null || client == null) return;

    var options = {
      'key': 'rzp_test_gUFY8gITsO9r36',
      'amount': (shop!['price'] + 3) * 100,
      'name': shop!["shopCategory"],
      'description': shop!['shopIntro'],
      'prefill': {
        'contact': phoneController.text,
        'email': client!.email,
      },
      'method': {
        'upi': true,
        'card': false,
        'netbanking': false,
      },
      'theme': {'color': '#711de4'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    setState(() {
      transactionId = response.paymentId;
    });

    createOrder();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Successful!"),
        content: Text("Payment ID: ${response.paymentId}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Payment Failed"),
        content: Text("Error: ${response.code}\n${response.message}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Try Again!"),
          )
        ],
      ),
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("External Wallet: ${response.walletName}")),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (shop == null || client == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay with UPI"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder(
          future: _firestore.collection("Users").doc(client!.uid).get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            var userDoc = snapshot.data!;
            return Container(
              height: 400,
              width: 325,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MyTextfield(
                      hintText: "Phone Number",
                      controller: phoneController,
                    ),
                    MyTextfield(
                      hintText: "Additional Requests",
                      controller: requestController,
                      maxLines: 2,
                    ),
                    MyButton(
                      text: "Pay Now",
                      onTap: () {
                        if (phoneController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Enter Phone Number")),
                          );
                        } else {
                          _openCheckout();
                        }
                      },
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
