import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class UpiPaymentPage extends StatefulWidget {
  const UpiPaymentPage({super.key});

  @override
  State<UpiPaymentPage> createState() => _UpiPaymentPageState();
}

class _UpiPaymentPageState extends State<UpiPaymentPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
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

  void _openCheckout() {
    final auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    var options = {
      'key': 'rzp_test_gUFY8gITsO9r36',
      'amount': 5000,
      'name': 'Workify',
      'description': 'Payment for a service',
      'prefill': {
        'contact': '9876543210',
        'email': user!.email,
      },
      'method': {
        'upi': true,
        'card': false,
        'netbanking': false,
      },
      'theme': {'color': '#3399cc'}
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
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
            child: const Text("Try Again"),
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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pay with UPI"),
        centerTitle: true,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: _openCheckout,
          icon: const Icon(Icons.payments),
          label: const Text("Pay ₹50 via UPI"),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            textStyle: const TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
