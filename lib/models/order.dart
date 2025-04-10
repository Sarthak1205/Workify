class Order {
  final String clientId;
  final String freelancerId;
  final String orderId;
  String status;
  final int price;
  final int deliveryTime;
  final String additionalRequests;
  final String paymentStatus;
  final String transactionId;
  Map<String, dynamic> timestamps;
  Map<String, dynamic> workSubmission;

  Order({
    required this.timestamps,
    required this.workSubmission,
    required this.clientId,
    required this.freelancerId,
    required this.orderId,
    required this.status,
    required this.price,
    required this.deliveryTime,
    required this.additionalRequests,
    required this.paymentStatus,
    required this.transactionId,
  });

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'freelancerId': freelancerId,
      'orderId': orderId,
      'status': status,
      'price': price,
      'deliveryTime': deliveryTime,
      'additionalRequests': additionalRequests,
      'paymentStatus': paymentStatus,
      'transactionId': transactionId,
      'timestamps': timestamps,
      'workSubmission': workSubmission
    };
  }
}

// orders (Collection)
//  ├── {orderId} (Document)
//  │   ├── clientId: "xyz123"
//  │   ├── freelancerId: "abc456"
//  │   ├── serviceId: "service789"
//  │   ├── status: "Pending" / "In Progress" / "Completed" / "Cancelled"
//  │   ├── price: 50.00
//  │   ├── deliveryTime: "5 days"
//  │   ├── additionalRequests: "Make it blue-themed"
//  │   ├── timestamps:
//  │   │   ├── createdAt: 2025-04-01T10:00:00
//  │   │   ├── completedAt: null
//  │   ├── paymentStatus: "Paid" / "Unpaid"
//  │   ├── transactionId: "txn_001"
//  │   ├── workSubmission:
//  │   │   ├── fileUrls: ["url1", "url2"]
//  │   │   ├── submittedAt: null
