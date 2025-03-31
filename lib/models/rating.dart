import 'package:cloud_firestore/cloud_firestore.dart';

class Rating {
  int rating;
  final String custID;
  final Timestamp time;
  final String reviewText;

  Rating({
    required this.custID,
    required this.rating,
    required this.reviewText,
    required this.time,
  });

  Map<String, dynamic> toMap() {
    return {
      "custID": custID,
      "rating": rating,
      "reviewText": reviewText,
      "time": time,
    };
  }

  factory Rating.fromMap(Map<String, dynamic> data) {
    return Rating(
      custID: data["custID"],
      rating: data["rating"],
      reviewText: data["reviewText"],
      time: data["time"] ?? Timestamp.now(),
    );
  }
}
